//
//  PCAmplitudeAnalyticsModule.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/11/25.
//

import Foundation
import AmplitudeSwift

enum BuildEnvironment {
  #if DEBUG
  static let isRelease = false
  #else
  static let isRelease = true
  #endif
}

public enum PCAmplitudeConfiguration {
  public static func createProvider() -> PCAmplitudeProvider {
    BuildEnvironment.isRelease ? createReleaseProvider() : createDebugProvider()
  }

  static func createDebugProvider() -> PCAmplitudeProvider {
    return DebugProvider()
  }

  static func createReleaseProvider() -> PCAmplitudeProvider {
    let amplitudeKey = Bundle.main.infoDictionary?["AMPLITUDE_API_KEY"] as? String ?? ""
    return AmplitudeProvider(apiKey: amplitudeKey)
  }
}
