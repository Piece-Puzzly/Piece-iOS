//
//  SignUpProgressManager.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation
import LocalStorage

public final class SignUpProgressManager: AmplitudeProgressManagable {
  public static let shared = SignUpProgressManager()
  
  private init() {}
  
  private var currentProgress: Int {
    get { PCUserDefaultsService.shared.getSignUpProgress() }
    set { PCUserDefaultsService.shared.setSignUpProgress(newValue) }
  }
  
  public func shouldTrack(_ screenName: String) -> Bool {
    guard let progress = SignUpProgress(rawValue: screenName) else {
      return true
    }
    
    return progress.order > currentProgress
  }
  
  public func updateProgress(_ screenName: String) {
    guard let progress = SignUpProgress(rawValue: screenName) else {
      NSLog(">>> DEBUG: 올바르지 않은 signUp screenName: \(screenName)")
      return
    }
    
    currentProgress = max(currentProgress, progress.order)
  }
  
  public func resetProgress() {
    PCUserDefaultsService.shared.resetSignUpProgress()
  }
}
