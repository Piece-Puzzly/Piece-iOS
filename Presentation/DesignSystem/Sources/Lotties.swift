//
//  Lotties.swift
//  DesignSystem
//
//  Created by summercat on 2/16/25.
//

public enum Lotties {
  case aiSummaryLarge
  case piece_logo_wide
  case matching_motion
  case refresh
  case aiLoadingMotion
  
  public var name: String {
    switch self {
    case .aiSummaryLarge: DesignSystemAsset.Lotties.aiSummaryLarge.name
    case .piece_logo_wide: DesignSystemAsset.Lotties.pieceLogoWide.name
    case .matching_motion: DesignSystemAsset.Lotties.matchingMotion.name
    case .refresh: DesignSystemAsset.Lotties.iconRefresh.name
    case .aiLoadingMotion: DesignSystemAsset.Lotties.aiLoadingMotion.name
    }
  }
}
