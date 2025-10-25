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
      Text("LOADING STATE NAVIGATION BAR")
      
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
      Text("NAVIGATION BAR -> USER STATE")
        .foregroundStyle(.grayscaleWhite)
        .wixMadeforDisplay(.branding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.clear)
    }
  }
}
