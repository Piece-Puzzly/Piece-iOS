//
//  AmplitudeProgressManager.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation

public protocol AmplitudeProgressManagable {
  func shouldTrack(_ screenName: String) -> Bool
  func updateProgress(_ screenName: String)
  func resetProgress()
}

public protocol ProgressTrackable: CaseIterable, RawRepresentable where RawValue == String  {
  var order: Int { get }
}

public extension ProgressTrackable {
  var order: Int { return -1 }
}
