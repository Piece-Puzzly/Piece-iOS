//
//  MatchingHomeSkeleton.swift
//  MatchingMain
//
//  Created by 홍승완 on 12/27/25.
//

import SwiftUI
import DesignSystem

struct MatchingHomeSkeletonView: View {
  var body: some View {
    VStack(spacing: 12) {
      SelectedCardSkeleton()

      ForEach(0..<3, id: \.self) { _ in
        DeSelectedCardSkeleton()
      }
    }
  }
}

// MARK: - Promotion Product Card Skeleton
fileprivate struct SelectedCardSkeleton: View {
  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(Color.grayscaleWhite)
      .frame(height: 292)
      .overlay(
        VStack(alignment: .leading, spacing: 0) {
          HStack {
            RoundedRectangle(cornerRadius: 4)
              .fill(Color.grayscaleLight3)
              .frame(width: 80, height: 20)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 4)
              .fill(Color.grayscaleLight3)
              .frame(width: 80, height: 20)
          }
          
          VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
              .fill(Color.grayscaleLight3)
              .frame(height: 100)
            
            RoundedRectangle(cornerRadius: 4)
              .fill(Color.grayscaleLight3)
              .frame(width: 180, height: 20)
          }
          .padding(.top, 40)
          .padding(.bottom, 12)
          
          Spacer()
        }
          .padding(.top, 20)
        
          .padding(.horizontal, 20)
      )
      .pcShimmer()
  }
}

// MARK: - Normal Product Card Skeleton
fileprivate struct DeSelectedCardSkeleton: View {
  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(Color.grayscaleWhite)
      .frame(height: 78)
      .pcShimmer()
  }
}

