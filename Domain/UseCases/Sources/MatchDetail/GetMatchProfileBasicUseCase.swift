//
//  GetMatchProfileBasicUseCase.swift
//  UseCases
//
//  Created by summercat on 1/30/25.
//

import Entities
import RepositoryInterfaces

public protocol GetMatchProfileBasicUseCase {
  func execute(matchId: Int) async throws -> MatchProfileBasicModel
}

final class GetMatchProfileBasicUseCaseImpl: GetMatchProfileBasicUseCase {
  private let repository: MatchesRepositoryInterface
  
  init(repository: MatchesRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(matchId: Int) async throws -> MatchProfileBasicModel {
    try await repository.getMatchesProfileBasic(matchId: matchId)
  }
}
