//
// MatchProfileBasicViewModel.swift
// MatchingDetail
//
// Created by summercat on 2025/01/02.
//

import Foundation
import Observation
import UseCases
import PCAmplitude
import Entities
import Router

@MainActor
@Observable
final class MatchProfileBasicViewModel {
  enum Action {
    case onAppear
    case didTapMoreButton
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
  
  private enum Constant {
    static let navigationTitle = ""
    static let title = "오늘의 인연"
  }

  let navigationTitle = Constant.navigationTitle
  var matchStatus: MatchStatus? { matchingBasicInfoModel?.matchStatus }
  var matchType: MatchType? { matchingBasicInfoModel?.matchType }
  var isImageViewed: Bool? { matchingBasicInfoModel?.isImageViewed }
  let title = Constant.title
  var isPhotoViewPresented: Bool = false
  var isBottomSheetPresented: Bool = false
  var presentedAlert: MatchingDetailAlertType? = nil

  private(set) var showSpinner = true
  private(set) var error: Error?
  private(set) var matchingBasicInfoModel: BasicInfoModel?
  private(set) var photoUri: String = ""
  private(set) var showToastAction: MatchActionType? = nil
  private(set) var matchId: Int
  private(set) var puzzleCount: Int = 0
  private(set) var timerManager: MatchingDetailTimerManager?
  private(set) var destination: Route? = nil
  
  private let getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let postMatchPhotoUseCase: PostMatchPhotoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let getPuzzleCountUseCase: GetPuzzleCountUseCase
  
  init(
    matchId: Int,
    getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
  ) {
    self.matchId = matchId
    self.getMatchProfileBasicUseCase = getMatchProfileBasicUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.postMatchPhotoUseCase = postMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.getPuzzleCountUseCase = getPuzzleCountUseCase
    self.presentedAlert = nil
    
    withSpinner { [weak self] in
      await self?.fetchMatchingBasicInfo()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      destination = nil
      showToastAction = nil
      presentedAlert = nil

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
  
  private func fetchMatchingBasicInfo() async {
    do {
      await loadPuzzleCount()
      let entity = try await getMatchProfileBasicUseCase.execute(matchId: matchId)
      matchingBasicInfoModel = BasicInfoModel(model: entity)
      setupTimerManager(for: entity.createdAt)
      error = nil
    } catch {
      // TODO: 에러 핸들링
      self.error = error
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
      // TODO: 에러 핸들링
      self.error = error
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

extension MatchProfileBasicViewModel {
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
        await fetchMatchingBasicInfo()
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
  
  private func handleAlertConfirm(_ alertType: MatchingDetailAlertType) {
    switch alertType {
    case .freeAccept:
      Task {
        await acceptMatch()
        showToastAction = .accept
      }

    case .paidAccept:
      Task {
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
        await loadPuzzleCount()
        if puzzleCount >= DomainConstants.PuzzleCost.viewPhoto {
          await buyMatchPhoto()
          await fetchMatchPhoto()
          await fetchMatchingBasicInfo()
          isPhotoViewPresented = true
          showToastAction = .viewPhoto
        } else {
          presentedAlert = .insufficientPuzzle
        }
      }

    case .timeExpired:
      showToastAction = .timeExpired
      
    case .insufficientPuzzle:
      destination = .storeMain
      
    default:
      break
    }
  }
}

private extension MatchProfileBasicViewModel {
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

private extension MatchProfileBasicViewModel {
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
private extension MatchProfileBasicViewModel {
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
