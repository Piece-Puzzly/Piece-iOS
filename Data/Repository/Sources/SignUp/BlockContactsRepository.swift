//
//  BlockContactsRepository.swift
//  Repository
//
//  Created by eunseou on 2/16/25.
//

import SwiftUI
import DTO
import PCNetwork
import Entities
import RepositoryInterfaces
import LocalStorage

public final class BlockContactsRepository: BlockContactsRepositoryInterface {
  private let networkService: NetworkService
  
  public init (networkService: NetworkService) {
    self.networkService = networkService
  }
  
  public func postBlockContacts(phoneNumbers: BlockContactsModel) async throws -> VoidModel {
    let requestDto = phoneNumbers.toDTO()
    let endpoint = BlockEndpoint.postBlockContacts(body: requestDto)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    
    let now = Date()
    let utcToKst = now.addingTimeInterval(9 * 60 * 60) // UTC를 KST로 변환
    PCUserDefaultsService.shared.setLatestSyncDate(utcToKst)
    return responseDTO.toDomain()
  }
}
