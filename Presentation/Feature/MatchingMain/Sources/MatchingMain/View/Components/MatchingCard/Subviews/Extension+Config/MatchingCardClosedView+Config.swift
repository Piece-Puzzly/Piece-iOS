//
//  MatchingCardClosedView+Config.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/21/25.
//

import SwiftUI
import DesignSystem
import Entities

extension MatchingCardClosedView {
  struct StatusConfig {
    let hilightedTextColor: Color
    let textColor: Color
    let subTextColor: Color
  }
  
  var config: StatusConfig {
    switch model.matchStatus {
    case .BEFORE_OPEN, .WAITING, .REFUSED, .RESPONDED, .GREEN_LIGHT, .BLOCKED:
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
    }
  }
}

