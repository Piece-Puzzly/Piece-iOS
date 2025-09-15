//
//  OnboardingProgressManager.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation
import LocalStorage

public class OnboardingProgressManager: AmplitudeProgressManagable {
  public static let shared = OnboardingProgressManager()
  
  private init() {}
  
  private var currentProgress: Int {
    get { PCUserDefaultsService.shared.getOnboardingProgress() }
    set { PCUserDefaultsService.shared.setOnboardingProgress(newValue) }
  }
  
  public func shouldTrack(_ screenName: String) -> Bool {
    guard let progress = OnboardingProgress(rawValue: screenName) else {
      return true
    }
    
    return progress.order > currentProgress
  }
  
  public func updateProgress(_ screenName: String) {
    guard let progress = OnboardingProgress(rawValue: screenName) else {
      NSLog(">>> DEBUG: 올바르지 않은 onboarding screenName: \(screenName)")
      return
    }
    
    currentProgress = max(currentProgress, progress.order)
  }
  
  public func resetProgress() {
    PCUserDefaultsService.shared.resetOnboardingProgress()
  }
}

