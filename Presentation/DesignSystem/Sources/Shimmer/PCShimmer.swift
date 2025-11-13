//
//  PCShimmer.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/13/25.
//

import SwiftUI

/// Shimmer 애니메이션 효과를 제공하는 ViewModifier
///
/// LinearGradient를 사용하여 콘텐츠 위에 부드러운 반짝임 효과를 생성합니다.
/// 스켈레톤 UI에 주로 사용되며, 다양한 스타일을 지원합니다.
///
/// **사용 예시:**
/// ```swift
/// RoundedRectangle(cornerRadius: 8)
///   .fill(Color.gray)
///   .frame(height: 100)
///   .pcShimmer(style: .light)  // 기본 스타일
/// ```
struct PCShimmer: ViewModifier {
  /// Gradient 애니메이션의 시작 위치
  @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)

  /// Gradient 애니메이션의 종료 위치
  @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)

  /// Shimmer의 시각적 스타일 (light, dark, subtle 등)
  private let style: ShimmerStyle

  /// 현재 스타일에 따른 gradient 색상 배열
  private var gradientColors: [Color] { style.colors }

  public init(style: ShimmerStyle) {
    self.style = style
  }

  func body(content: Content) -> some View {
    content
      .overlay(
        // LinearGradient를 content의 shape대로 mask 처리
        LinearGradient(
          colors: gradientColors,
          startPoint: startPoint,
          endPoint: endPoint
        )
        .mask(content)  // content의 모양을 따라 gradient가 잘림
      )
      .onAppear {
        // 왼쪽 위에서 오른쪽 아래로 무한 반복 애니메이션
        withAnimation(.easeIn(duration: 1).repeatForever(autoreverses: false)) {
          startPoint = .init(x: 1, y: 1)
          endPoint = .init(x: 2.2, y: 2.2)
        }
      }
  }
}
