//
//  MatchingCardListView.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import DesignSystem

// TODO: - 주석 삭제하는 경우 MatchingEmptyCardView에서도 Spacer() 2개 지워야함

// MARK: - User Matching List View (UserRole -> USER)
struct MatchingCardListView: View {
  private let viewModel: MatchingHomeViewModel
//  @State private var createNewMatchButtonHeight: CGFloat = 0
//  @State private var emptyCardViewHeight: CGFloat = 0
  
  @Environment(Router.self) private var router: Router

  init(viewModel: MatchingHomeViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
//    GeometryReader { geometry in
      ScrollView(showsIndicators: false) {
        VStack(spacing: Constants.cardSpacing) {
          if viewModel.matchingCards.isEmpty {
            MatchingEmptyCardView()
//              .frame(height: emptyCardViewHeight)
          } else {
            MatchingCardsView(viewModel: viewModel)
          }

          // TODO: - API 나온 이후 상세 구현
          CreateNewMatchButton(
            isTrial: true, // API CALL
            trialAction: { /* SHOW ALERT */ },
            premiumAction: { /* SHOW ALERT */ }
          )
//          .background(
//            GeometryReader { geometry in
//              Color.clear
//                .onAppear { createNewMatchButtonHeight = geometry.size.height }
//            }
//          )
//        }
      }
      .animation(.interactiveSpring(response: 0.45), value: viewModel.selectedMatchId)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.horizontal, Constants.horizontalMargin)
      .padding(.top, Constants.topMargin)
      .padding(.bottom, Constants.bottomMargin)
//      .onChange(of: createNewMatchButtonHeight) { _, newMatchButtonHeight in
//        emptyCardViewHeight = geometry.size.height - Constants.topMargin - Constants.bottomMargin - newMatchButtonHeight - Constants.cardSpacing
//      }
    }
  }

  enum Constants {
    static let horizontalMargin: CGFloat = 20
    static let topMargin: CGFloat = 16
    static let bottomMargin: CGFloat = 12
    static let cardSpacing: CGFloat = 12
  }
}
