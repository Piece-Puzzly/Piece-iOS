//
//  MatchingNavigationBar.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import DesignSystem

struct MatchingNavigationBar: View {
  @Environment(Router.self) private var router: Router
  
  private let viewModel: MatchingHomeViewModel
  
  init(viewModel: MatchingHomeViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    switch viewModel.viewState {
    case .loading:
      HomeNavigationBar(
        foregroundColor: .grayscaleWhite,
        leftButton: { PCPuzzleCount(style: .skeleton(.dark)) },
        leftButtonTap: { /* None Action */ },
        rightIcon: DesignSystemAsset.Icons.alarm32.swiftUIImage,
        rightIconTap: { /* None Action */ }
      )
      
    case .profileStatusRejected, .userRolePending:
      HomeNavigationBar(
        title: "Matching",
        foregroundColor: .grayscaleWhite,
        rightIcon: DesignSystemAsset.Icons.alarm32.swiftUIImage,
        rightIconTap: {
          router.push(to: .notificationList)
        }
      )

    case .userRoleUser:
      HomeNavigationBar(
        foregroundColor: .grayscaleWhite,
        leftButton: { PCPuzzleCount(count: viewModel.puzzleCount, style: .dark) },
        leftButtonTap: {
          router.push(to: .storeMain)
        },
        rightIcon: DesignSystemAsset.Icons.alarm32.swiftUIImage,
        rightIconTap: {
          router.push(to: .notificationList)
        }
      )
    }
  }
}
