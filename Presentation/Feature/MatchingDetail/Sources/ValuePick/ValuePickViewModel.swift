//
//  ValuePickViewModel.swift
//  MatchingDetail
//
//  Created by summercat on 1/13/25.
//

import Entities
import Foundation
import LocalStorage
import Observation
import UseCases
import PCAmplitude
import Router

@MainActor
@Observable
final class ValuePickViewModel {
  private enum Constant {
    static let navigationTitle = "가치관 Pick"
    static let nameVisibilityOffset: CGFloat = -100
  }
  
  enum Action {
    case onAppear
    case contentOffsetDidChange(CGFloat)
    case didTapMoreButton
    case didSelectTab(ValuePickTab)
    case didTapPhotoButton
    case didTapAcceptButton

    case dismissAlert
    case didConfirmAlert(MatchingDetailAlertType)
    case clearToast
  }
  
  enum MatchActionType {
    case accept
    case viewPhoto
    case timeExpired
  }
  
  init(
    matchId: Int,
    getMatchValuePickUseCase: GetMatchValuePickUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
  ) {
    self.matchId = matchId
    self.getMatchValuePickUseCase = getMatchValuePickUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.postMatchPhotoUseCase = postMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.getPuzzleCountUseCase = getPuzzleCountUseCase
    self.presentedAlert = nil
    
    withSpinner { [weak self] in
      await self?.fetchMatchValuePick()
    }
  }
  
  let tabs = ValuePickTab.allCases
  let navigationTitle: String = Constant.navigationTitle
  var matchStatus: MatchStatus? { valuePickModel?.matchStatus }
  var matchType: MatchType? { valuePickModel?.matchType }
  var isImageViewed: Bool? { valuePickModel?.isImageViewed }
  var isPhotoViewPresented: Bool = false
  var isBottomSheetPresented: Bool = false
  var presentedAlert: MatchingDetailAlertType? = nil

  private(set) var valuePickModel: MatchValuePickModel?
  private(set) var showSpinner = true
  private(set) var error: Error?
  private(set) var contentOffset: CGFloat = 0
  private(set) var isNameViewVisible: Bool = true
  private(set) var selectedTab: ValuePickTab = .all
  private(set) var displayedValuePicks: [MatchValuePickItemModel] = []
  private(set) var sameWithMeCount: Int = 0
  private(set) var differentFromMeCount: Int = 0
  private(set) var photoUri: String = ""
  private(set) var showToastAction: MatchActionType? = nil
  private(set) var matchId: Int
  private(set) var puzzleCount: Int = 0
  private(set) var timerManager: MatchingDetailTimerManager?
  private(set) var destination: Route? = nil

  private var valuePicks: [MatchValuePickItemModel] = []
  private let getMatchValuePickUseCase: GetMatchValuePickUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let postMatchPhotoUseCase: PostMatchPhotoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let getPuzzleCountUseCase: GetPuzzleCountUseCase
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      destination = nil
      showToastAction = nil
      presentedAlert = nil

    case let .contentOffsetDidChange(offset):
      contentOffset = offset
      isNameViewVisible = offset > Constant.nameVisibilityOffset
      
    case .didTapMoreButton:
      handleDidTapMoreButton()

    case let .didSelectTab(tab):
      self.selectedTab = tab
      switch tab {
      case .all:
        displayedValuePicks = valuePicks
      case .same:
        displayedValuePicks = valuePicks.filter { $0.isSameWithMe }
      case .different:
        displayedValuePicks = valuePicks.filter { !$0.isSameWithMe }
      }
      
    case .didTapPhotoButton:
      withSpinner { [weak self] in
        self?.handleDidTapPhotoButton()
      }

    case .didTapAcceptButton:
      withSpinner { [weak self] in
        self?.handleDidTapAcceptButton()
      }
    case .dismissAlert:
      presentedAlert = nil

    case .didConfirmAlert(let alertType):
      withSpinner { [weak self] in
        self?.presentedAlert = nil
        self?.handleAlertConfirm(alertType)
      }
      
