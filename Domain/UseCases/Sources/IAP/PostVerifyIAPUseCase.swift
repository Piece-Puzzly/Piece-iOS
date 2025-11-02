//
//  PostVerifyIAPUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 11/2/25.
//

import Entities
import RepositoryInterfaces

public protocol PostVerifyIAPUseCase {
  func execute(productUUID: String, purchaseCredential: String, store: AppStoreType) async throws -> VoidModel
}

final class PostVerifyIAPUseCaseImpl: PostVerifyIAPUseCase {
  private let repository: IAPRepositoryInterface
  
  init(repository: IAPRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(productUUID: String, purchaseCredential: String, store: AppStoreType) async throws -> VoidModel {
    try await repository.postVerifyIAP(productUUID: productUUID, purchaseCredential: purchaseCredential, store: store)
  }
}
