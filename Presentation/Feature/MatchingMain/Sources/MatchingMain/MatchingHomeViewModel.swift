//
//  MatchingHomeViewModel.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import UseCases
import Entities
import LocalStorage
import PCAmplitude

@MainActor
@Observable
final class MatchingHomeViewModel {
  enum MatchingHomeViewState: Equatable {
    case loading
    case profileStatusRejected
    case userRolePending
    case userRoleUser
  }
  
  enum Action {
    case onAppear
    case refresh
    case onSelectMatchingCard(matchId: Int)
    case onConfirmMatchingCard(matchId: Int)
    case didTapCreateNewMatchButton
    case didTapAlertConfirm(MatchingAlertType)
    case dismissAlert // 알럿 취소
    case clearToast
  }
  
  enum ToastAction {
    case createNewMatch
    case checkContact
  }
  
  private let getUserInfoUseCase: GetUserInfoUseCase
  private let getMatchesInfoUseCase: GetMatchesInfoUseCase
  private let patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  private let getPuzzleCountUseCase: GetPuzzleCountUseCase
  private let createNewMatchUseCase: CreateNewMatchUseCase
  private let checkCanFreeMatchUseCase: CheckCanFreeMatchUseCase
  private let postMatchContactsUseCase: PostMatchContactsUseCase
  private let getNotificationsUseCase: GetNotificationsUseCase

  private var matchInfosList: [MatchInfosModel] = []                  // Card의 Entity 원본
  private var timerManagers: [Int: MatchingTimerManager] = [:]
  
  private(set) var viewState: MatchingHomeViewState = .loading
  private(set) var selectedMatchId: Int?
  private(set) var matchingCards: [MatchingCardModel] = []            // View에서 사용하는 매핑된 Card Entity
  private(set) var puzzleCount: Int = 0
  private(set) var showSpinner: Bool = false
  private(set) var isTrial: Bool = false
  private(set) var destination: Route? = nil
  private(set) var showToastAction: ToastAction? = nil
  private(set) var hasUnreadNotifications: Bool = false
  
  var createNewMatchScreenName: PCAmplitudeButtonClickScreen {
    matchingCards.isEmpty
    ? .matchMainNoMatch
    : .matchMainHome
  }
  
  var presentedAlert: MatchingAlertType? = nil
  
  init(
    getUserInfoUseCase: GetUserInfoUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
    createNewMatchUseCase: CreateNewMatchUseCase,
    checkCanFreeMatchUseCase: CheckCanFreeMatchUseCase,
    postMatchContactsUseCase: PostMatchContactsUseCase,
    getNotificationsUseCase: GetNotificationsUseCase
  ) {
    self.getUserInfoUseCase = getUserInfoUseCase
    self.getMatchesInfoUseCase = getMatchesInfoUseCase
    self.patchMatchesCheckPieceUseCase = patchMatchesCheckPieceUseCase
    self.getPuzzleCountUseCase = getPuzzleCountUseCase
    self.createNewMatchUseCase = createNewMatchUseCase
    self.checkCanFreeMatchUseCase = checkCanFreeMatchUseCase
    self.postMatchContactsUseCase = postMatchContactsUseCase
    self.getNotificationsUseCase = getNotificationsUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleOnAppear()

    case .refresh:
      Task {
        await refresh()
      }

    case .onSelectMatchingCard(let matchId):
      handleOnSelectMatchingCard(matchId)

    case .onConfirmMatchingCard(let matchId):
      handleOnConfirmMatchingCard(matchId)
      
    case .didTapAlertConfirm(let alertType):
      withSpinner {
        await self.handleDidTapAlertConfirm(alertType)
      }
      
    case .didTapCreateNewMatchButton:
      withSpinner {
        await self.handleDidTapCreateNewMatchButton()
      }
      
    case .dismissAlert:
      dismissAlert()
      
    case .clearToast:
      showToastAction = nil
    }
  }

  // Pull Refresh
  func refresh() async {
    await withTaskGroup(of: Void.self) { group in
      group.addTask { await self.loadMatches() }
      group.addTask { await self.loadPuzzleCount() }
      group.addTask { await self.fetchCanFreeMatch() }
      group.addTask { await self.checkUnreadNotifications() }
    }

    checkBasicMatchPoolExhausted() // BASIC 매치 풀 부족 체크
  }
}

// MARK: - Private Methods
private extension MatchingHomeViewModel {
  func handleOnAppear() {
    destination = nil
    presentedAlert = nil
    showToastAction = nil

    Task {
      await getUserRole()
    }
  }
  
