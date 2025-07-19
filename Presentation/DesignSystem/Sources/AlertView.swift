//
//  AlertView.swift
//  DesignSystem
//
//  Created by eunseou on 12/31/24.
//

import SwiftUI

public struct AlertView<Title: View>: View {
  public init(
    icon: Image? = nil,
    @ViewBuilder title: () -> Title,
    message: String,
    firstButtonText: String? = nil,
    secondButtonText: String,
    firstButtonAction: (() -> Void)? = nil,
    secondButtonAction: @escaping () -> Void
  ) {
    self.icon = icon
    self.title = title()
    self.message = message
    self.firstButtonText = firstButtonText
    self.secondButtonText = secondButtonText
    self.firstButtonAction = firstButtonAction
    self.secondButtonAction = secondButtonAction
  }
  
  public var body: some View {
    VStack {
      AlertTopView(
        icon: icon,
        title: title,
        message: message
      )
      AlertBottomView(
        firstButtonText: firstButtonText,
        secondButtonText: secondButtonText,
        firstButtonAction: firstButtonAction,
        secondButtonAction: secondButtonAction
      )
    }
    .frame(maxWidth: 312)
    .background(
      Rectangle()
        .fill(Color.grayscaleWhite)
        .cornerRadius(12)
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
    .background(
      Dimmer()
        .ignoresSafeArea()
    )
  }
  
  private let icon: Image?
  private let title: Title
  private let message: String
  private let firstButtonText: String?
  private let secondButtonText: String
  private let firstButtonAction: (() -> Void)?
  private let secondButtonAction: () -> Void
}

private struct AlertTopView<Title: View>: View {
  var body: some View {
    VStack(spacing: 8) {
      if let icon {
        icon
      }
      title
        .pretendard(.heading_M_SB)
      Text(message)
        .pretendard(.body_S_M)
        .foregroundColor(.grayscaleDark2)
    }
    .multilineTextAlignment(.center)
    .padding(.top, 40)
    .padding(.bottom, 12)
    .padding(.horizontal, 20)
  }
  
  let icon: Image?
  let title: Title
  let message: String
}

private struct AlertBottomView: View {
  var body: some View {
    HStack {
      if let firstButtonText,
         let firstButtonAction {
        RoundedButton(
          type: .outline,
          buttonText: firstButtonText,
          icon: nil,
          width: .maxWidth,
          height: 52,
          action: firstButtonAction
        )
      }
      RoundedButton(
        type: .solid,
        buttonText: secondButtonText,
        icon: nil,
        width: .maxWidth,
        height: 52,
        action: secondButtonAction
      )
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 20)
    .padding(.top, 12)
  }
  
  let firstButtonText: String?
  let secondButtonText: String
  let firstButtonAction: (() -> Void)?
  let secondButtonAction: () -> Void
}

#Preview {
  ZStack{
    Color.grayscaleBlack.ignoresSafeArea()
    VStack{
      AlertView(
        title: { Text("수줍은 수달").foregroundColor(.primaryDefault) + Text("님과의\n인연을 이어갈까요?") },
        message: "서로 수락하면, 연락처가 공개돼요.",
        firstButtonText: "뒤로",
        secondButtonText: "인연 수락하기",
        firstButtonAction: {},
        secondButtonAction: {}
      )
      AlertView(
        icon: DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage,
        title: { Text("수줍은 수달님과의 인연을 이어갈까요?") },
        message: "서로 수락하면, 연락처가 공개돼요.",
        firstButtonText: "label",
        secondButtonText: "label",
        firstButtonAction: {},
        secondButtonAction: {}
      )
      
      AlertView(
        icon: DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage,
        title: { Text("수줍은 수달님과의 인연을 이어갈까요?") },
        message: "서로 수락하면, 연락처가 공개돼요.",
        secondButtonText: "label",
        secondButtonAction: {}
      )
    }
  }
}

