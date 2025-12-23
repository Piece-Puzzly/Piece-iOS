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
      .background(
        BackgroundView(model: model)
          .allowsHitTesting(false)
      )
      .clipped()
      .cornerRadius(12)
  }
}

// MARK: - Background View
fileprivate struct BackgroundView: View {
  private let model: MatchingCardModel
  
  init(model: MatchingCardModel) {
    self.model = model
  }
    
  var body: some View {
    if model.matchStatus == .MATCHED {
      DesignSystemAsset.Images.matchingCardBG.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    } else {
      Rectangle()
        .fill(backgroundColor)
    }
  }

  private var backgroundColor: Color {
    switch model.matchStatus {
    case .GREEN_LIGHT:
      return model.matchType == .AUTO
      ? .primaryLight
      : .grayscaleWhite
      
    case .MATCHED:
      return .primaryDefault
      
    default:
      return .grayscaleWhite
    }
  }
}
