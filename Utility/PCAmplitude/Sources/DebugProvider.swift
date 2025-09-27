//
//  DebugProvider.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/11/25.
//

import Foundation

public final class DebugProvider: PCAmplitudeProvider {
  public init() { }
  
  public func logEvent(type: AmplitudeEventType, properties: [AmplitudeParameterKey: Any]) {
    let stringProperties = Dictionary(uniqueKeysWithValues: properties.map { ($0.rawValue, $1) })
    
    NSLog("""
          🐛 AMPLITUDE (DEBUG)
          🐛 Type: \(type.rawValue)
          🐛 Properties: \(stringProperties)
          """
    )
  }
  
  public func setUserId(_ id: String?) {
    NSLog("""
          🐛 AMPLITUDE (DEBUG)
          🐛 SET USER ID: \(id ?? "nil")
          """
    )
  }
}
