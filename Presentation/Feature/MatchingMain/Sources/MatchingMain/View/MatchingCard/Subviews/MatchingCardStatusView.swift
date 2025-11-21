//
//  MatchingCardStatusView.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/21/25.
//

import SwiftUI
import DesignSystem
import Entities

struct MatchingCardStatusView: View {
  private(set) var model: MatchingCardModel
  
  init(model: MatchingCardModel) {
    self.model = model
  }
  
  var body: some View {
    if model.matchStatus == .REFUSED {
      EmptyView()
    } else {
      HStack(spacing: 8) {
        config.icon
        
        if model.isSelected {
          Text(config.statusText)
            .foregroundStyle(config.statusColor)
            .pretendard(.body_S_SB)
        } else {
          Text(model.nickname)
            .pretendard(.heading_S_SB)
            .foregroundStyle(Color.grayscaleBlack)
        }
        
        Spacer()
        
        HStack(spacing: 4) {
          DesignSystemAsset.Icons.variant2.swiftUIImage
            .renderingMode(.template)

          Text(model.reamainingTime)
            .pretendard(.body_S_M)
        }
        .foregroundStyle(Color.subDefault)
      }
    }
  }
}
