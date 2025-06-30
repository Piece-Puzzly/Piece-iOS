//
//  UserRepository.swift
//  Repository
//
//  Created by summercat on 2/15/25.
//

import DTO
import Entities
import LocalStorage
import PCNetwork
import RepositoryInterfaces

final class UserRepository: UserRepositoryInterface {
  
  private let networkService: NetworkService

  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  func getUserRole() async throws -> UserInfoModel {
    let endpoint = UserEndpoint.getUserRole
    let response: UserInfoResponseDTO = try await networkService.request(endpoint: endpoint)
    
    updateTokensIfRoleChanged(response: response)
    
    return response.toDomain()
  }
}

private extension UserRepository {
  func updateTokensIfRoleChanged(response userInfoResponse: UserInfoResponseDTO) {
    guard userInfoResponse.hasRoleChanged,
          let accessToken = userInfoResponse.accessToken,
          let refreshToken = userInfoResponse.refreshToken
    else { return }
    
    saveTokens(accessToken: accessToken, refreshToken: refreshToken)
  }
  
  func saveTokens(accessToken: String, refreshToken: String) {
    PCKeychainManager.shared.save(.accessToken, value: accessToken)
    PCKeychainManager.shared.save(.refreshToken, value: refreshToken)
  }
}
