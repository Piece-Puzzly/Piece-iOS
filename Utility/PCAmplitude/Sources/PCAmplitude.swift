//
//  PCAmplitude.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/11/25.
//

import Foundation

public protocol PCAmplitudeTrackable: RawRepresentable, Hashable where RawValue == String {}

public protocol PCAmplitudeProvider {
  func logEvent(type: AmplitudeEventType, properties: [AmplitudeParameterKey: Any])
  func setUserId(_ id: String?)
}

public enum PCAmplitude {
  private static var provider: PCAmplitudeProvider = DebugProvider()
  
  public static func configure() {
    self.provider = PCAmplitudeConfiguration.createProvider()
  }
  
  public static func setUserId(with id: String?) {
    self.provider.setUserId(id)
  }
  
  public static func clearUserId() {
    self.provider.setUserId(nil)
  }
  
  public static func trackScreenView(_ screenName: String) {
    provider.logEvent(
      type: .screenView,
      properties: [
        .screenName: screenName
      ]
    )
  }
  
  public static func trackScreenView<T: PCAmplitudeTrackable>(_ trackable: T) {
    provider.logEvent(
      type: .screenView,
      properties: [
        .screenName: trackable.rawValue
      ]
    )
  }
  
  public static func trackButtonClick(
    screenName: PCAmplitudeButtonClickScreen,
    buttonName: PCAmplitudeButtonName,
    properties additionalProperties: [AmplitudeParameterKey: Any]? = nil
  ) {
    var properties: [AmplitudeParameterKey: Any] = [
      .screenName : screenName.rawValue,
      .buttonName : buttonName.buttonName
    ]
    
    if let additionalProperties {
      properties.merge(additionalProperties) { _, new in new }
    }
    
    provider.logEvent(type: .buttonClick, properties: properties)
  }
  
  public static func trackAction(
    screenName: String,
    actionName: String,
    properties additionalProperties: [AmplitudeParameterKey: Any]? = nil
  ) {
    var properties: [AmplitudeParameterKey: Any] = [
      .screenName : screenName,
      .actionName : actionName
    ]
    
    if let additionalProperties {
      properties.merge(additionalProperties) { _, new in new }
    }
    
    provider.logEvent(type: .action, properties: properties)
  }
  
  public static func trackAction(
    action: PCAmplitudeAction,
    properties additionalProperties: [AmplitudeParameterKey: Any]? = nil
  ) {
    var properties: [AmplitudeParameterKey: Any] = [
      .screenName : action.screenName,
      .actionName : action.actionName
    ]
    
    if let additionalProperties {
      properties.merge(additionalProperties) { _, new in new }
    }
    
    provider.logEvent(type: .action, properties: properties)
  }
}
