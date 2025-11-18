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
  }
  
  private let getUserInfoUseCase: GetUserInfoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let getMatchesInfoUseCase: GetMatchesInfoUseCase
  private let patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  
  private(set) var viewState: MatchingHomeViewState = .loading
  private(set) var matchInfosList: [MatchInfosModel] = []
  private(set) var selectedMatchId: Int?
  
  var matchingCards: [MatchingCardModel] {
    matchInfosList.map { matchInfo in
      MatchingCardModel(
        matchId: matchInfo.matchId,
        matchInfosModel: matchInfo,
        isSelected: matchInfo.matchId == selectedMatchId
      )
    }
  }
  
  init(
    getUserInfoUseCase: GetUserInfoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  ) {
    self.getUserInfoUseCase = getUserInfoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.getMatchesInfoUseCase = getMatchesInfoUseCase
    self.patchMatchesCheckPieceUseCase = patchMatchesCheckPieceUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleOnAppear()

    case .onSelectMatchingCard(let matchId):
      handleOnSelectMatchingCard(matchId)

    case .onConfirmMatchingCard(let matchId):
      handleOnConfirmMatchingCard(matchId)
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
    selectedMatchId = matchId
  }
  
  func handleOnConfirmMatchingCard(_ matchId: Int) {
    // TODO: matchId를 통해 (유료/무료) 카드 분기 처리
    // - 유료 카드 (trialPremium): 퍼즐 사용 알럿 표시
    // - 무료 카드 (basic): 매칭 디테일로 라우팅
    print("DEBUG: onConfirmMatchingCard: \(matchId)")
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
        
      case .USER:
        await loadMatches()
        viewState = .userRoleUser
        
      default:
        break
      }
      
    } catch {
      print("Get User Role :\(error.localizedDescription)")
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
  }
  
  func determineInitialSelection() -> Int? {
    // 1. 타의적 매칭이 아닌 첫 번째 카드
    if let firstNonAuto = matchInfosList.first(where: { $0.matchingType != .auto }) {
      return firstNonAuto.matchId
    }
    // 2. 타의적 매칭만 있는 경우 첫 번째 카드
    return matchInfosList.first?.matchId
  }
}
