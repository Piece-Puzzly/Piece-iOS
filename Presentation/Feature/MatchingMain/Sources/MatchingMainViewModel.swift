//
//  MatchingMainViewModel.swift
//  MatchingMain
//
//  Created by eunseou on 1/4/25.
//


import DesignSystem
import Router
import SwiftUI
import Observation
import UseCases
import Entities
import LocalStorage
import PCAmplitude

@MainActor
@Observable
final class MatchingMainViewModel {
  enum MatchingMainTrackedScreen {
    case pending
    case nodata
    case home
    case loading
  }
  
  enum MatchingButtonState {
    case pending
    case checkMatchingPiece // 매칭 조각 확인하기
    case acceptMatching // 인연 수락하기
    case responseComplete // 응답 완료
    case checkContact(nickname: String) // 연락처 확인하기
    
    var title: String {
      switch self {
      case .pending:
        "내 프로필 확인하기"
      case .checkMatchingPiece:
        "매칭 조각 확인하기"
      case .acceptMatching:
        "인연 수락하기"
      case .responseComplete:
        "응답 완료"
      case .checkContact:
        "인연 확인하기"
      }
    }
    
    var buttonType: RoundedButton.ButtonType {
      switch self {
      case .pending, .checkMatchingPiece, .acceptMatching, .checkContact:
          .solid
      case .responseComplete:
          .disabled
      }
    }
    
    var destination: Route? {
      switch self {
      case .pending: .previewProfileBasic
      case .checkMatchingPiece: .matchProfileBasic
      case .acceptMatching: nil
      case .responseComplete: nil
      case let .checkContact(nickname): .matchResult(nickname: nickname)
      }
    }
  }
  
  enum Action {
    case onAppear
    case tapProfileInfo // 매칭 조각 확인하고 상대 프로필 눌렀을때
    case tapMatchingButton // 하단 CTA 매칭 버튼 누를시
    case didAcceptMatch // 인연 수락하기
  }
  var currentTrackedScreen: MatchingMainTrackedScreen = .loading
  var trackedScreen: DefaultProgress {
    switch currentTrackedScreen {
    case .pending: .matchMainReviewing
    case .nodata: .matchMainNoMatch
    case .home: .matchMainHome
    case .loading: .matchMainLoading
    }
  }
  var userRole: String {
    PCUserDefaultsService.shared.getUserRole().rawValue
  }
  var isShowMatchingMainBasicCard: Bool = false
  var isShowMatchingNodataCard: Bool = false
  var isShowMatchingPendingCard: Bool = false
  var isMatchAcceptAlertPresented: Bool = false
  var isProfileRejectAlertPresented: Bool {
    rejectReasonImage || rejectReasonValues
  }
  
  private(set) var name: String = ""
  private(set) var description: String = ""
  private(set) var age: String = ""
  private(set) var location: String = ""
  private(set) var job: String = ""
  private(set) var tags: [String] = []
  private(set) var error: Error?
  private(set) var rejectReasonImage: Bool = false
  private(set) var rejectReasonValues: Bool = false
  private let getUserInfoUseCase: GetUserInfoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let getMatchesInfoUseCase: GetMatchesInfoUseCase
  private let getUserRejectUseCase: GetUserRejectUseCase
  private let patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  
  var buttonTitle: String {
    matchingButtonState.title
  }
  var buttonStatus: RoundedButton.ButtonType {
    matchingButtonState.buttonType
  }
  var matchingButtonDestination: Route? {
    matchingButtonState.destination
  }
  var destination: Route?
  var matchingButtonState: MatchingButtonState = .acceptMatching
  var matchingStatus: MatchStatus = .BEFORE_OPEN
  
