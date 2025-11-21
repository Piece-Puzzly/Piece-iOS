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
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 12) {
        ForEach(viewModel.matchingCards) { cardModel in
          MatchingCardView(
            model: cardModel,
            onSelect: { viewModel.handleAction(.onSelectMatchingCard(matchId: cardModel.id)) },
            onConfirm: { viewModel.handleAction(.onConfirmMatchingCard(matchId: cardModel.id)) }
          )
        }
      }
    }
    .animation(.interactiveSpring(response: 0.45), value: viewModel.selectedMatchId)
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
