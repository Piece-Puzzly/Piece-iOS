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

@Observable
final class MatchingHomeViewModel {
  enum MatchingHomeViewState {
    case loading
    case profileStatusRejected
    case userRolePending
    case userRoleUser
  }
  
  enum Action {
    case onAppear
  }
  
  private let getUserInfoUseCase: GetUserInfoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let getMatchesInfoUseCase: GetMatchesInfoUseCase
  private let getUserRejectUseCase: GetUserRejectUseCase
  private let patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  
  var viewState: MatchingHomeViewState = .loading
  
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
    }
  }
  
  private func handleOnAppear() {
    Task {
      await getUserRole()
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
//        await fetchUserRejectState()
//        PCAmplitude.trackScreenView(DefaultProgress.matchMainProfileRejectPopup.rawValue)
        // TODO: - View 따로 만들어서 거기서 로직 처리
        viewState = .profileStatusRejected
      case .INCOMPLETE, .REVISED, .APPROVED:
        break
      case .none:
        break
      }
      
      switch userRole {
      case .PENDING:
        // 심사 중 Pending
//        matchingButtonState = .pending
//        isShowMatchingPendingCard = true
//        currentTrackedScreen = .pending
        viewState = .userRolePending
      case .USER:
//        await getMatchesInfo()
        viewState = .userRoleUser
      default: break
      }
      
    } catch {
      print("Get User Role :\(error.localizedDescription)")
    }
  }
}
