//
//  CreateNewMatchUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 12/3/25.
//

import Entities
import RepositoryInterfaces

public protocol CreateNewMatchUseCase {
  func execute() async throws -> CreateNewMatchModel
}

final class CreateNewMatchUseCaseImpl: CreateNewMatchUseCase {
  private let repository: MatchesRepositoryInterface

  init(repository: MatchesRepositoryInterface) {
    self.repository = repository
  }

  func execute() async throws -> CreateNewMatchModel {
    try await repository.postCreateNewMatch()
  }
}
