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
  @State private(set) var matchingHomeViewModel: MatchingHomeViewModel
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
      MatchingHomeAlertView(matchingHomeViewModel: matchingHomeViewModel, alertType: alertType)
    }
    .spinning(of: matchingHomeViewModel.showSpinner)
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
