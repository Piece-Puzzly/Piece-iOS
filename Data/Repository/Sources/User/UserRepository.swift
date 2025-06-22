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
    
    return response.toDomain()
  }
}
