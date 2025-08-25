//
//  PutProfileUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 8/24/25.
//

import Entities
import RepositoryInterfaces

public protocol PutProfileUseCase {
  func execute(profile: ProfileModel) async throws -> VoidModel
}

final class PutProfileUseCaseImpl: PutProfileUseCase {
  private let repository: ProfileRepositoryInterface
  
  init(repository: ProfileRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(profile: ProfileModel) async throws -> VoidModel {
    return try await repository.putProfile(profile)
  }
}
