//
//  SettingsRepository.swift
//  Repository
//
//  Created by summercat on 2/19/25.
//

import DTO
import Entities
import PCNetwork
import RepositoryInterfaces

final class SettingsRepository: SettingsRepositoryInterface { 
  private let networkService: NetworkService
  
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  func getSettingsInfo() async throws -> SettingsInfoModel {
    let endpoint = SettingsEndpoint.settingsInfo
    let response: SettingsInfoResponseDTO = try await networkService.request(endpoint: endpoint)
    return response.toDomain()
  }
  
  func putSettingsNotification(isEnabled: Bool) async throws -> VoidModel {
    let requestDto = SettingsNotificationRequestDTO(toggle: isEnabled)
    let endpoint = SettingsEndpoint.notification(requestDto)
    let response: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return response.toDomain()
  }
  
  func putSettingsBlockAcquaintance(isEnabled: Bool) async throws -> VoidModel {
    let requestDto = SettingsBlockAcquaintanceRequestDTO(toggle: isEnabled)
    let endpoint = SettingsEndpoint.blockAcquaintance(requestDto)
    let response: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return response.toDomain()
  }
  
  func getContactsSyncTime() async throws -> ContactsSyncTimeModel {
    let endpoint = SettingsEndpoint.fetchBlockContactsSyncTime
    let response: ContactsSyncTimeResponseDTO = try await networkService.request(endpoint: endpoint)
    
    return response.toDomain()
  }
  
  func patchLogout() async throws -> VoidModel {
    let endpoint = SettingsEndpoint.patchLogout
    let response: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    
    return response.toDomain()
  }
}
