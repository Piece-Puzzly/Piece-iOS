//
//  PromotionProductSectionView.swift
//  Store
//
//  Created by 홍승완 on 11/5/25.
//

import SwiftUI
import Entities

struct PromotionProductSectionView: View {
  private let items: [PromotionProductModel]
  private let onTap: (PromotionProductModel) -> Void
  
  init(
    items: [PromotionProductModel],
    onTap: @escaping (PromotionProductModel) -> Void
  ) {
    self.items = items
    self.onTap = onTap
  }
  
  var body: some View {
    LazyVStack(spacing: 12) {
      ForEach(items) { item in
        PromotionProductCardView(item: item) {
          onTap(item)
        }
      }
    }
  }
}
