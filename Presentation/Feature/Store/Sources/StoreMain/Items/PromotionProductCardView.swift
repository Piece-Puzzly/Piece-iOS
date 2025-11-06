//
//  PromotionProductCardView.swift
//  Store
//
//  Created by 홍승완 on 11/5/25.
//

import SwiftUI
import Entities
import DesignSystem

struct PromotionProductCardView: View {
  private let item: PromotionProductModel
  private let onTap: () -> Void
  
  init(
    item: PromotionProductModel,
    onTap: @escaping () -> Void
  ) {
    self.item = item
    self.onTap = onTap
  }
  
  var body: some View {
    Button(
      action: onTap,
      label: {
        DesignSystemAsset.Images.imgLeave.swiftUIImage
          .resizable()
          .frame(height: 200)
          .scaledToFit()
          .contentShape(Rectangle())
          .cornerRadius(8)
      }
    )
  }
}
