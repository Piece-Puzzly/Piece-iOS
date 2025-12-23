//
//  IAPRepository.swift
//  Repository
//
//  Created by 홍승완 on 11/1/25.
//

import DTO
import Entities
import PCNetwork
import RepositoryInterfaces

final class IAPRepository: IAPRepositoryInterface {
  private let networkService: NetworkService
  
  public init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  func getCashProducts() async throws -> CashProductsModel {
    let endpoint = IAPEndpoint.getCashProducts
    let responseDto: CashProductsResponseDTO = try await networkService.request(endpoint: endpoint)
    
    return responseDto.toDomain()
  }
  
  func postVerifyIAP(productUUID: String, purchaseCredential: String, store: AppStoreType) async throws -> VerifyIAPModel {
    let dto = PostVerifyIAPRequestDTO(productUUID: productUUID, purchaseCredential: purchaseCredential, store: store)
    let endpoint = IAPEndpoint.postVerifyIAP(dto)
    let responseDto: PostVerifyIAPResponseDTO = try await networkService.request(endpoint: endpoint)

    return responseDto.toDomain()
  }
  
  func deletePaymentHistory() async throws -> VoidModel {
    let endpoint = IAPEndpoint.deletePaymentHistory
    let responseDto: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    
    return responseDto.toDomain()
  }
}
