//
//  NavigationBar.swift
//  DesignSystem
//
//  Created by eunseou on 12/30/24.
//

import SwiftUI

// NavigationBar 뷰 정의
public struct NavigationBar<RightButton: View>: View {

  public init(
    title: String,
    titleColor: Color = .grayscaleBlack,
    leftButtonTap: (() -> Void)? = nil,
    rightButton: RightButton = EmptyView(),
    backgroundColor: Color = .clear
  ) {
    self.title = title
    self.titleColor = titleColor
    self.leftButtonTap = leftButtonTap
    self.rightButton = rightButton
    self.backgroundColor = backgroundColor
    self.titleView = nil
  }
  
  public init<Title: View>(
    title: @escaping () -> Title,
    leftButtonTap: (() -> Void)? = nil,
    rightButton: RightButton = EmptyView(),
    backgroundColor: Color = .clear
  ) {
    self.title = nil
    self.titleColor = .grayscaleBlack
    self.leftButtonTap = leftButtonTap
    self.rightButton = rightButton
    self.backgroundColor = backgroundColor
    self.titleView = AnyView(title())
  }
  
  // MARK: - Body
  public var body: some View {
    ZStack {
      backgroundColor.edgesIgnoringSafeArea(.top)
      
      HStack(spacing: 8) {
        // Left area
        HStack {
          if let leftButtonTap {
            Button(action: leftButtonTap) {
              Image(.chevronLeft32)
                .renderingMode(.template)
                .foregroundColor(titleColor)
            }
          }
          Spacer()
        }
        .frame(width: 50, alignment: .leading)
        
        Group {
          if let titleView {
            titleView
          } else if let title {
            Text(title)
              .foregroundColor(titleColor)
              .pretendard(.heading_S_SB)
          }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        
        HStack {
          Spacer()
          rightButton
        }
        .frame(width: 50, alignment: .trailing)
      }
      .padding(.horizontal, 20)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 60)
  }
  
  private let title: String?
  private let titleColor: Color
  private let leftButtonTap: (() -> Void)?
  private let rightButton: RightButton
  private let backgroundColor: Color
  private let titleView: AnyView?
}

#Preview {
  VStack {
    NavigationBar(
      title: "title",
      leftButtonTap: {
      },
      rightButton:
        Button { } label: { DesignSystemAsset.Icons.close32.swiftUIImage }
    )
    NavigationBar(
      title: "title",
      rightButton:
        Button { } label: { DesignSystemAsset.Icons.close32.swiftUIImage }
    )
    NavigationBar(
      title: {
        Text("커스텀 타이틀")
          .foregroundStyle(Color.primaryDefault)
          .pretendard(.heading_S_SB)
      },
      rightButton:
        Button { } label: { Text("label") }
    )
    NavigationBar(
      title: "title",
      rightButton:
        Button { } label: { Text("label") }
    )
    NavigationBar(
      title: "프로필 생성하기",
      backgroundColor: .grayscaleWhite
    )
  }
}
