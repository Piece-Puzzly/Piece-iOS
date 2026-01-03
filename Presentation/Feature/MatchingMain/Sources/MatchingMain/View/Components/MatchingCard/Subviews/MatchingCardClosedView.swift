//
//  MatchingCardClosedView.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/21/25.
//

import SwiftUI
import DesignSystem
import Entities

struct MatchingCardClosedView: View {
  private(set) var model: MatchingCardModel
  private let action: () -> Void
  
  init(model: MatchingCardModel, action: @escaping () -> Void) {
    self.model = model
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 4) {
        MatchingCardStatusView(model: model)
        
        HStack(spacing: 4) {
          Text("\(model.birthYear.suffix(2))년생")
            .foregroundStyle(config.textColor)
          
          Divider(color: config.subTextColor, weight: .normal, isVertical: true)
            .frame(height: 12)
          
          Text(model.location)
            .foregroundStyle(config.textColor)
          
          Divider(color: config.subTextColor, weight: .normal, isVertical: true)
            .frame(height: 12)
          
          Text(model.job)
            .foregroundStyle(config.textColor)
        }
        .pretendard(.body_M_M)
        .padding(.vertical, 4)
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 20)
    }
  }
}