  func handleOnSelectMatchingCard(_ matchId: Int) {
    withAnimation(.interactiveSpring(response :0.45)) {
      selectedMatchId = matchId
      
      for i in matchingCards.indices {
        let isSelected = matchingCards[i].id == matchId
        matchingCards[i].setIsSelected(for: isSelected)
      }
    }
  }
  
  func handleOnConfirmMatchingCard(_ matchId: Int) {
    // TODO: (매칭상세/연락처확인) 분기
    guard let targetIndex = matchingCards.firstIndex(where: { $0.id == matchId }) else { return }
    let targetMatchingCard = matchingCards[targetIndex]
    let targetMatchingCardStatus = targetMatchingCard.matchStatus
    let targetMatchingCardType = targetMatchingCard.matchType
    
    let buttonName: PCAmplitudeButtonName = switch targetMatchingCardType {
    case .AUTO: .matchAuto
    case .BASIC: .matchBasic
    case .TRIAL: .matchTrial
    case .PREMIUM: .matchPremium
    }
    PCAmplitude.trackButtonClick(screenName: .matchMainHome, buttonName: buttonName)
    
    switch targetMatchingCardStatus {
    case .BEFORE_OPEN:
      withSpinner { [weak self] in
        _ = try? await self?.patchMatchesCheckPieceUseCase.execute(matchId: matchId)
        PCAmplitude.trackButtonClick(
          screenName: .matchMainHome,
          buttonName: .checkRelationShip
        )
        self?.destination = .matchProfileBasic(matchId: matchId)
      }
      
    case .WAITING, .RESPONDED, .GREEN_LIGHT:
      destination = .matchProfileBasic(matchId: matchId)

    case .MATCHED:
      PCAmplitude.trackButtonClick(screenName: .matchMainHome, buttonName: .matchMatched)
      
      switch targetMatchingCardType {
      case .BASIC:
        withSpinner { [weak self] in
          await self?.navigateToContact(matchId)
        }
       
      case .TRIAL, .PREMIUM, .AUTO:
        if targetMatchingCard.matchInfosModel.isContactViewed {
          withSpinner { [weak self] in
            await self?.navigateToContact(matchId)
          }
        }
        else {
          presentedAlert = .contactConfirm(matchId: matchId)
        }
      }

    case .REFUSED, .BLOCKED: // 거절한 상대는 안나옴
      break
    }
  }
  
  func fetchCanFreeMatch() async {
    do {
      let result = try await checkCanFreeMatchUseCase.execute()
      isTrial = result.canFreeMatch
    } catch {
      print("Check Can Free Match Error: \(error.localizedDescription)")
    }
  }
  
  func handleDidTapCreateNewMatchButton() async {
    do {
      await fetchCanFreeMatch()

      if isTrial {
        PCAmplitude.trackButtonClick(screenName: createNewMatchScreenName, buttonName: .newMatchingFree)
        
        let result = try await createNewMatchUseCase.execute()
        let matchId = result.matchId
        
        // 생성된 매칭을 Waiting으로 상태 변경
        _ = try? await patchMatchesCheckPieceUseCase.execute(matchId: matchId)
        
        selectedMatchId = matchId
        destination = .matchProfileBasic(matchId: matchId)
      } else {
        PCAmplitude.trackButtonClick(screenName: createNewMatchScreenName, buttonName: .newMatchingPurchase)
        presentedAlert = .createNewMatch // premium이면 "새로운 인연 만나기 알럿"으로 진입
      }
    } catch {
      print("Check Can TRIAL Match Error: \(error.localizedDescription)")
      presentedAlert = .trialMatchPoolExhausted
    }
  }
  
  func handleDidTapAlertConfirm(_ alertType: MatchingAlertType) async {
    dismissAlert()
    
    switch alertType {
    case .contactConfirm(let matchId):
      PCAmplitude.trackButtonClick(screenName: .matchAlert, buttonName: .contactMatchingPurchase)
      await handleDidTapContactConfirmAlertConfirm(matchId)
      
    case .insufficientPuzzle:
      PCAmplitude.trackButtonClick(screenName: .matchAlert, buttonName: .insufficientPuzzlePurchase)
      await handleDidTapInsufficientPuzzleAlertConfirm()
      
    case .createNewMatch:
      PCAmplitude.trackButtonClick(screenName: .matchAlert, buttonName: .newMatchingPurchase)
      await handleDidTapCreateNewMatchAlertConfirm()
      
    default:
      break
    }
  }
}

