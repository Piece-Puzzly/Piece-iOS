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
import Entities

struct MatchingHomeView: View {
  @State private(set) var matchingHomeViewModel: MatchingHomeViewModel
  @State private var profileRejectedViewModel: ProfileRejectedViewModel
  
  @Environment(Router.self) private var router: Router
  @Environment(PCToastManager.self) private var toastManager: PCToastManager
  @Environment(\.scenePhase) private var scenePhase
  
  init(
    getUserInfoUseCase: GetUserInfoUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase,
    createNewMatchUseCase: CreateNewMatchUseCase,
    checkCanFreeMatchUseCase: CheckCanFreeMatchUseCase,
    postMatchContactsUseCase: PostMatchContactsUseCase,
    getUnreadNotificationCountUseCase: GetUnreadNotificationCountUseCase
  ) {
    _matchingHomeViewModel = .init(
      wrappedValue: .init(
        getUserInfoUseCase: getUserInfoUseCase,
        getMatchesInfoUseCase: getMatchesInfoUseCase,
        patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase,
        getPuzzleCountUseCase: getPuzzleCountUseCase,
        createNewMatchUseCase: createNewMatchUseCase,
        checkCanFreeMatchUseCase: checkCanFreeMatchUseCase,
        postMatchContactsUseCase: postMatchContactsUseCase,
        getUnreadNotificationCountUseCase: getUnreadNotificationCountUseCase
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
    .toolbar(.hidden, for: .navigationBar)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      matchingHomeViewModel.handleAction(.onAppear)
    }
    .onDisappear {
      toastManager.hideToast(for: .matchingHome)
    }
    .pcAlert(item: $matchingHomeViewModel.presentedAlert) { alertType in
      MatchingHomeAlertView(matchingHomeViewModel: matchingHomeViewModel, alertType: alertType)
    }
    .overlay(alignment: .top) {
      if toastManager.shouldShowToast(for: .matchingHome) {
        PCToast(
          isVisible: Bindable(toastManager).isVisible,
          icon: toastManager.icon,
          text: toastManager.text,
          backgroundColor: toastManager.backgroundColor
        )
        .padding(.top, 56)
      }
    }
    .onChange(of: matchingHomeViewModel.showToastAction) { _, showToastAction in
      guard let showToastAction else { return }
      
      switch showToastAction {
      case .createNewMatch:
        toastManager.showToast(
          target: .matchProfileBasic,
          icon: DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage,
          text: "퍼즐을 \(DomainConstants.PuzzleCost.createNewMatch)개 사용했어요",
          backgroundColor: .primaryDefault
        )
        
      case .checkContact:
        toastManager.showToast(
          target: .matchResult,
          icon: DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage,
          text: "퍼즐을 \(DomainConstants.PuzzleCost.checkContact)개 사용했어요",
          backgroundColor: .primaryDefault
        )
      }
      
      matchingHomeViewModel.handleAction(.clearToast)
    }
    .onChange(of: matchingHomeViewModel.destination) { _, destination in
      guard let destination else { return }
      router.push(to: destination)
    }
    .onReceive(NotificationCenter.default.publisher(for: .refreshHomeData)) { _ in
      matchingHomeViewModel.handleAction(.onAppear)
    }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        matchingHomeViewModel.handleAction(.onAppear)
      }
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
      MatchingHomeSkeletonView()
        .padding(.top, 16)
        .padding(.bottom, 12)
        .padding(.horizontal, 20)
      
    case .profileStatusRejected:
      ProfileRejectedView(viewModel: profileRejectedViewModel)
    
    case .userRolePending:
      MatchingPendingCardView(viewModel: matchingHomeViewModel)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .padding(.horizontal, 20)
    
    case .userRoleUser:
      MatchingCardListView(viewModel: matchingHomeViewModel)
    }
  }
}
