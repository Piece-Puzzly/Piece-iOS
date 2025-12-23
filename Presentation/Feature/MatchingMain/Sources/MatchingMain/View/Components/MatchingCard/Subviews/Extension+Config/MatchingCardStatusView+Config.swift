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
    let subColor: Color
    let nickNameColor: Color
  }
  
  var config: StatusConfig {
    switch model.matchStatus {
    case .BEFORE_OPEN:
      return StatusConfig(
        icon: DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage,
        statusText: "오픈 전",
        statusColor: .grayscaleDark2,
        subColor: .subDefault,
        nickNameColor: .grayscaleBlack
      )
    
    case .WAITING:
      return StatusConfig(
        icon: DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage,
        statusText: "응답 대기중",
        statusColor: .grayscaleDark2,
        subColor: .subDefault,
        nickNameColor: .grayscaleBlack
      )
    
    case .RESPONDED:
      return StatusConfig(
        icon: DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage,
        statusText: "응답 완료",
        statusColor: .primaryDefault,
        subColor: .subDefault,
        nickNameColor: .grayscaleBlack
      )
    
    case .GREEN_LIGHT:
      return StatusConfig(
        icon: DesignSystemAsset.Icons.matchingModeHeart20.swiftUIImage,
        statusText: "그린라이트",
        statusColor: .primaryDefault,
        subColor: .subDefault,
        nickNameColor: .grayscaleBlack
      )
    
    case .MATCHED:
      return StatusConfig(
        icon: DesignSystemAsset.Icons.matchingModeCheckTransparent20.swiftUIImage,
        statusText: "만남 시작",
        statusColor: .grayscaleWhite,
        subColor: .alphaWhite60,
        nickNameColor: .grayscaleWhite
      )
      
    /// (인연 거절) 상태 -> 보이면 안됨 그냥 더미 상태 값
    case .REFUSED, .BLOCKED:
      return StatusConfig(
        icon: DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage,
        statusText: "거절 완료",
        statusColor: .grayscaleDark2,
        subColor: .subDefault,
        nickNameColor: .grayscaleBlack
      )
    }
  }
}
