//
//  OnboardingProgress.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation

public enum OnboardingProgress: String, ProgressTrackable {
  case onboarding_basic = "onboarding_basic"
  case onboarding_premium = "onboarding_premium"
  case onboarding_greenlight = "onboarding_greenlight"
  case onboarding_talk = "onboarding_talk"
  case onboarding_camera_block = "onboarding_camera_block"
  
  public var order: Int {
    switch self {
    case .onboarding_basic: return 0
    case .onboarding_premium: return 1
    case .onboarding_greenlight: return 2
    case .onboarding_talk: return 3
    case .onboarding_camera_block: return 4
    }
  }
}
