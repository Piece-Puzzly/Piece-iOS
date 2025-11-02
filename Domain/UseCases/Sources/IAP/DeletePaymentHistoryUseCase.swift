//
//  DeletePaymentHistoryUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 11/2/25.
//

import Entities
import RepositoryInterfaces

public protocol DeletePaymentHistoryUseCase {
  func execute() async throws -> VoidModel
}

final class DeletePaymentHistoryUseCaseImpl: DeletePaymentHistoryUseCase {
  private let repository: IAPRepositoryInterface
  
  init(repository: IAPRepositoryInterface) {
    self.repository = repository
  }
  
  func execute() async throws -> VoidModel {
    try await repository.deletePaymentHistory()
  }
}
