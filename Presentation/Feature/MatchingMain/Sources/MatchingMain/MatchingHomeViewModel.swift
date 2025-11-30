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
    case onSelectMatchingCard(matchId: Int)
    case onConfirmMatchingCard(matchId: Int)
    case didTapCreateNewMatchButton
    case didTapAlertConfirm(MatchingAlertType)
    case dismissAlert // 알럿 취소
  }
  
  private let getUserInfoUseCase: GetUserInfoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let getMatchesInfoUseCase: GetMatchesInfoUseCase
  private let patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  private let getPuzzleCountUseCase: GetPuzzleCountUseCase

  private var matchInfosList: [MatchInfosModel] = []                  // Card의 Entity 원본
  private var timerManagers: [Int: MatchingTimerManager] = [:]
  
  private(set) var viewState: MatchingHomeViewState = .loading
  private(set) var selectedMatchId: Int?
  private(set) var matchingCards: [MatchingCardModel] = []            // View에서 사용하는 매핑된 Card Entity
  private(set) var puzzleCount: Int = 0
  private(set) var showSpinner: Bool = false
  private(set) var isTrial: Bool = false
  
  var presentedAlert: MatchingAlertType? = nil
  
  init(
    getUserInfoUseCase: GetUserInfoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
  ) {
    self.getUserInfoUseCase = getUserInfoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.getMatchesInfoUseCase = getMatchesInfoUseCase
    self.patchMatchesCheckPieceUseCase = patchMatchesCheckPieceUseCase
    self.getPuzzleCountUseCase = getPuzzleCountUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleOnAppear()

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
    }
  }
}

// MARK: - Private Methods
private extension MatchingHomeViewModel {
  func handleOnAppear() {
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
    
    switch targetMatchingCard.matchStatus {
    case .BEFORE_OPEN:
      break // - 1. `BEFORE_OPEN`상태의 경우, 구 매칭 조각 확인 체크 API(/api/matches/pieces/check) 콜 해야함 // 아직 API 안나옴
      
    case .WAITING, .RESPONDED, .GREEN_LIGHT:
      break // - 2.2. `MATCHED`상태가 아닌 경우 유/무료 카드 (basic, trialPremium, auto) 상관 없이 "매칭 상세"로 진입
      
    case .MATCHED:
      break // - 2.1. `MATCHED`상태의 경우 "연락처 확인 알럿"으로 진입
    
      switch targetMatchingCard.matchingType {
      case .basic:
        break
      case .trialPremium, .auto:
        presentedAlert = .contactConfirm(matchId: matchId) // "연락처 확인 알럿"으로 진입 (✅)
      }

    case .REFUSED: // 거절한 상대는 안나옴
      break
    }
  }
  
  func handleDidTapCreateNewMatchButton() async {
    // TODO: [방어로직 한번 더] await 새로운 인연 만나기 Free 여부 조회해서 `self.isTrial`에 바인딩
    
    if self.isTrial {
      print("새로운 인연 만나기 Instant 매칭 콜")
    } else {
      presentedAlert =  .createNewMatch// premium이면 "새로운 인연 만나기 알럿"으로 진입
    }
  }
  
  func handleDidTapAlertConfirm(_ alertType: MatchingAlertType) async {
    dismissAlert()
    
    switch alertType {
    case .contactConfirm(let matchId):
        await handleDidTapContactConfirmAlertConfirm(matchId)
      
    case .insufficientPuzzle:
        await handleDidTapInsufficientPuzzleAlertConfirm()
      
    case .createNewMatch:
        await handleDidTapCreateNewMatchAlertConfirm()
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
        
      case .USER: // (매칭&퍼즐개수)조회는 "USER" 상태에 병렬호출로 성능 개선
        await withTaskGroup(of: Void.self) { group in
          group.addTask { await self.loadMatches() }
          group.addTask { await self.loadPuzzleCount() }
        }
        
        viewState = .userRoleUser
        
      default:
        break
      }
      
    } catch {
      print("Get User Role :\(error.localizedDescription)")
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

  func loadMatches() async {
    // TODO: 향후 GetMatchesListUseCase로 대체 (3가지 매칭정보 병렬 콜)
//    matchInfosList = MatchInfosModel.dummy
    
    if let matchInfo = try? await getMatchesInfoUseCase.execute() {
      matchInfosList.append(matchInfo)
      print(matchInfo)
    } else {
      matchInfosList = MatchInfosModel.dummy
    }
    
    selectedMatchId = determineInitialSelection()
    updateMatchingCards()
  }
  
  func determineInitialSelection() -> Int? {
    // 1. 타의적 매칭이 아닌 첫 번째 카드
    if let firstNonAuto = matchInfosList.first(where: { $0.matchingType != .auto }) {
      return firstNonAuto.matchId
    }
    // 2. 타의적 매칭만 있는 경우 첫 번째 카드
    return matchInfosList.first?.matchId
  }
  
  // TODO: (필수) 새 카드 생성 및 API 호출 시 호출
  func updateMatchingCards() {
    let filteredInfos = matchInfosList.filter { $0.matchStatus != .REFUSED }
    let currentIds = Set(filteredInfos.map { $0.matchId })
    
    timerManagers = timerManagers.filter { currentIds.contains($0.key) }
    matchingCards = filteredInfos.map { info in
      MatchingCardModel(
        matchId: info.matchId,
        matchInfosModel: info,
        isSelected: info.matchId == selectedMatchId,
        matchingTimerManager: getOrCreateTimer(for: info.matchId)
      )
    }
  }
  
  private func getOrCreateTimer(for matchId: Int) -> MatchingTimerManager {
    if let existing = timerManagers[matchId] {
      return existing
    }
    // TODO: 향후 matchInfo.matchedDateTime 사용
    let newTimer = MatchingTimerManager(matchedDateTime: "2025-11-22T20:09:50")
    timerManagers[matchId] = newTimer
    return newTimer
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
      // TODO: 연락처확인 퍼즐 소모(구매) API
      // TODO: MatchResultView(with: matchId) 이동
    } else { // - 2.1.2.2.2.2 사용자 퍼즐 개수가 모자란 경우 -> 스토어 이동 (✅)
      presentedAlert = .insufficientPuzzle // 퍼즐 부족 알럿 표시
    }
  }
  
  func handleDidTapInsufficientPuzzleAlertConfirm() async {
    // TODO: 스토어로 이동 로직
  }
  
  func handleDidTapCreateNewMatchAlertConfirm() async {
    await loadPuzzleCount() // [방어로직] 퍼즐 개수 동기화 (✅)

    if puzzleCount >= DomainConstants.PuzzleCost.createNewMatch {
      // TODO: 프리미엄 instant 매칭 추가 API 호출 -> 응답은 생성된 matchId
      // TODO: 매칭상세(with: matchId) 이동
    } else {
      presentedAlert = .insufficientPuzzle // 퍼즐 부족 알럿 표시
    }
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
      await action()
    }
  }
}