private extension MatchingHomeViewModel {
  func getUserRole() async {
    do {
      let userInfo = try await getUserInfoUseCase.execute()
      let userRole = userInfo.role
      let profileStatus = userInfo.profileStatus
      
      PCUserDefaultsService.shared.setUserRole(userRole)
      PCAmplitude.setUserId(with: String(userInfo.id))
      
      switch profileStatus {
      case .REJECTED:
        viewState = .profileStatusRejected
        return
      
      default:
        break
      }
      
      switch userRole {
      case .PENDING:
        viewState = .userRolePending
        
      case .USER: // (매칭&퍼즐개수&무료매칭여부&알림) 조회는 병렬호출로 성능 개선
        await withTaskGroup(of: Void.self) { group in
          group.addTask { await self.loadMatches() }
          group.addTask { await self.loadPuzzleCount() }
          group.addTask { await self.fetchCanFreeMatch() }
          group.addTask { await self.checkUnreadNotifications() }
        }

        checkBasicMatchPoolExhausted() // BASIC 매치 풀 부족 체크

        viewState = .userRoleUser
        
      default:
        break
      }
      
    } catch {
      print("Get User Role :\(error.localizedDescription)")
    }
  }

  func checkUnreadNotifications() async {
    do {
      var hasUnread = hasUnreadNotifications
      var isEnd = false

      while !hasUnread && !isEnd {
        let result = try await getNotificationsUseCase.execute()
        hasUnread = hasUnread || result.notifications.contains { !$0.isRead }
        isEnd = result.isEnd
      }

      hasUnreadNotifications = hasUnread
    } catch {
      print("Get Notifications: \(error.localizedDescription)")
    }
  }

  func loadPuzzleCount() async {
    do {
      let result = try await getPuzzleCountUseCase.execute()
      puzzleCount = result.puzzleCount
    } catch {
      print("Get Puzzle Count: \(error.localizedDescription)")
      puzzleCount = 0
    }
  }

  // TODO: - 새로운 인연 버튼 UI 까지 구현하고 이번 1312는 마무리하자 ✅
  // TODO: - 그리고 이제 타이머 구현해야해. ✅
  func loadMatches() async {
    if let matchInfos = try? await getMatchesInfoUseCase.execute() {
      matchInfosList = matchInfos
    } else {
      matchInfosList = MatchInfosModel.dummy
    }
    
    selectedMatchId = determineInitialSelection()
    updateMatchingCards()
  }
  
  func determineInitialSelection() -> Int? {
    let filteredInfos = matchInfosList
      .filter { $0.matchStatus != .REFUSED }
      .filter { $0.matchStatus != .BLOCKED }
      .filter { !$0.isBlocked }
      .filter { !isMatchExpired($0) }

    // 0. 이전에 선택된 카드가 있고, 해당 카드가 리스트에 존재하면 유지
    if let currentSelectedId = selectedMatchId,
       filteredInfos.contains(where: { $0.matchId == currentSelectedId }) {
      return currentSelectedId
    }

    // 1. 타의적 매칭이 아닌 첫 번째 카드
    if let firstNonAuto = filteredInfos.first(where: { $0.matchType != .AUTO }) {
      return firstNonAuto.matchId
    }
    // 2. 타의적 매칭만 있는 경우 첫 번째 카드
    return filteredInfos.first?.matchId
  }
  
  // TODO: (필수) 새 카드 생성 및 API 호출 시 호출
  func updateMatchingCards() {
    let filteredInfos = matchInfosList
      .filter { $0.matchStatus != .REFUSED }
      .filter { $0.matchStatus != .BLOCKED }
      .filter { !$0.isBlocked }
      .filter { !isMatchExpired($0) }
    let currentIds = Set(filteredInfos.map { $0.matchId })
    
    timerManagers = timerManagers.filter { currentIds.contains($0.key) }
    matchingCards = filteredInfos.map { info in
      MatchingCardModel(
        matchId: info.matchId,
        matchInfosModel: info,
        isSelected: info.matchId == selectedMatchId,
        matchingTimerManager: getOrCreateTimer(for: info)
      )
    }
  }

  private func getOrCreateTimer(for matchInfo: MatchInfosModel) -> MatchingTimerManager {
    if let existing = timerManagers[matchInfo.matchId] {
      return existing
    }
    let newTimer = MatchingTimerManager(matchedDate: matchInfo.createdAt)
    newTimer.onTimerExpired = { [weak self] in
      Task { @MainActor [weak self] in
        self?.handleTimerExpired()
      }
    }
    timerManagers[matchInfo.matchId] = newTimer
    return newTimer
  }

  private func isMatchExpired(_ matchInfo: MatchInfosModel) -> Bool {
    guard let expirationDate = Calendar.current.date(byAdding: .hour, value: 24, to: matchInfo.createdAt) else {
      return false
    }
    return Date() >= expirationDate
  }

