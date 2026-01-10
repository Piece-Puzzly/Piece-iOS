//
//  GetUnreadNotificationCountUseCase.swift
//  UseCases
//
//  Created by seuhong on 2026/01/04.
//

import RepositoryInterfaces

public protocol GetUnreadNotificationCountUseCase {
  func execute() async throws -> Int
}

final class GetUnreadNotificationCountUseCaseImpl: GetUnreadNotificationCountUseCase {
  private let repository: NotificationRepositoryInterface
  
  init(repository: NotificationRepositoryInterface) {
    self.repository = repository
  }
  
  func execute() async throws -> Int {
    try await repository.getUnreadCount()
  }
}

