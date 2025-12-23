//
//  PromotionProductCardView.swift
//  Store
//
//  Created by 홍승완 on 11/5/25.
//

import SwiftUI
import Entities
import SDWebImageSwiftUI

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
      label: { PromotionProductSVG(item: item) }
    )
  }
}

fileprivate struct PromotionProductSVG: View {
  private let item: PromotionProductModel
  
  init(item: PromotionProductModel) {
    self.item = item
  }
  
  var body: some View {
    WebImage(url: URL(string: item.backendProduct.cardImageUrl))
      .resizable()
      .scaledToFit()
  }
}
