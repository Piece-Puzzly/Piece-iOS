//
//  MatchingCardsView.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import SwiftUI

struct MatchingCardsView: View {
  private let viewModel: MatchingHomeViewModel

  init(viewModel: MatchingHomeViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ForEach(viewModel.matchingCards) { cardModel in
      MatchingCardView(
        model: cardModel,
        onSelect: { viewModel.handleAction(.onSelectMatchingCard(matchId: cardModel.id)) },
        onConfirm: { viewModel.handleAction(.onConfirmMatchingCard(matchId: cardModel.id)) }
      )
    }
  }
}
