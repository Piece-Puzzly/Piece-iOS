//
//  CheckCanFreeMatchUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 12/3/25.
//

import Entities
import RepositoryInterfaces

public protocol CheckCanFreeMatchUseCase {
  func execute() async throws -> CanFreeMatchModel
}

final class CheckCanFreeMatchUseCaseImpl: CheckCanFreeMatchUseCase {
  private let repository: MatchesRepositoryInterface

  init(repository: MatchesRepositoryInterface) {
    self.repository = repository
  }

  func execute() async throws -> CanFreeMatchModel {
    try await repository.getCanFreeMatchToday()
  }
}