    case .clearToast:
      showToastAction = nil
    }
  }
  
  func fetchMatchValuePick() async {
    do {
      await loadPuzzleCount()
      let entity = try await getMatchValuePickUseCase.execute(matchId: matchId)
      valuePickModel = entity
      valuePicks = entity.valuePicks
      displayedValuePicks = entity.valuePicks
      sameWithMeCount = entity.valuePicks.filter { $0.isSameWithMe }.count
      differentFromMeCount = entity.valuePicks.filter { !$0.isSameWithMe }.count
      setupTimerManager(for: entity.createdAt)
      error = nil
    } catch {
      self.error = error
    }
  }
  
  private func buyMatchPhoto() async {
    do {
      _ = try await postMatchPhotoUseCase.execute(matchId: matchId)
    } catch {
      self.error = error
      // TODO: 에러 핸들링
      presentedAlert = .insufficientPuzzle
    }
  }
  
  private func fetchMatchPhoto() async {
    do {
      let uri = try await getMatchPhotoUseCase.execute(matchId: matchId)
      photoUri = uri
    } catch {
      self.error = error
      // TODO: 에러 핸들링
    }
  }
  
  private func acceptMatch() async {
    do {
      _ = try await acceptMatchUseCase.execute(matchId: matchId)
    } catch {
      self.error = error
      // TODO: 에러 핸들링
      presentedAlert = .insufficientPuzzle
    }
  }
}

extension ValuePickViewModel {
  func handleDidTapMoreButton() {
    isBottomSheetPresented = true
    PCAmplitude.trackScreenView(DefaultProgress.reportBlockSelectBottomsheet.rawValue)
  }
  
  func handleDidTapAcceptButton() {
    guard let matchType else { return }
    
    switch matchType {
    case .BASIC:
      presentedAlert = .freeAccept(matchId: matchId)
      
    case .TRIAL, .PREMIUM, .AUTO:
      presentedAlert = .paidAccept(matchId: matchId)
    }
    
    PCAmplitude.trackScreenView(DefaultProgress.matchDetailAcceptPopup.rawValue)
  }
  
  func handleDidTapPhotoButton() {
    guard let matchType else { return }
    switch matchType {
    case .BASIC:
      Task {
        await fetchMatchPhoto()
        await fetchMatchValuePick()
        isPhotoViewPresented = true
      }
    
    case .TRIAL, .PREMIUM, .AUTO:
      guard let isImageViewed else { return }
      if isImageViewed {
        Task {
          await fetchMatchPhoto()
          isPhotoViewPresented = true
        }
      } else {
        presentedAlert = .paidPhoto(matchId: matchId)
      }
    }
    
    PCAmplitude.trackButtonClick(
      screenName: .matchDetailValuePick,
      buttonName: .photoView
    )
  }
  
  private func handleAlertConfirm(_ alertType: MatchingDetailAlertType) {
    switch alertType {
    case .freeAccept:
      Task {
        PCAmplitude.trackButtonClick(screenName: .matchAlert, buttonName: .acceptMatching)
        
        await acceptMatch()
        showToastAction = .accept
      }

    case .paidAccept:
      Task {
        PCAmplitude.trackButtonClick(screenName: .matchAlert, buttonName: .acceptMatchingPurchase)
        
        await loadPuzzleCount()
        if puzzleCount >= DomainConstants.PuzzleCost.acceptMatch {
          await acceptMatch()
          showToastAction = .accept
        } else {
          presentedAlert = .insufficientPuzzle
        }
      }
      
    case .paidPhoto:
      Task {
        PCAmplitude.trackButtonClick(screenName: .matchAlert, buttonName: .checkPictureMatchingPurchase)
        
        await loadPuzzleCount()
        if puzzleCount >= DomainConstants.PuzzleCost.viewPhoto {
          await buyMatchPhoto()
          await fetchMatchPhoto()
          await fetchMatchValuePick()
          isPhotoViewPresented = true
          showToastAction = .viewPhoto
        } else {
          presentedAlert = .insufficientPuzzle
        }
      }

    case .timeExpired:
      showToastAction = .timeExpired

    case .insufficientPuzzle:
      PCAmplitude.trackButtonClick(screenName: .matchDetailBasicProfile, buttonName: .acceptMatchingPurchase)
      destination = .storeMain
      
    default:
      break
    }
  }
}

private extension ValuePickViewModel {
  func setupTimerManager(for createdAt: Date) {
    timerManager = MatchingDetailTimerManager(matchedDate: createdAt)
    
    // 00:00이 되었을 때 실행할 로직
    timerManager?.onTimerExpired = { [weak self] in
      self?.showTimeExpiredAlert()
    }
  }
  
  func showTimeExpiredAlert() {
    presentedAlert = .timeExpired(matchId: matchId)
  }
}

private extension ValuePickViewModel {
  func loadPuzzleCount() async {
    do {
      let result = try await getPuzzleCountUseCase.execute()
      puzzleCount = result.puzzleCount
    } catch {
      print("Get Puzzle Count: \(error.localizedDescription)")
      puzzleCount = 0
    }
  }
}

// MARK: - Spinner
private extension ValuePickViewModel {
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
