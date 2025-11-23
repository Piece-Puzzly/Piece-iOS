//
//  CreateNewMatchButton.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import SwiftUI
import DesignSystem

struct CreateNewMatchButton: View {
  let isTrial: Bool
  let trialAction: () -> Void
  let premiumAction: () -> Void

  var body: some View {
    Button(action: { isTrial ? trialAction() : premiumAction() }) {
      HStack(spacing: Constants.contentSpacing) {
        makePlusIcon()
        makeDescription()
        Spacer()
        if isTrial { makeTrialBadge() }
      }
    }
    .padding(.horizontal, Constants.horizontalPadding)
    .padding(.vertical, Constants.verticalPadding)
    .background(.grayscaleWhite)
    .cornerRadius(Constants.cornerRadius)
  }

  @ViewBuilder
  private func makePlusIcon() -> some View {
    Circle()
      .fill(Color.grayscaleLight2)
      .frame(width: Constants.iconSize, height: Constants.iconSize)
      .overlay(
        DesignSystemAsset.Icons.plus24.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(.grayscaleDark2)
      )
  }

  @ViewBuilder
  private func makeTrialBadge() -> some View {
    Text("Free")
      .pretendard(.caption_M_M)
      .foregroundStyle(.subDefault)
      .padding(.horizontal, Constants.badgeHorizontalPadding)
      .padding(.vertical, Constants.badgeVerticalPadding)
      .background(.subLight)
      .cornerRadius(Constants.badgeCornerRadius)
      .clipped()
  }

  @ViewBuilder
  private func makeDescription() -> some View {
    Text("새로운 인연 만나기")
      .pretendard(.body_M_SB)
      .foregroundStyle(.grayscaleDark2)
  }

  enum Constants {
    static let contentSpacing: CGFloat = 12
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 12
    static let iconSize: CGFloat = 32
    static let badgeHorizontalPadding: CGFloat = 12
    static let badgeVerticalPadding: CGFloat = 6
    static let badgeCornerRadius: CGFloat = 23
  }
}
