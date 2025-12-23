//
//  Lotties.swift
//  DesignSystem
//
//  Created by summercat on 2/16/25.
//

public enum Lotties {
  case onboarding_basic
  case onboarding_premium
  case onboarding_greenlight
  case onboarding_talk
  case aiSummaryLarge
  case piece_logo_wide
  case matching_motion
  case refresh
  case aiLoadingMotion
  
  public var name: String {
    switch self {
    case .onboarding_basic:
      DesignSystemAsset.Lotties.onboardingBasic.name
    case .onboarding_premium:
      DesignSystemAsset.Lotties.onboardingPremium.name
    case .onboarding_greenlight:
      DesignSystemAsset.Lotties.onboardingGreenlight.name
    case .onboarding_talk:
      DesignSystemAsset.Lotties.onboardingTalk.name
    case .aiSummaryLarge: DesignSystemAsset.Lotties.aiSummaryLarge.name
    case .piece_logo_wide: DesignSystemAsset.Lotties.pieceLogoWide.name
    case .matching_motion: DesignSystemAsset.Lotties.matchingMotion.name
    case .refresh:
      DesignSystemAsset.Lotties.iconRefresh.name
    case .aiLoadingMotion: DesignSystemAsset.Lotties.aiLoadingMotion.name
    }
  }
}
