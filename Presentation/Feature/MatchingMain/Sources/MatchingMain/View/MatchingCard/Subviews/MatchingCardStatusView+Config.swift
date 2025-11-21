//
//  MatchingCardStatusView+Config.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/21/25.
//

import SwiftUI
import DesignSystem
import Entities

extension MatchingCardStatusView {
  struct StatusConfig {
      let icon: Image
      let statusText: String
      let statusColor: Color
    }
    
    var config: StatusConfig {
      switch model.matchStatus {
      case .BEFORE_OPEN:
        return StatusConfig(
          icon: DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage,
          statusText: "오픈 전",
          statusColor: .grayscaleDark2
        )
      case .WAITING:
        return StatusConfig(
          icon: DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage,
          statusText: "응답 대기중",
          statusColor: .grayscaleDark2
        )
      case .RESPONDED:
        return StatusConfig(
          icon: DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage,
          statusText: "응답 완료",
          statusColor: .primaryDefault
        )
      case .GREEN_LIGHT:
        return StatusConfig(
          icon: DesignSystemAsset.Icons.matchingModeHeart20.swiftUIImage,
          statusText: "그린라이트",
          statusColor: .primaryDefault
        )
      case .MATCHED:
        return StatusConfig(
          icon: DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage,
          statusText: "만남 시작",
          statusColor: .primaryDefault
        )
      case .REFUSED:
        return StatusConfig(
          icon: DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage,
          statusText: "NULL",
          statusColor: .grayscaleDark2
        )
      }
    }
}
