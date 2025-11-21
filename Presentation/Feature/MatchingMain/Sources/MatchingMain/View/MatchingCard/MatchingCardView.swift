//
//  MatchingCardView.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/16/25.
//

import SwiftUI
import DesignSystem
import Entities

struct MatchingCardView: View {
  private let model: MatchingCardModel
  private let onSelect: () -> Void
  private let onConfirm: () -> Void

  init(
    model: MatchingCardModel,
    onSelect: @escaping () -> Void,
    onConfirm: @escaping () -> Void
  ) {
    self.model = model
    self.onSelect = onSelect
    self.onConfirm = onConfirm
  }

  var body: some View {
    ZStack{
      BackgroundView(matchStatus: model.matchStatus)
      
      VStack(spacing: 0) {
        if model.isSelected {
          MatchingCardOpenView(model: model, action: onConfirm)
            .transition(.asymmetric(
              insertion: .opacity.combined(with: .scale(scale: 0.97)),
              removal: .opacity
            ))
        } else {
          MatchingCardClosedView(model: model, action: onSelect)
            .transition(.asymmetric(
              insertion: .opacity.combined(with: .scale(scale: 0.97)),
              removal: .opacity
            ))
        }
      }
    }
    // MARK:  legacy 선택값과 관련 있는 카드만 애니메이션
//    .animation(.interactiveSpring(response: 0.45), value: model.isSelected)
  }
}

// MARK: - Background View
fileprivate struct BackgroundView: View {
  private let matchStatus: MatchStatus
  
  init(matchStatus: MatchStatus) {
    self.matchStatus = matchStatus
  }
    
  var body: some View {
    Rectangle()
      .fill(
        matchStatus == .GREEN_LIGHT
        ? .primaryLight
        : .grayscaleWhite
      )
      .cornerRadius(12)
  }
}
