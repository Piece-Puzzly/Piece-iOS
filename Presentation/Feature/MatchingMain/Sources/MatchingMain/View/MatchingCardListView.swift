//
//  MatchingCardListView.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import DesignSystem

// MARK: - User Matching List View (UserRole -> USER)
struct MatchingCardListView: View {
  private let viewModel: MatchingHomeViewModel
  
  init(viewModel: MatchingHomeViewModel) {
    self.viewModel = viewModel
  }
  
  // TODO: - MatchingCard로 분리
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 12) {
        ForEach(0..<100) { val in
          Text("\(val)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .foregroundStyle(.grayscaleWhite)
        .background(.subLight) // TODO: - LAYOUT DUBUG
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .contentMargins(.horizontal, Constants.horizontalMargin)
    .contentMargins(.top, Constants.topMargin)
    .contentMargins(.bottom, Constants.bottomMargin)
  }
  
  enum Constants {
    static let horizontalMargin: CGFloat = 20
    static let topMargin: CGFloat = 20
    static let bottomMargin: CGFloat = 12
  }
}
