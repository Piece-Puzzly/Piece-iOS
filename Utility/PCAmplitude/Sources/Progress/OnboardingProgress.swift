//
//  OnboardingProgress.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation

public enum OnboardingProgress: String, ProgressTrackable {
  case dailyMatch = "onboarding_dailymatch"
  case safetyNotice = "onboarding_safetynotice"
  
  public var order: Int {
    switch self {
    case .dailyMatch: return 0
    case .safetyNotice: return 1
    }
  }
}
