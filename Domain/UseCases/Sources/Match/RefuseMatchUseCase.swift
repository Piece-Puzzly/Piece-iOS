//
//  RefuseMatchUseCase.swift
//  UseCases
//
//  Created by summercat on 2/16/25.
//

import Entities
import RepositoryInterfaces

public protocol RefuseMatchUseCase {
  func execute(matchId: Int) async throws -> VoidModel
}

final class RefuseMatchUseCaseImpl: RefuseMatchUseCase {
  private let repository: MatchesRepositoryInterface
  
  init(repository: MatchesRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(matchId: Int) async throws -> VoidModel {
    try await repository.refuseMatch(matchId: matchId)
  }
}
