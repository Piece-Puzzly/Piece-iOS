//
//  StoreMainSkeleton.swift
//  Store
//
//  Created by 홍승완 on 11/11/25.
//

import SwiftUI
import DesignSystem

struct StoreMainSkeletonView: View {
  var body: some View {
    VStack(spacing: 12) {
      PromotionProductCardSkeleton()

      ForEach(0..<4, id: \.self) { _ in
        NormalProductCardSkeleton()
      }
    }
    .padding(.vertical, 20)
  }
}

// MARK: - Promotion Product Card Skeleton
fileprivate struct PromotionProductCardSkeleton: View {
  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(Color.grayscaleWhite)
      .frame(height: 200)
      .pcShimmer()
  }
}

// MARK: - Normal Product Card Skeleton
fileprivate struct NormalProductCardSkeleton: View {
  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(Color.grayscaleWhite)
      .frame(height: 78)
      .pcShimmer()
  }
}