  // 타이머 만료 시 매칭 카드 갱신
  private func handleTimerExpired() {
    selectedMatchId = determineInitialSelection()
    updateMatchingCards()
  }
}

// MARK: - MatchingAlert
private extension MatchingHomeViewModel {
  func dismissAlert() {
    presentedAlert = nil
  }
  
  func handleDidTapContactConfirmAlertConfirm(_ matchId: Int) async {
    await loadPuzzleCount() // [방어로직] 퍼즐 개수 동기화 (✅)
    if puzzleCount >= DomainConstants.PuzzleCost.checkContact { // - 2.1.2.2.1.1 사용자 퍼즐 개수가 충분한 경우 -> MatchResultView 이동 (✅)
      withSpinner { [weak self] in
        await self?.navigateToContact(matchId)
      }
    } else {
      presentedAlert = .insufficientPuzzle // 퍼즐 부족 알럿 표시
    }
  }
  
  func navigateToContact(_ matchId: Int) async {
    guard let match = matchInfosList.first(where: { $0.matchId == matchId }) else { return }
    let isContactViewed = match.isContactViewed
    let isBasic = match.matchType == .BASIC
    
    guard isContactViewed || isBasic else {
      do {
        _ = try await postMatchContactsUseCase.execute(matchId: matchId)
        destination = .matchResult(matchId: matchId)
        showToastAction = .checkContact
      } catch {
        print("Post Match Contacts Error: \(error.localizedDescription)")
      }
      
      return
    }
    
    destination = .matchResult(matchId: matchId)
  }
  
  func handleDidTapInsufficientPuzzleAlertConfirm() async {
    destination = .storeMain
  }
  
  func handleDidTapCreateNewMatchAlertConfirm() async {
    await loadPuzzleCount() // [방어로직] 퍼즐 개수 동기화 (✅)

    if puzzleCount >= DomainConstants.PuzzleCost.createNewMatch {
      do {
        let result = try await createNewMatchUseCase.execute()
        let matchId = result.matchId

        // 생성된 매칭을 Waiting으로 상태 변경
        _ = try? await patchMatchesCheckPieceUseCase.execute(matchId: matchId)
        
        selectedMatchId = matchId
        destination = .matchProfileBasic(matchId: matchId)
        showToastAction = .createNewMatch
      } catch {
        print("Create New Match Error: \(error.localizedDescription)")
        presentedAlert = .matchPoolExhausted
      }
    } else {
      presentedAlert = .insufficientPuzzle // 퍼즐 부족 알럿 표시
    }
  }

  // MARK: - BASIC Match Pool Exhausted Check
  /// 오후 10시 기준 논리적 날짜 계산 (yyyy-MM-dd)
  func getLogicalDate(for date: Date = Date()) -> String {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)

    var targetDate = date
    // 오전 0시 ~ 오후 10시 이전이면 전날로 간주
    if hour < 22 {
      targetDate = calendar.date(byAdding: .day, value: -1, to: date) ?? date
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current
    return formatter.string(from: targetDate)
  }

  /// matchInfosList에 BASIC 타입 매치가 존재하는지 확인
  func hasBasicMatch() -> Bool {
    return matchInfosList.contains { $0.matchType == .BASIC }
  }

  /// 오늘(오후 10시 기준) 이미 알럿을 띄웠는지 확인
  func hasShownBasicPoolExhaustedAlertToday() -> Bool {
    guard let lastAlertDate = PCUserDefaultsService.shared.getLastBasicMatchPoolExhaustedAlertDate() else {
      return false
    }

    let currentLogicalDate = getLogicalDate()
    return lastAlertDate == currentLogicalDate
  }

  /// BASIC 매치 풀 부족 체크 및 알럿 표시
  func checkBasicMatchPoolExhausted() {
    guard !hasBasicMatch() else { return }
    guard !hasShownBasicPoolExhaustedAlertToday() else { return }

    presentedAlert = .basicMatchPoolExhausted
    PCUserDefaultsService.shared.setLastBasicMatchPoolExhaustedAlertDate(getLogicalDate())
  }
}

// MARK: - Spinner
private extension MatchingHomeViewModel {
  func setSpinnerVisible(_ visible: Bool) {
    showSpinner = visible
  }
  
  func withSpinner(_ action: @escaping () async -> Void) {
    Task {
      setSpinnerVisible(true)
      defer { setSpinnerVisible(false) }  // 에러 발생해도 false 처리

      // 최소 0.1초 딜레이를 먼저 기다림
      try? await Task.sleep(nanoseconds: 100_000_000) // 0.1초

      // 그 후 action 실행
      await action()
    }
  }
}
