//
//  ValueTalkViewModel.swift
//  MatchingDetail
//
//  Created by summercat on 1/5/25.
//

import Foundation
import Observation
import UseCases
import PCAmplitude
import Entities
import Router

@MainActor
@Observable
final class ValueTalkViewModel {
  private enum Constant {
    static let navigationTitle = "가치관 Talk"
    static let nameVisibilityOffset: CGFloat = -80
  }
  
  enum Action {
    case onAppear
    case contentOffsetDidChange(CGFloat)
    case didTapMoreButton
    case didTapPhotoButton
    case didTapAcceptButton
    case didTapRefuseButton

    case dismissAlert
    case didConfirmAlert(MatchingDetailAlertType)
    case clearToast
  }
  
  enum MatchActionType {
    case accept
    case refuse
    case viewPhoto
    case timeExpired
  }
  
  init(
    matchId: Int,
    getMatchValueTalkUseCase: GetMatchValueTalkUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    refuseMatchUseCase: RefuseMatchUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
  ) {
    self.matchId = matchId
    self.getMatchValueTalkUseCase = getMatchValueTalkUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.postMatchPhotoUseCase = postMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.refuseMatchUseCase = refuseMatchUseCase
    self.getPuzzleCountUseCase = getPuzzleCountUseCase
    self.presentedAlert = nil
    
    withSpinner { [weak self] in
      await self?.fetchMatchValueTalk()
    }
  }
  
  let navigationTitle: String = Constant.navigationTitle
  var matchStatus: MatchStatus? { valueTalkModel?.matchStatus }
  var matchType: MatchType? { valueTalkModel?.matchType }
  var isImageViewed: Bool? { valueTalkModel?.isImageViewed }
  var isPhotoViewPresented: Bool = false
  var isBottomSheetPresented: Bool = false
  var presentedAlert: MatchingDetailAlertType? = nil

  private(set) var valueTalkModel: ValueTalkModel?
  private(set) var contentOffset: CGFloat = 0
  private(set) var isNameViewVisible: Bool = true
  private(set) var showSpinner = true
  private(set) var error: Error?
  private(set) var photoUri: String = ""
  
  var isAcceptButtonEnabled: Bool {
    switch matchStatus {
    case .BEFORE_OPEN, .WAITING, .GREEN_LIGHT:
      return true
    
    case .RESPONDED, .MATCHED:
      return false
    
    default:
      return false
    }
  }
  
  private(set) var showToastAction: MatchActionType? = nil
  private(set) var matchId: Int
  private(set) var puzzleCount: Int = 0
  private(set) var timerManager: MatchingDetailTimerManager?
  private(set) var destination: Route? = nil
  
  private let getMatchValueTalkUseCase: GetMatchValueTalkUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let postMatchPhotoUseCase: PostMatchPhotoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let refuseMatchUseCase: RefuseMatchUseCase
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

    case .didTapPhotoButton:
      withSpinner { [weak self] in
        self?.handleDidTapPhotoButton()
      }

    case .didTapAcceptButton:
      withSpinner { [weak self] in
        self?.handleDidTapAcceptButton()
      }
    case .didTapRefuseButton:
      withSpinner { [weak self] in
        self?.handleDidTapRefuseButton()
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
  
  private func fetchMatchValueTalk() async {
    do {
      await loadPuzzleCount()
      let entity = try await getMatchValueTalkUseCase.execute(matchId: matchId)
      valueTalkModel = ValueTalkModel(model: entity)
      setupTimerManager(for: entity.createdAt)
      error = nil
    } catch {
      self.error = error
      // TODO: 에러 핸들링
    }
  }
  
  private func buyMatchPhoto() async {
    do {
      _ = try await postMatchPhotoUseCase.execute(matchId: matchId)
    } catch {
      self.error = error
      presentedAlert = .insufficientPuzzle
      // TODO: 에러 핸들링
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
      presentedAlert = .insufficientPuzzle
      // TODO: 에러 핸들링
    }
  }
  
  private func refuseMatch() async {
    do {
      _ = try await refuseMatchUseCase.execute(matchId: matchId)
    } catch {
      self.error = error
      // TODO: 에러 핸들링
    }
  }
}

private extension ValueTalkViewModel {
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
  
  func handleDidTapRefuseButton() {
    presentedAlert = .refuse(matchId: matchId)
    PCAmplitude.trackScreenView(DefaultProgress.matchDetailRejectPopup.rawValue)
  }
  
  func handleDidTapPhotoButton() {
    guard let matchType else { return }
    switch matchType {
    case .BASIC:
      Task {
        await fetchMatchPhoto()
        await fetchMatchValueTalk()
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
      screenName: .matchDetailValueTalk,
      buttonName: .photoView
    )
  }
  
  func handleAlertConfirm(_ alertType: MatchingDetailAlertType) {
    switch alertType {
    case .refuse:
      showToastAction = nil
      Task {
        await refuseMatch()
        showToastAction = .refuse
      }

    case .freeAccept:
      Task {
        showToastAction = nil
        await acceptMatch()
        showToastAction = .accept
      }

    case .paidAccept:
      Task {
        showToastAction = nil
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
        showToastAction = nil
        await loadPuzzleCount()
        if puzzleCount >= DomainConstants.PuzzleCost.viewPhoto {
          await buyMatchPhoto()
          await fetchMatchPhoto()
          await fetchMatchValueTalk()
          isPhotoViewPresented = true
          showToastAction = .viewPhoto
        } else {
          presentedAlert = .insufficientPuzzle
        }
      }

    case .timeExpired:
      showToastAction = nil
      showToastAction = .timeExpired
    
    case .insufficientPuzzle:
      destination = .storeMain
    }
  }
}

private extension ValueTalkViewModel {
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


private extension ValueTalkViewModel {
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
private extension ValueTalkViewModel {
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
