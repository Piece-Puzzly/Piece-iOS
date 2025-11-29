//
//  MatchingHomeView.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import DesignSystem
import UseCases
import PCAmplitude

struct MatchingHomeView: View {
  @State private var matchingHomeViewModel: MatchingHomeViewModel
  @State private var profileRejectedViewModel: ProfileRejectedViewModel
  
  @Environment(Router.self) private var router: Router
  @Environment(PCToastManager.self) private var toastManager: PCToastManager
  
  init(
    getUserInfoUseCase: GetUserInfoUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase,
  ) {
    _matchingHomeViewModel = .init(
      wrappedValue: .init(
        getUserInfoUseCase: getUserInfoUseCase,
        acceptMatchUseCase: acceptMatchUseCase,
        getMatchesInfoUseCase: getMatchesInfoUseCase,
        patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase,
        getPuzzleCountUseCase: getPuzzleCountUseCase,
      )
    )
    
    _profileRejectedViewModel = .init(
      wrappedValue: .init(
        getUserRejectUseCase: getUserRejectUseCase
      )
    )
  }
  
  var body: some View {
    ZStack {
      BackgroundView()
      
      MainContentView(
        matchingHomeViewModel: matchingHomeViewModel,
        profileRejectedViewModel: profileRejectedViewModel
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      matchingHomeViewModel.handleAction(.onAppear)
    }
    .pcAlert(item: $matchingHomeViewModel.presentedAlert) { alertType in
      switch alertType {
      case .contactConfirm(let matchId):
        AlertView(
          title: { Text(matchingHomeViewModel.matchingCards.first(where: { $0.id == matchId })?.nickname ?? "").foregroundColor(.primaryDefault) + Text("님의\n연락처를 확인할까요?") },
          message: { Text("퍼즐") + Text("3개").foregroundColor(.primaryDefault) + Text("를 사용하면,\n지금 바로 연락처를 확인할 수 있어요.") },
          firstButtonText: "뒤로",
          secondButtonText: "3",
          firstButtonAction: { matchingHomeViewModel.handleAction(.didTapContactConfirmAlertCancel) },
          secondButtonAction: { matchingHomeViewModel.handleAction(.didTapContactConfirmAlertConfirm(matchId: matchId)) },
          secondButtonIcon: DesignSystemAsset.Icons.puzzleSolidRotate32.swiftUIImage
        )
        
      case .insufficientPuzzle:
        AlertView(
          title: { Text("앗, 퍼즐이 부족해요!") },
          message: "스토어에서 퍼즐을 구매하시겠어요?",
          firstButtonText: "뒤로",
          secondButtonText: "구매하기",
          firstButtonAction: { matchingHomeViewModel.handleAction(.didTapInsufficientPuzzleAlertCancel) },
          secondButtonAction: { matchingHomeViewModel.handleAction(.didTapInsufficientPuzzleAlertConfirm) }
        )
      
      case .createNewMatch:
        AlertView(
          title: { Text("새로운 인연을 만나볼까요?") },
          message: { Text("퍼즐") + Text("2개").foregroundColor(.primaryDefault) + Text("로 나와 맞는 인연을 찾아보세요.") },
          firstButtonText: "뒤로",
          secondButtonText: "2",
          firstButtonAction: { matchingHomeViewModel.handleAction(.didTapInsufficientPuzzleAlertCancel) },
          secondButtonAction: { matchingHomeViewModel.handleAction(.didTapInsufficientPuzzleAlertConfirm) },
          secondButtonIcon: DesignSystemAsset.Icons.puzzleSolidRotate32.swiftUIImage
        )
      }
    }
  }
}

// MARK: - Background View
fileprivate struct BackgroundView: View {
  var body: some View {
    Color.grayscaleBlack.edgesIgnoringSafeArea(.all)
  }
}

// MARK: - Main Content View
fileprivate struct MainContentView: View {
  @Environment(Router.self) private var router: Router
  
  private let matchingHomeViewModel: MatchingHomeViewModel
  private let profileRejectedViewModel: ProfileRejectedViewModel
  
  init(
    matchingHomeViewModel: MatchingHomeViewModel,
    profileRejectedViewModel: ProfileRejectedViewModel,
  ) {
    self.matchingHomeViewModel = matchingHomeViewModel
    self.profileRejectedViewModel = profileRejectedViewModel
  }
  
  var body: some View {
    VStack(spacing: 0) {
      MatchingNavigationBar(viewModel: matchingHomeViewModel)
      
      MatchingListContentView(
        matchingHomeViewModel: matchingHomeViewModel,
        profileRejectedViewModel: profileRejectedViewModel
      )
    }
    .padding(.bottom, Constants.tabBarHeight)
  }
  
  enum Constants {
    static let tabBarHeight: CGFloat = 80
  }
}

// MARK: - Matching List Content View
fileprivate struct MatchingListContentView: View {
  private let matchingHomeViewModel: MatchingHomeViewModel
  private let profileRejectedViewModel: ProfileRejectedViewModel
  
  init(
    matchingHomeViewModel: MatchingHomeViewModel,
    profileRejectedViewModel: ProfileRejectedViewModel,
  ) {
    self.matchingHomeViewModel = matchingHomeViewModel
    self.profileRejectedViewModel = profileRejectedViewModel
  }
  
  var body: some View {
    switch matchingHomeViewModel.viewState {
    case .loading:
      Text("LOADING STATE")
    
    case .profileStatusRejected:
      ProfileRejectedView(viewModel: profileRejectedViewModel)
    
    case .userRolePending:
      MatchingPendingCardView()
        .padding(.top, 16)
        .padding(.bottom, 12)
        .padding(.horizontal, 20)
    
    case .userRoleUser:
      MatchingCardListView(viewModel: matchingHomeViewModel)
    }
  }
}
