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
    matchInfosList
      .filter { $0.matchStatus != .REFUSED } // 카드가 사라지는 경우 (인연 거절/차단/유효시간 만료/상대방 탈퇴), Figma [매칭홈/기본] 참고
      .map { matchInfo in
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
    // TODO: (매칭상세/연락처확인) 분기
    // - 1. `BEFORE_OPEN`상태의 경우, 구 매칭 조각 확인 체크 API(/api/matches/pieces/check) 콜 해야함
    // - 2.1. `MATCHED`상태의 경우 "연락처 확인 알럿"으로 진입
    // - 2.2. `MATCHED`상태가 아닌 경우 유/무료 카드 (basic, trialPremium, auto) 상관 없이 "매칭 상세"로 진입
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
