//
//  MatchingCardView.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/16/25.
//

import SwiftUI
import DesignSystem
import Entities

struct MatchingCardView: View {
  private let model: MatchingCardModel
  private let onSelect: () -> Void
  private let onConfirm: () -> Void

  init(
    model: MatchingCardModel,
    onSelect: @escaping () -> Void,
    onConfirm: @escaping () -> Void
  ) {
    self.model = model
    self.onSelect = onSelect
    self.onConfirm = onConfirm
  }

  var body: some View {
    VStack(spacing: 0) {
      if model.isSelected {
        MatchingCardOpenView(model: model, action: onConfirm)
      } else {
        MatchingCardClosedView(model: model, action: onSelect)
      }
    }
    .background(
      Rectangle()
        .fill(
          model.matchStatus == .GREEN_LIGHT
          ? .primaryLight
          : .grayscaleWhite
        )
        .cornerRadius(12)
    )
    .animation(.interactiveSpring, value: model.isSelected)
  }
}

// MARK: - Subviews
fileprivate struct MatchingCardClosedView: View {
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

fileprivate struct MatchingCardOpenView: View {
  private let model: MatchingCardModel
  private let action: () -> Void
  
  init(model: MatchingCardModel, action: @escaping () -> Void) {
    self.model = model
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 0) {
        HStack {
          MatchingCardStatusView(model: model)
          Spacer()
          Text(model.reamainingTime)
            .pretendard(.body_S_M)
            .foregroundStyle(Color.subDefault)
        }
        
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

fileprivate struct MatchingCardStatusView: View {
  private let model: MatchingCardModel
  
  init(model: MatchingCardModel) {
    self.model = model
  }
  
  var body: some View {
    HStack(spacing: 8) {
        switch model.matchStatus {
        case .BEFORE_OPEN:
          DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage
          if model.isSelected {
            Text("오픈 전")
              .foregroundStyle(.grayscaleDark2)
              .pretendard(.body_S_SB)
          } else {
            Text(model.nickname)
              .pretendard(.heading_S_SB)
              .foregroundStyle(Color.grayscaleBlack)
          }
          
        case .WAITING:
          DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage
          if model.isSelected {
            Text("응답 대기중")
              .foregroundStyle(.grayscaleDark2)
              .pretendard(.body_S_SB)
          } else {
            Text(model.nickname)
              .pretendard(.heading_S_SB)
              .foregroundStyle(Color.grayscaleBlack)
          }
          
        case .REFUSED:
          EmptyView()
          
        case .RESPONDED:
          DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage
          if model.isSelected {
            Text("응답 완료")
              .foregroundStyle(.primaryDefault)
              .pretendard(.body_S_SB)
          } else {
           Text(model.nickname)
             .pretendard(.heading_S_SB)
             .foregroundStyle(Color.grayscaleBlack)
         }
          
        case .GREEN_LIGHT:
          DesignSystemAsset.Icons.matchingModeHeart20.swiftUIImage
          if model.isSelected {
          Text("그린라이트")
            .foregroundStyle(.primaryDefault)
            .pretendard(.body_S_SB)
          } else {
           Text(model.nickname)
             .pretendard(.heading_S_SB)
             .foregroundStyle(Color.grayscaleBlack)
         }
          
        case .MATCHED:
          DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage
          if model.isSelected {
            Text("만남 시작")
              .foregroundStyle(.primaryDefault)
              .pretendard(.body_S_SB)
          } else {
            Text(model.nickname)
              .pretendard(.heading_S_SB)
              .foregroundStyle(Color.grayscaleBlack)
          }
        }
    }
  }
}


/*
switch model.matchStatus {
case .BEFORE_OPEN:
//          BeforeOpenCardContent(model: model)
  Text("BEFORE_OPEN\nBEFORE_OPEN")
case .WAITING:
//            WaitingCardContent(model: model)
  Text("WAITTING\nWAITTING")
case .REFUSED:
//            RefusedCardContent(model: model)
  Text("REFUSED\nREFUSED")
case .RESPONDED:
//            RespondedCardContent(model: model)
  Text("RESPONDED\nRESPONDED")
case .GREEN_LIGHT:
//            GreenLightCardContent(model: model)
  Text("GREEN_LIGHT\nGREEN_LIGHT")
case .MATCHED:
//            MatchedCardContent(model: model)
  Text("MATCHED\nMATCHED")
}
*/
