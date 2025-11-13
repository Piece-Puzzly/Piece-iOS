//
//  NormalProductSectionView.swift
//  Store
//
//  Created by 홍승완 on 11/5/25.
//

import SwiftUI
import Entities

struct NormalProductSectionView: View {
  private let items: [NormalProductModel]
  private let onTap: (NormalProductModel) -> Void
  
  init(
    items: [NormalProductModel],
    onTap: @escaping (NormalProductModel) -> Void
  ) {
    self.items = items
    self.onTap = onTap
  }
  
  var body: some View {
    LazyVStack(spacing: 12) {
      ForEach(items) { item in
        NormalProductCardView(item: item) {
          onTap(item)
        }
      }
    }
  }
}

