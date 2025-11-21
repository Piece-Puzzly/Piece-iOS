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
  private let model: MatchingCardModel
  private let action: () -> Void
  
  init(model: MatchingCardModel, action: @escaping () -> Void) {
    self.model = model
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          MatchingCardStatusView(model: model)
          Spacer()
          Text(model.reamainingTime)
            .pretendard(.body_S_M)
            .foregroundStyle(Color.subDefault)
        }
        
        HStack(spacing: 4) {
          Text("\(model.birthYear.suffix(2))년생")
          Divider(color: .grayscaleLight1, weight: .normal, isVertical: true)
            .frame(height: 12)
          Text(model.location)
          Divider(color: .grayscaleLight1, weight: .normal, isVertical: true)
            .frame(height: 12)
          Text(model.job)
        }
        .pretendard(.body_M_M)
        .foregroundStyle(Color.grayscaleDark2)
        .padding(.vertical, 4)
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 20)
    }
  }
}
