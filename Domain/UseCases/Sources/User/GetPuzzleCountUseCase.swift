//
//  GetPuzzleCountUseCase.swift
//  UseCases
//
//  Created by Claude on 11/24/25.
//

import Entities
import RepositoryInterfaces

public protocol GetPuzzleCountUseCase {
  func execute() async throws -> PuzzleCountModel
}

final class GetPuzzleCountUseCaseImpl: GetPuzzleCountUseCase {
  private let repository: UserRepositoryInterface

  init(repository: UserRepositoryInterface) {
    self.repository = repository
  }

  func execute() async throws -> PuzzleCountModel {
    try await repository.getPuzzleCount()
  }
}
