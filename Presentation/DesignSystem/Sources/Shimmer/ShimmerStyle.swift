//
//  ShimmerStyle.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/13/25.
//

import SwiftUI

/// Shimmer 효과의 시각적 스타일을 정의하는 enum
///
/// 배경색과 디자인 요구사항에 따라 다양한 shimmer 스타일을 제공합니다.
///
/// **사용 예시:**
/// ```swift
/// // 밝은 배경에 기본 스타일
/// .pcShimmer(style: .light)
///
/// // 어두운 배경에 적합한 스타일
/// .pcShimmer(style: .dark)
///
/// // 매우 약한 효과
/// .pcShimmer(style: .subtle)
///
/// // 커스텀 gradient
/// .pcShimmer(style: .custom([.red, .blue, .red]))
/// ```
public enum ShimmerStyle {
  /// 기본 스타일 - 밝은 배경용
  ///
  /// grayscaleLight2 색상을 사용하여 자연스러운 shimmer 효과를 제공합니다.
  case light

  /// 어두운 배경용 스타일
  ///
  /// grayscaleDark1 색상을 사용하여 어두운 배경에서도 잘 보이는 효과를 제공합니다.
  case dark

  /// 매우 약한 효과
  ///
  /// 흰색 기반의 매우 낮은 opacity를 사용하여 미묘한 shimmer 효과를 제공합니다.
  /// 밝은 배경에서는 거의 보이지 않을 수 있습니다.
  case subtle

  /// 커스텀 gradient 스타일
  ///
  /// 사용자가 정의한 색상 배열로 shimmer 효과를 생성합니다.
  /// - Parameter colors: Gradient에 사용될 색상 배열
  case custom([Color])
}

public extension ShimmerStyle {
  /// 각 스타일에 해당하는 gradient 색상 배열을 반환합니다.
  ///
  /// LinearGradient에 사용될 색상 배열을 제공하며,
  /// 일반적으로 투명 → 색상 → 투명 패턴을 따릅니다.
  var colors: [Color] {
    switch self {
    case .light:
      return [
        Color.clear,
        Color.grayscaleLight2.opacity(0.4),
        Color.clear,
      ]

    case .dark:
      return [
        Color.clear,
        Color.grayscaleDark1.opacity(0.4),
        Color.clear,
      ]

    case .subtle:
      return [
        Color.clear,
        Color.grayscaleWhite.opacity(0.2),
        Color.clear,
      ]

    case .custom(let colors):
      return colors
    }
  }
}
