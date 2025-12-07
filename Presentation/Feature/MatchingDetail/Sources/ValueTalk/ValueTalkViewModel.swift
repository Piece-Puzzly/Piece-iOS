//
//  ValueTalkViewModel.swift
//  MatchingDetail
//
//  Created by summercat on 1/5/25.
//

import Foundation
import LocalStorage
import Observation
import UseCases
import PCAmplitude

@MainActor
@Observable
final class ValueTalkViewModel {
  private enum Constant {
    static let navigationTitle = "가치관 Talk"
    static let nameVisibilityOffset: CGFloat = -80
  }
  
  enum Action {
    case contentOffsetDidChange(CGFloat)
    case didTapMoreButton
    case didTapPhotoButton
    case didTapAcceptButton
    case didTapRefuseButton
    case didAcceptMatch
    case didRefuseMatch
  }
  
  enum MatchActionType {
      case accept
      case refuse
  }
  
  init(
    matchId: Int,
    getMatchValueTalkUseCase: GetMatchValueTalkUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    refuseMatchUseCase: RefuseMatchUseCase
  ) {
    self.matchId = matchId
    self.getMatchValueTalkUseCase = getMatchValueTalkUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.refuseMatchUseCase = refuseMatchUseCase
    
    var isAcceptButtonEnabled = false
    if let matchStatus = PCUserDefaultsService.shared.getMatchStatus() {
      switch matchStatus {
      case .BEFORE_OPEN: isAcceptButtonEnabled = true
      case .WAITING: isAcceptButtonEnabled = true
      case .REFUSED: isAcceptButtonEnabled = false
      case .RESPONDED: isAcceptButtonEnabled = false
      case .GREEN_LIGHT: isAcceptButtonEnabled = true
      case .MATCHED: isAcceptButtonEnabled = false
      }
    }
    self.isAcceptButtonEnabled = isAcceptButtonEnabled
    
    Task {
      await fetchMatchValueTalk()
      await fetchMatchPhoto()
    }
  }
  
  let navigationTitle: String = Constant.navigationTitle
  var isPhotoViewPresented: Bool = false
  var isBottomSheetPresented: Bool = false
  var isMatchAcceptAlertPresented: Bool = false
  var isMatchDeclineAlertPresented: Bool = false

  private(set) var valueTalkModel: ValueTalkModel?
  private(set) var contentOffset: CGFloat = 0
  private(set) var isNameViewVisible: Bool = true
  private(set) var isLoading = true
  private(set) var error: Error?
  private(set) var photoUri: String = ""
  private(set) var isAcceptButtonEnabled: Bool
  private(set) var completedMatchAction: MatchActionType? = nil
  private(set) var matchId: Int
  private let getMatchValueTalkUseCase: GetMatchValueTalkUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let refuseMatchUseCase: RefuseMatchUseCase
  
  func handleAction(_ action: Action) {
    switch action {
    case let .contentOffsetDidChange(offset):
      contentOffset = offset
      isNameViewVisible = offset > Constant.nameVisibilityOffset
      
    case .didTapMoreButton:
      isBottomSheetPresented = true
      PCAmplitude.trackScreenView(DefaultProgress.reportBlockSelectBottomsheet.rawValue)
      
    case .didTapPhotoButton:
      isPhotoViewPresented = true
      
      PCAmplitude.trackButtonClick(
        screenName: .matchDetailValueTalk,
        buttonName: .photoView
      )
      
    case .didTapAcceptButton:
      isMatchAcceptAlertPresented = true
      PCAmplitude.trackScreenView(DefaultProgress.matchDetailAcceptPopup.rawValue)
      
    case .didTapRefuseButton:
      isMatchDeclineAlertPresented = true
      PCAmplitude.trackScreenView(DefaultProgress.matchDetailRejectPopup.rawValue)
      
    case .didAcceptMatch:
      completedMatchAction = nil
      Task {
        await acceptMatch()
        isMatchAcceptAlertPresented = false
        completedMatchAction = .accept
      }

    case .didRefuseMatch:
      completedMatchAction = nil
      Task {
        await refuseMatch()
        isMatchDeclineAlertPresented = false
        completedMatchAction = .refuse
      }
    }
  }
  
  private func fetchMatchValueTalk() async {
    do {
      let entity = try await getMatchValueTalkUseCase.execute(matchId: matchId)
      valueTalkModel = ValueTalkModel(
        id: entity.id,
        description: entity.description,
        nickname: entity.nickname,
        valueTalks: entity.valueTalks.map {
          ValueTalk(
            id: UUID(),
            topic: $0.category,
            summary: $0.summary,
            answer: $0.answer
          )
        }
      )
      
      error = nil
    } catch {
      self.error = error
    }
    isLoading = false
  }
  
  private func fetchMatchPhoto() async {
    do {
      let uri = try await getMatchPhotoUseCase.execute()
      photoUri = uri
    } catch {
      self.error = error
    }
  }
  
  private func acceptMatch() async {
    do {
      _ = try await acceptMatchUseCase.execute()
    } catch {
      self.error = error
    }
  }
  
  private func refuseMatch() async {
    do {
      _ = try await refuseMatchUseCase.execute()
    } catch {
      self.error = error
    }
  }
}
