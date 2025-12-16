//
// MatchProfileBasicViewModel.swift
// MatchingDetail
//
// Created by summercat on 2025/01/02.
//

import Observation
import UseCases
import PCAmplitude
import Entities

@MainActor
@Observable
final class MatchProfileBasicViewModel {
  enum Action {
    case didTapMoreButton
    case didTapPhotoButton
    case didTapAcceptButton

    case dismissAlert
    case didConfirmAlert(MatchingDetailAlertType)
  }
  
  enum MatchActionType {
      case accept
      case viewPhoto
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

  private(set) var isLoading = true
  private(set) var error: Error?
  private(set) var matchingBasicInfoModel: BasicInfoModel?
  private(set) var photoUri: String = ""
  private(set) var completedMatchAction: MatchActionType? = nil
  private(set) var matchId: Int
  private let getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let postMatchPhotoUseCase: PostMatchPhotoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  
  init(
    matchId: Int,
    getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase
  ) {
    self.matchId = matchId
    self.getMatchProfileBasicUseCase = getMatchProfileBasicUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.postMatchPhotoUseCase = postMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.presentedAlert = nil
    
    Task {
      await fetchMatchingBasicInfo()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .didTapMoreButton:
      handleDidTapMoreButton()

    case .didTapPhotoButton:
      handleDidTapPhotoButton()

    case .didTapAcceptButton:
      handleDidTapAcceptButton()
      
    case .dismissAlert:
      presentedAlert = nil

    case .didConfirmAlert(let alertType):
      presentedAlert = nil
      handleAlertConfirm(alertType)
    }
  }
  
  private func fetchMatchingBasicInfo() async {
    do {
      let entity = try await getMatchProfileBasicUseCase.execute(matchId: matchId)
      matchingBasicInfoModel = BasicInfoModel(model: entity)
      error = nil
    } catch {
      self.error = error
    }
    isLoading = false
  }
  
  private func buyMatchPhoto() async {
    do {
      _ = try await postMatchPhotoUseCase.execute(matchId: matchId)
    } catch {
      self.error = error
      presentedAlert = .insufficientPuzzle
    }
  }
  
  private func fetchMatchPhoto() async {
    do {
      let uri = try await getMatchPhotoUseCase.execute(matchId: matchId)
      photoUri = uri
    } catch {
      self.error = error
    }
  }
  
  private func acceptMatch() async {
    do {
      _ = try await acceptMatchUseCase.execute(matchId: matchId)
    } catch {
      self.error = error
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
    case .freeAccept, .paidAccept:
      Task {
        completedMatchAction = nil
        await acceptMatch()
        completedMatchAction = .accept
      }

    case .paidPhoto:
      Task {
        completedMatchAction = nil
        await buyMatchPhoto()
        await fetchMatchPhoto()
        await fetchMatchingBasicInfo()
        isPhotoViewPresented = true
        completedMatchAction = .viewPhoto
      }

    case .timeExpired:
      // TODO: 뒤로가기 처리
      break
      
    default:
      break
    }
  }
}
