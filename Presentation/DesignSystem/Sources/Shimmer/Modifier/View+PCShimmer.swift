//
//  View+PCShimmer.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/13/25.
//

import SwiftUI

/// View에 Shimmer 효과를 추가하는 extension
public extension View {
  /// Shimmer 애니메이션 효과를 View에 적용합니다.
  ///
  /// 스켈레톤 UI나 로딩 상태를 표현할 때 사용합니다.
  ///
  /// - Parameter style: Shimmer의 시각적 스타일 (기본값: `.light`)
  /// - Returns: Shimmer 효과가 적용된 View
  ///
  /// **사용 예시:**
  /// ```swift
  /// // 기본 스타일
  /// Rectangle()
  ///   .fill(Color.gray)
  ///   .frame(height: 100)
  ///   .pcShimmer()
  ///
  /// // 커스텀 스타일
  /// Circle()
  ///   .fill(Color.blue)
  ///   .frame(width: 50, height: 50)
  ///   .pcShimmer(style: .subtle)
  /// ```
  func pcShimmer(style: ShimmerStyle = .light) -> some View {
    modifier(PCShimmer(style: style))
  }
}
