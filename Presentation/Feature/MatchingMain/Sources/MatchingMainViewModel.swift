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

@MainActor
@Observable
final class MatchingMainViewModel {
  enum MatchingButtonState {
    case pending
    case checkMatchingPiece // 매칭 조각 확인하기
    case acceptMatching // 매칭 수락하기
    case responseComplete // 응답 완료
    case checkContact(nickname: String) // 연락처 확인하기
    
    var title: String {
      switch self {
      case .pending:
        "내 프로필 확인하기"
      case .checkMatchingPiece:
        "매칭 조각 확인하기"
      case .acceptMatching:
        "매칭 수락하기"
      case .responseComplete:
        "응답 완료"
      case .checkContact:
        "연락처 확인하기"
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
    case tapProfileInfo // 매칭 조각 확인하고 상대 프로필 눌렀을때
    case tapMatchingButton // 하단 CTA 매칭 버튼 누를시
    case didAcceptMatch // 매칭 수락하기
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
  var profileRejectAlertMessage: String {
    var messages: [String] = []
    if rejectReasonImage { messages.append("얼굴이 잘 나온 사진으로 변경해주세요") }
    if rejectReasonValues { messages.append("가치관 talk을 좀 더 정성스럽게 써주세요") }
    return messages.joined(separator: "\n")
  }
  
  private(set) var name: String = ""
  private(set) var description: String = ""
  private(set) var age: String = ""
  private(set) var location: String = ""
  private(set) var job: String = ""
  private(set) var tags: [String] = []
  private(set) var error: Error?
  private(set) var profileStatus: String = ""
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
    
    Task {
      await getUserRole()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .tapProfileInfo:
      destination = .matchProfileBasic
      
    case .tapMatchingButton:
      handleMatchingButtonTap()
      
    case .didAcceptMatch:
      Task { await acceptMatch() }
    }
  }
  
  private func handleMatchingButtonTap() {
    if matchingButtonDestination == nil || matchingButtonDestination == .matchProfileBasic {
      switch matchingButtonState {
      case .acceptMatching:
        isMatchAcceptAlertPresented = true
      case .checkMatchingPiece:
        Task { await patchCheckMatchingPiece() }
      case .pending, .checkContact, .responseComplete:
        return
      }
    }
  }
  
  private func getUserRole() async {
    do {
      let userInfo = try await getUserInfoUseCase.execute()
      let userRole = userInfo.role
      let profileStatus = userInfo.profileStatus
      
      PCUserDefaultsService.shared.setUserRole(userRole)
      
      switch profileStatus {
      case .REJECTED:
        // 프로필 상태가 REJECTED 일 경우, 해당 api 호출
        await fetchUserRejectState()
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
      isShowMatchingMainBasicCard = true
      
      switch matchStatus {
      case .BEFORE_OPEN:
        // 자신이 매칭 조각 열람 전
        matchingStatus = .BEFORE_OPEN
        matchingButtonState = .checkMatchingPiece
      case .WAITING:
        //자신은 매칭조각 열람, 상대는 매칭 수락 안함(열람했는지도 모름)
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
      
    } catch {
      print("Get Match Status :\(error.localizedDescription)")
      isShowMatchingNodataCard = true
      matchingButtonState = .pending
    }
  }
  
  
  private func fetchUserRejectState() async {
    do {
      let userRejectState = try await getUserRejectUseCase.execute()
      
      profileStatus = userRejectState.profileStatus
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
