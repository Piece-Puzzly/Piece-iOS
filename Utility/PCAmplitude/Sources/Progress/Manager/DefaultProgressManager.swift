//
//  DefaultProgressManager.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation

public class DefaultProgressManager: AmplitudeProgressManagable {
  public static let shared = DefaultProgressManager()
  
  private init() {}
  
  public func shouldTrack(_ screenName: String) -> Bool { return true }
  public func updateProgress(_ screenName: String) { }
  public func resetProgress() { }
}
