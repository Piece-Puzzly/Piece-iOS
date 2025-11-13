//
//  PCShimmer.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/13/25.
//

import SwiftUI

struct PCShimmer: ViewModifier {
  @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
  @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)

  private var gradientColors = [
    Color.grayscaleWhite,
    Color.grayscaleLight2.opacity(0.4),
    Color.grayscaleWhite,
  ]

  func body(content: Content) -> some View {
    content
      .overlay(
        LinearGradient(
          colors: gradientColors,
          startPoint: startPoint,
          endPoint: endPoint
        )
        .mask(content)
      )
      .onAppear {
        withAnimation(.easeIn(duration: 1).repeatForever(autoreverses: false)) {
          startPoint = .init(x: 1, y: 1)
          endPoint = .init(x: 2.2, y: 2.2)
        }
      }
  }
}
