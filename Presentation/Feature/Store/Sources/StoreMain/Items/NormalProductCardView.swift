//
//  NormalProductCardView.swift
//  Store
//
//  Created by 홍승완 on 11/5/25.
//

import SwiftUI
import Entities
import DesignSystem

struct NormalProductCardView: View {
  private let item: NormalProductModel
  private let onTap: () -> Void
  
  init(
    item: NormalProductModel,
    onTap: @escaping () -> Void
  ) {
    self.item = item
    self.onTap = onTap
  }
  
  var body: some View {
    Button(
      action: onTap,
      label: {
        HStack(alignment: .top, spacing: 0) {
          HStack(spacing: 0) {
            DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage
              .renderingMode(.template)
              .foregroundStyle(.grayscaleBlack)
              .rotationEffect(.degrees(45))
              .padding(.trailing, 6)
            
            Text("\(item.rewardPuzzleCount)")
              .pretendard(.body_M_SB)
              .foregroundStyle(Color.grayscaleBlack)
              .padding(.trailing, 2)
            
            Text("퍼즐")
              .pretendard(.body_M_R)
              .foregroundStyle(Color.grayscaleBlack)
          }
          
          Spacer()
          
          VStack(alignment: .trailing, spacing: 4) {
            HStack(spacing: 0) {
              if item.isOnSale {
                Text("\(item.salePercent)%")
                  .pretendard(.body_M_SB)
                  .foregroundStyle(Color.subDefault)
                  .padding(.trailing, 4)
              }
              
              Text("\(item.backendProduct.discountedAmount)")
                .pretendard(.body_M_SB)
                .foregroundStyle(Color.grayscaleBlack)
              
              Text("원")
                .pretendard(.body_M_R)
                .foregroundStyle(Color.grayscaleBlack)
            }
            
            if item.isOnSale {
              Text("\(item.originPrice)")
                .strikethrough()
                .pretendard(.body_S_R)
                .foregroundStyle(Color.grayscaleDark3)
            }
          }
      }
      .padding(.vertical, 16)
      .padding(.leading, 16)
      .padding(.trailing, 20)
      .background(Color.grayscaleWhite)
      .contentShape(Rectangle())
      .cornerRadius(8)
      }
    )
  }
}

