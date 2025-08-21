//
//  SettingsInfoModel.swift
//  Entities
//
//  Created by summercat on 3/27/25.
//

public struct SettingsInfoModel {
  public let isNotificationEnabled: Bool
  public let isAcquaintanceBlockEnabled: Bool
  
  public init(
    isNotificationEnabled: Bool,
    isAcquaintanceBlockEnabled: Bool
  ) {
    self.isNotificationEnabled = isNotificationEnabled
    self.isAcquaintanceBlockEnabled = isAcquaintanceBlockEnabled
  }
}
