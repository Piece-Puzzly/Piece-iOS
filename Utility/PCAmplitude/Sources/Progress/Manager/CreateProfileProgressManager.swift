//
//  CreateProfileProgressManager.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/16/25.
//

import Foundation
import LocalStorage

public final class CreateProfileProgressManager: AmplitudeProgressManagable {
  public static let shared = CreateProfileProgressManager()
  
  private init() {}
  
  private var currentProgress: Int {
    get { PCUserDefaultsService.shared.getCreateProfileProgress() }
    set { PCUserDefaultsService.shared.setCreateProfileProgress(newValue) }
  }
  
  public func shouldTrack(_ screenName: String) -> Bool {
    guard let progress = CreateProfileProgress(rawValue: screenName) else {
      return true
    }
    print("DEBUG: shouldTrack \(screenName), currentProgress: \(currentProgress), progress.order: \(progress.order)")
    return progress.order > currentProgress
  }
  
  public func updateProgress(_ screenName: String) {
    guard let progress = CreateProfileProgress(rawValue: screenName) else {
      NSLog(">>> DEBUG: 올바르지 않은 createProfile screenName: \(screenName)")
      return
    }
    
    currentProgress = max(currentProgress, progress.order)
  }
  
  public func resetProgress() {
    PCUserDefaultsService.shared.resetCreateProfileProgress()
  }
}
