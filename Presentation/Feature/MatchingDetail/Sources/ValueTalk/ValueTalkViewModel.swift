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

    case dismissAlert
    case didConfirmAlert(MatchingDetailAlertType)
  }
  
  enum MatchActionType {
      case accept
      case refuse
  }
  
  init(
    matchId: Int,
    getMatchValueTalkUseCase: GetMatchValueTalkUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    refuseMatchUseCase: RefuseMatchUseCase
  ) {
    self.matchId = matchId
    self.getMatchValueTalkUseCase = getMatchValueTalkUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.postMatchPhotoUseCase = postMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.refuseMatchUseCase = refuseMatchUseCase
    self.presentedAlert = nil
    
    Task {
      await fetchMatchValueTalk()
      await fetchMatchPhoto()
    }
  }
  
  let navigationTitle: String = Constant.navigationTitle
  var matchStatus: MatchStatus? = nil
  var isPhotoViewPresented: Bool = false
  var isBottomSheetPresented: Bool = false
  var presentedAlert: MatchingDetailAlertType? = nil

  private(set) var valueTalkModel: ValueTalkModel?
  private(set) var contentOffset: CGFloat = 0
  private(set) var isNameViewVisible: Bool = true
  private(set) var isLoading = true
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
  
  private(set) var completedMatchAction: MatchActionType? = nil
  private(set) var matchId: Int
  private let getMatchValueTalkUseCase: GetMatchValueTalkUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let postMatchPhotoUseCase: PostMatchPhotoUseCase
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
      

    case .dismissAlert:
      presentedAlert = nil

    case .didConfirmAlert(let alertType):
      presentedAlert = nil
      handleAlertConfirm(alertType)
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
      matchStatus = entity.matchStatus
      error = nil
    } catch {
      self.error = error
    }
    isLoading = false
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
  
  private func refuseMatch() async {
    do {
      _ = try await refuseMatchUseCase.execute(matchId: matchId)
    } catch {
      self.error = error
    }
  }
}

private extension ValueTalkViewModel {
  func handleAlertConfirm(_ alertType: MatchingDetailAlertType) {
    switch alertType {
    case .refuse:
      completedMatchAction = nil
      Task {
        await refuseMatch()
        completedMatchAction = .refuse
      }

    case .freeAccept, .paidAccept: // 수락은 따로 검증 없음 -> 토스트는 필요할 것 같은데
      completedMatchAction = nil
      Task {
        await acceptMatch()
        completedMatchAction = .accept
      }

    case .paidPhoto:
      Task {
        await buyMatchPhoto()
        await fetchMatchPhoto()
        await fetchMatchValueTalk()
        isPhotoViewPresented = true
      }

    case .timeExpired:
      // TODO: 뒤로가기 처리
      break
    
    case .insufficientPuzzle:
      // TODO: 스토어 이동
      break
    }
  }
}
