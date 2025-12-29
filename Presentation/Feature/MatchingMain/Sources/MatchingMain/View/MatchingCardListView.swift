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
  @Environment(Router.self) private var router: Router
  private let viewModel: MatchingHomeViewModel
  
  init(viewModel: MatchingHomeViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
      ScrollViewReader { proxy in
        ScrollView(showsIndicators: false) {
          VStack(spacing: Constants.cardSpacing) {
            if viewModel.matchingCards.isEmpty {
              MatchingEmptyCardView()
            } else {
              MatchingCardsView(viewModel: viewModel)
            }

            CreateNewMatchButton(
              isTrial: viewModel.isTrial,
              action: { viewModel.handleAction(.didTapCreateNewMatchButton) }
            )
        }
        .animation(.interactiveSpring(response: 0.45), value: viewModel.selectedMatchId)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, Constants.horizontalMargin)
        .padding(.top, Constants.topMargin)
        .padding(.bottom, Constants.bottomMargin)
      }
      .onChange(of: viewModel.selectedMatchId) { _, newSelectedId in
        if let selectedId = newSelectedId {
          withAnimation(.interactiveSpring(duration: 0.45)) {
            proxy.scrollTo(selectedId, anchor: .center)
          }
        }
      }
      .onChange(of: viewModel.matchingCards.map { $0.id }) { _, _ in
        if let selectedId = viewModel.selectedMatchId {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.interactiveSpring(duration: 0.45)) {
              proxy.scrollTo(selectedId, anchor: .center)
            }
          }
        }
      }
    }
  }

  enum Constants {
    static let horizontalMargin: CGFloat = 20
    static let topMargin: CGFloat = 16
    static let bottomMargin: CGFloat = 12
    static let cardSpacing: CGFloat = 12
  }
}
