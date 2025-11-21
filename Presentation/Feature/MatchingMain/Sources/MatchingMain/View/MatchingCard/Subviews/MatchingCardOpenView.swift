//
//  MatchingCardOpenView.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/21/25.
//

import SwiftUI
import DesignSystem
import Entities

struct MatchingCardOpenView: View {
  private let model: MatchingCardModel
  private let action: () -> Void
  
  init(model: MatchingCardModel, action: @escaping () -> Void) {
    self.model = model
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 0) {
        MatchingCardStatusView(model: model)
        
        VStack(alignment: .leading, spacing: 4) {
          Text(model.description)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .foregroundStyle(Color.grayscaleDark2)
            
          Text(model.nickname)
            .foregroundStyle(Color.grayscaleBlack)
          
          Text("나와 ").foregroundStyle(Color.grayscaleDark2) +
          Text("\(model.matchedValueCount)가지").foregroundStyle(Color.grayscaleBlack) +
          Text(" 생각이 닮았어요").foregroundStyle(Color.grayscaleDark2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .pretendard(.heading_L_SB)
        .padding(.top, 40)
        .padding(.bottom, 12)
        
        HStack(spacing: 4) {
          Text("\(model.birthYear.suffix(2))년생")
          Divider(color: .grayscaleLight1, weight: .normal, isVertical: true)
            .frame(height: 12)
          Text(model.location)
          Divider(color: .grayscaleLight1, weight: .normal, isVertical: true)
            .frame(height: 12)
          Text(model.job)
          
          Spacer()
        }
        .pretendard(.body_M_M)
        .foregroundStyle(Color.grayscaleDark2)
      }
      .padding(.top, 20)
      .padding(.bottom, 80)
      .padding(.horizontal, 20)
    }
  }
}
