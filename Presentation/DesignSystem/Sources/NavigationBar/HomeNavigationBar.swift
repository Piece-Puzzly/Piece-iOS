//
//  HomeNavigationBar.swift
//  DesignSystem
//
//  Created by summercat on 1/30/25.
//

import SwiftUI

public struct HomeNavigationBar<LeftButton: View>: View {
  public init(
    title: String? = nil,
    foregroundColor: Color,
    rightIcon: Image? = nil,
    rightIconTap: (() -> Void)? = nil
  ) where LeftButton == EmptyView {
    self.title = title
    self.foregroundColor = foregroundColor
    self.leftButton = nil
    self.leftButtonTap = nil
    self.rightIcon = rightIcon
    self.rightIconTap = rightIconTap
  }
  
  public init(
    foregroundColor: Color,
    @ViewBuilder leftButton: @escaping () -> LeftButton,
    leftButtonTap: (() -> Void)? = nil,
    rightIcon: Image? = nil,
    rightIconTap: (() -> Void)? = nil
  ) {
    self.title = nil
    self.foregroundColor = foregroundColor
    self.leftButton = leftButton
    self.leftButtonTap = leftButtonTap
    self.rightIcon = rightIcon
    self.rightIconTap = rightIconTap
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: 20) {
      if let leftButton {
        Button(
          action: { leftButtonTap?() },
          label: { leftButton() }
        )
        .foregroundStyle(foregroundColor)
        .wixMadeforDisplay(.branding)
        .frame(maxWidth: .infinity, alignment: .leading)
      } else if let title {
        Text(title)
          .foregroundStyle(foregroundColor)
          .wixMadeforDisplay(.branding)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      if let rightIcon {
        rightIcon
          .onTapGesture {
            rightIconTap?()
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 14)
    .background(Color.clear)
  }
  
  public let title: String?
  public let foregroundColor: Color
  public let leftButton: (() -> LeftButton)?
  public let leftButtonTap: (() -> Void)?
  public let rightIcon: Image?
  public let rightIconTap: (() -> Void)?
}

#Preview {
  var puzzleCount: Int = 22
  var puzzleStyle: PCPuzzleCount.Style = .light
  
  ZStack(alignment: .top) {
    Rectangle()
      .fill(.grayscaleBlack)
    VStack {
      /// "타이틀"이 필요한 홈 네비게이션
      HomeNavigationBar(
        title: "Profile",
        foregroundColor: .black,
        rightIcon: DesignSystemAsset.Icons.alarm32.swiftUIImage,
        rightIconTap: { }
      )
      .background(Color.yellow)

      /// "결제 페이지"가 필요한 홈 네비게이션
      HomeNavigationBar(
        foregroundColor: .grayscaleWhite,
        leftButton: { PCPuzzleCount(count: puzzleCount, style: puzzleStyle) },
        leftButtonTap: { /* 스토어뷰 이동 */ },
        rightIcon: DesignSystemAsset.Icons.alarm32.swiftUIImage,
        rightIconTap: { /* 알림 리스트뷰 이동 */ }
      )
    }
  }
}
