//
//  GetMatchesInfo.swift
//  UseCases
//
//  Created by eunseou on 2/15/25.
//

import Entities
import LocalStorage
import RepositoryInterfaces

public protocol GetMatchesInfoUseCase {
  func execute() async throws -> [MatchInfosModel]
}

final class GetMatchesInfoUseCaseImpl: GetMatchesInfoUseCase {
  private let repository: MatchesRepositoryInterface
  
  init(repository: MatchesRepositoryInterface) {
    self.repository = repository
  }
  
  func execute() async throws -> [MatchInfosModel] {
    let matchInfo = try await repository.getMatchInfos()
    
    return matchInfo
  }
}
