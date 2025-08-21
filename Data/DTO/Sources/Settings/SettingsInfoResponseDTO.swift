//
//  SettingsInfoResponseDTO.swift
//  DTO
//
//  Created by summercat on 3/27/25.
//

import Entities
import Foundation

public struct SettingsInfoResponseDTO: Decodable {
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

public extension SettingsInfoResponseDTO {
  func toDomain() -> SettingsInfoModel {
    SettingsInfoModel(
      isNotificationEnabled: isNotificationEnabled,
      isAcquaintanceBlockEnabled: isAcquaintanceBlockEnabled
    )
  }
}
