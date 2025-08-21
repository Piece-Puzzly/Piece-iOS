//
//  SettingsRepositoryInterface.swift
//  RepositoryInterfaces
//
//  Created by summercat on 2/19/25.
//

import Entities

public protocol SettingsRepositoryInterface {
  func getSettingsInfo() async throws -> SettingsInfoModel
  func putSettingsNotification(isEnabled: Bool) async throws -> VoidModel
  func putSettingsBlockAcquaintance(isEnabled: Bool) async throws -> VoidModel
  func getContactsSyncTime() async throws -> ContactsSyncTimeModel
  func patchLogout() async throws -> VoidModel
}
