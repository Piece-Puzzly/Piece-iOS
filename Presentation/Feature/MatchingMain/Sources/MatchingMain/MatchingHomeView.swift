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
  @State private var viewModel: MatchingHomeViewModel
  
  @Environment(Router.self) private var router: Router
  @Environment(PCToastManager.self) private var toastManager: PCToastManager
  
  init(
    getUserInfoUseCase: GetUserInfoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        getUserInfoUseCase: getUserInfoUseCase,
        acceptMatchUseCase: acceptMatchUseCase,
        getMatchesInfoUseCase: getMatchesInfoUseCase,
        getUserRejectUseCase: getUserRejectUseCase,
        patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase
      )
    )
  }
  
  var body: some View {
    ZStack {
      BackgroundView()
      
      MainContentView(viewModel: viewModel)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      viewModel.handleAction(.onAppear)
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
  
  private let viewModel: MatchingHomeViewModel
  
  init(viewModel: MatchingHomeViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(spacing: 0) {
      MatchingNavigationBar(viewModel: viewModel)
      
      MatchingListContentView(viewModel: viewModel)
    }
    .padding(.bottom, Constants.tabBarHeight)
  }
  
  enum Constants {
    static let tabBarHeight: CGFloat = 80
  }
}

// MARK: - Matching List Content View
fileprivate struct MatchingListContentView: View {
  private let viewModel: MatchingHomeViewModel
  
  init(viewModel: MatchingHomeViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    switch viewModel.viewState {
    case .loading:
      Text("LOADING STATE")
    
    case .profileStatusRejected:
      Text("PROFILE STATUS REJECTED STATE")
    
    case .userRolePending:
      Text("USERROLE PENDING STATE")
    
    case .userRoleUser:
      Text("USERROLE USER STATE")
    }
  }
}
