//
//  PostMatchContactsUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 12/9/25.
//

import Entities
import RepositoryInterfaces

public protocol PostMatchContactsUseCase {
  func execute(matchId: Int) async throws -> VoidModel
}

final class PostMatchContactsUseCaseImpl: PostMatchContactsUseCase {
  private let repository: MatchesRepositoryInterface
  
  init(repository: MatchesRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(matchId: Int) async throws -> VoidModel {
    try await repository.postMatchContacts(matchId: matchId)
  }
}
