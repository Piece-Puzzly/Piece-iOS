//
//  GetCashProductsUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 11/1/25.
//

import Entities
import RepositoryInterfaces

public protocol GetCashProductsUseCase {
  func execute() async throws -> CashProductsModel
}

final class GetCashProductsUseCaseImpl: GetCashProductsUseCase {
  private let repository: IAPRepositoryInterface
  
  init(repository: IAPRepositoryInterface) {
    self.repository = repository
  }
  
  func execute() async throws -> CashProductsModel {
    try await repository.getCashProducts()
  }
}
