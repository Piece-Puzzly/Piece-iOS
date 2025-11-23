//
//  MatchingCardOpenView+Config.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/21/25.
//

import SwiftUI
import DesignSystem
import Entities

extension MatchingCardOpenView {
  struct StatusConfig {
    let hilightedTextColor: Color
    let textColor: Color
    let subTextColor: Color
  }
  
  var config: StatusConfig {
    switch model.matchStatus {
    case .BEFORE_OPEN, .WAITING, .RESPONDED, .GREEN_LIGHT:
      return StatusConfig(
        hilightedTextColor: .grayscaleBlack,
        textColor: .grayscaleDark2,
        subTextColor: .grayscaleLight1,
      )
      
    case .MATCHED:
      return StatusConfig(
        hilightedTextColor: .grayscaleWhite,
        textColor: .alphaWhite60,
        subTextColor: .alphaWhite60,
      )
      
    /// (인연 거절) 상태 -> 보이면 안됨 그냥 더미 상태 값
    case .REFUSED:
      return StatusConfig(
        hilightedTextColor: .grayscaleBlack,
        textColor: .grayscaleDark2,
        subTextColor: .grayscaleLight1,
      )
    }
  }
}
