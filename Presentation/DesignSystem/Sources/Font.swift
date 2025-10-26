//
//  Font.swift
//  DesignSystem
//
//  Created by summercat on 12/22/24.
//

import SwiftUI
import UIKit

public enum Fonts {
  public enum Pretendard {
    case heading_XL_SB
    case heading_L_SB
    case heading_M_SB
    case heading_M_M
    case heading_S_SB
    case heading_S_M
    case body_M_SB
    case body_M_M
    case body_M_R
    case body_S_SB
    case body_S_M
    case body_S_R
    case caption_M_M
    
    var swiftUIFont: Font {
      switch self {
      case .heading_XL_SB: DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 28)
      case .heading_L_SB: DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 24)
      case .heading_M_SB: DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 20)
      case .heading_M_M: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 20)
      case .heading_S_SB: DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 18)
      case .heading_S_M: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 18)
      case .body_M_SB: DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 16)
      case .body_M_M: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 16)
      case .body_M_R: DesignSystemFontFamily.Pretendard.regular.swiftUIFont(size: 16)
      case .body_S_SB: DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 14)
      case .body_S_M: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 14)
      case .body_S_R: DesignSystemFontFamily.Pretendard.regular.swiftUIFont(size: 14)
      case .caption_M_M: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 12)
      }
    }
    
    var uiFont: UIFont {
      switch self {
      case .heading_XL_SB: DesignSystemFontFamily.Pretendard.semiBold.font(size: 28)
      case .heading_L_SB: DesignSystemFontFamily.Pretendard.semiBold.font(size: 24)
      case .heading_M_SB: DesignSystemFontFamily.Pretendard.semiBold.font(size: 20)
      case .heading_M_M: DesignSystemFontFamily.Pretendard.medium.font(size: 20)
      case .heading_S_SB: DesignSystemFontFamily.Pretendard.semiBold.font(size: 18)
      case .heading_S_M: DesignSystemFontFamily.Pretendard.medium.font(size: 18)
      case .body_M_SB: DesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
      case .body_M_M: DesignSystemFontFamily.Pretendard.medium.font(size: 16)
      case .body_M_R: DesignSystemFontFamily.Pretendard.regular.font(size: 16)
      case .body_S_SB: DesignSystemFontFamily.Pretendard.semiBold.font(size: 14)
      case .body_S_M: DesignSystemFontFamily.Pretendard.medium.font(size: 14)
      case .body_S_R: DesignSystemFontFamily.Pretendard.regular.font(size: 14)
      case .caption_M_M: DesignSystemFontFamily.Pretendard.medium.font(size: 12)
      }
    }
    
    var lineHeight: CGFloat {
      switch self {
      case .heading_XL_SB: 40
      case .heading_L_SB: 32
      case .heading_M_SB: 24
      case .heading_S_SB, .heading_S_M: 22
      case .heading_M_M, .body_M_SB, .body_M_M, .body_M_R: 24
      case .body_S_SB, .body_S_M, .body_S_R: 20
      case .caption_M_M: 16
      }
    }
  }
  
  public enum WixMadeforDisplay {
    case branding
    
    var swiftUIFont: Font {
      .system(size: 18)
    }
    
    var uiFont: UIFont {
      DesignSystemFontFamily.WixMadeforDisplay.medium.font(size: 18)
    }
    
    var lineHeight: CGFloat {
      22
    }
  }
}