  init(
    getUserInfoUseCase: GetUserInfoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  ) {
    self.getUserInfoUseCase = getUserInfoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.getMatchesInfoUseCase = getMatchesInfoUseCase
    self.getUserRejectUseCase = getUserRejectUseCase
    self.patchMatchesCheckPieceUseCase = patchMatchesCheckPieceUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleOnAppear()
    case .tapProfileInfo:
      handleProfileInfoTap()
      
    case .tapMatchingButton:
      handleMatchingButtonTap()
      
    case .didAcceptMatch:
      Task { await acceptMatch() }
    }
  }
  
  private func handleOnAppear() {
    destination = nil
    
    Task {
      await getUserRole()
    }
  }
  
  private func handleMatchingButtonTap() {
    if matchingButtonDestination == nil || matchingButtonDestination == .matchProfileBasic {
      switch matchingButtonState {
      case .acceptMatching:
        isMatchAcceptAlertPresented = true
        PCAmplitude.trackScreenView(DefaultProgress.matchMainAcceptPopup.rawValue)
      case .checkMatchingPiece:
        Task {
          await patchCheckMatchingPiece()
          
          PCAmplitude.trackButtonClick(
            screenName: .matchMainHome,
            buttonName: .checkRelationShip
          )
        }
      case .pending, .checkContact, .responseComplete:
        return
      }
    }
  }
  
  private func handleProfileInfoTap() {
    destination = .matchProfileBasic
    
    switch matchingButtonState {
    case .pending:
      break
    
    case .checkMatchingPiece:
      Task { await patchCheckMatchingPiece() }
      
      PCAmplitude.trackButtonClick(
        screenName: .matchMainHome,
        buttonName: .userDescription
      )
    
    case .checkContact, .responseComplete, .acceptMatching:
      PCAmplitude.trackButtonClick(
        screenName: .matchMainHome,
        buttonName: .userDescription
      )
    }
  }
  
  private func getUserRole() async {
    do {
      let userInfo = try await getUserInfoUseCase.execute()
      let userRole = userInfo.role
      let profileStatus = userInfo.profileStatus
      PCUserDefaultsService.shared.setUserRole(userRole)
      PCAmplitude.setUserId(with: String(userInfo.id))
      
      switch profileStatus {
      case .REJECTED:
        // 프로필 상태가 REJECTED 일 경우, 해당 api 호출
        await fetchUserRejectState()
        PCAmplitude.trackScreenView(DefaultProgress.matchMainProfileRejectPopup.rawValue)
      case .INCOMPLETE, .REVISED, .APPROVED:
        break
      case .none:
        break
      }
      
      switch userRole {
      case .PENDING:
        // 심사 중 Pending
        matchingButtonState = .pending
        isShowMatchingPendingCard = true
        currentTrackedScreen = .pending
      case .USER:
        await getMatchesInfo()
      default: break
      }
      
    } catch {
      print("Get User Role :\(error.localizedDescription)")
    }
  }
  
  private func getMatchesInfo() async {
    do {
      let matchesInfo = try await getMatchesInfoUseCase.execute() // 매칭 상태 확인해야함
      let matchStatus = matchesInfo.matchStatus
      
      switch matchStatus {
      case .BEFORE_OPEN:
        // 자신이 매칭 조각 열람 전
        matchingStatus = .BEFORE_OPEN
        matchingButtonState = .checkMatchingPiece
      case .WAITING:
        //자신은 매칭조각 열람, 상대는 인연 수락 안함(열람했는지도 모름)
        matchingStatus = .WAITING
        matchingButtonState = .acceptMatching
      case .REFUSED:
        matchingStatus = .REFUSED
        matchingButtonState = .responseComplete
      case .RESPONDED:
        // 자신은 수락, 상대는 모름
        matchingStatus = .RESPONDED
        matchingButtonState = .responseComplete
      case .GREEN_LIGHT:
        // 자신은 열람만, 상대는 수락
        matchingStatus = .GREEN_LIGHT
        matchingButtonState = .acceptMatching
      case .MATCHED:
          // 둘다 수락
        matchingStatus = .MATCHED
        matchingButtonState = .checkContact(nickname: matchesInfo.nickname)
      }
      
      name = matchesInfo.nickname
      description = matchesInfo.description
      age = matchesInfo.birthYear
      location = matchesInfo.location
      job = matchesInfo.job
      tags = matchesInfo.matchedValueList
      
      if matchesInfo.isBlocked {
        isShowMatchingNodataCard = true
        matchingButtonState = .pending
      } else {
        isShowMatchingMainBasicCard = true
        currentTrackedScreen = .home
      }
    } catch {
      print("Get Match Status :\(error.localizedDescription)")
      isShowMatchingNodataCard = true
      matchingButtonState = .pending
      currentTrackedScreen = .nodata
    }
  }
  
  private func fetchUserRejectState() async {
    do {
      let userRejectState = try await getUserRejectUseCase.execute()
      
      rejectReasonImage = userRejectState.reasonImage
      rejectReasonValues = userRejectState.reasonValues
    } catch {
      print("Get User Reject State :\(error.localizedDescription)")
    }
  }
  
  private func acceptMatch() async {
    do {
      _ = try await acceptMatchUseCase.execute()
      await getMatchesInfo()
    } catch {
      self.error = error
    }
  }
  
  private func patchCheckMatchingPiece() async {
    do {
      _ = try await patchMatchesCheckPieceUseCase.execute()
    } catch {
      self.error = error
    }
  }
}
