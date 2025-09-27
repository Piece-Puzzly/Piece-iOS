//
//  AmplitudeProvider.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/11/25.
//

import AmplitudeSwift
import Foundation

public final class AmplitudeProvider: PCAmplitudeProvider {
  private let amplitude: Amplitude
  
  public init(apiKey: String) {
    self.amplitude = Amplitude(configuration: Configuration(apiKey: apiKey))
  }
  
  public func logEvent(type: AmplitudeEventType, properties: [AmplitudeParameterKey: Any]) {
    let stringProperties = convertProperties(properties)
    
    amplitude.track(
      eventType: type.rawValue,
      eventProperties: stringProperties
    )
    
    NSLog("""
          📢 AMPLITUDE (RELEASE)
          📢 Type: \(type.rawValue)
          📢 Properties: \(stringProperties)
          """
    )
  }
  
  public func setUserId(_ id: String?) {
    if let id {
      amplitude.setUserId(userId: "piece_ios_\(id)")
      NSLog("""
            📢 AMPLITUDE (RELEASE)
            📢 SET USER ID: piece_ios_\(id)"
            """
      )
    } else {
      amplitude.setUserId(userId: nil)
      NSLog("""
            📢 AMPLITUDE (RELEASE)
            📢 CLEAR USER ID => nil
            """
      )
    }
  }
  
  private func convertProperties(_ parameters: [AmplitudeParameterKey: Any]) -> [String: Any] {
    return Dictionary<String, Any>(uniqueKeysWithValues: parameters.map { ($0.rawValue, $1) })
  }
}
