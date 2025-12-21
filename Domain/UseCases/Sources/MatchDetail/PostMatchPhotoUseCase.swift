//
//  PostMatchPhotoUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 12/9/25.
//

import Entities
import RepositoryInterfaces

public protocol PostMatchPhotoUseCase {
  func execute(matchId: Int) async throws -> VoidModel
}

final class PostMatchPhotoUseCaseImpl: PostMatchPhotoUseCase {
  private let repository: MatchesRepositoryInterface
  
  init(repository: MatchesRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(matchId: Int) async throws -> VoidModel {
    try await repository.postMatchImage(matchId: matchId)
  }
}
