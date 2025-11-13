//
//  ShimmerStyle.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/13/25.
//

import SwiftUI

public enum ShimmerStyle {
  /// 기본 - 밝은 배경용
  case light
  
  /// 어두운 배경용
  case dark
  
  /// 매우 약한 효과 (밝은 배경에서는 전혀 티가 안남)
  case subtle
  
  /// 커스텀 gradient
  case custom([Color])
}

public extension ShimmerStyle {
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
