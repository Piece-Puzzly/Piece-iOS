//
//  TestLoginUseCase.swift
//  UseCases
//
//  Created by summercat on 6/29/25.
//

import Entities
import Foundation
import RepositoryInterfaces

public protocol TestLoginUseCase {
  func execute(password: String) async throws -> SocialLoginResultModel
}

final class TestLoginUseCaseImpl: TestLoginUseCase {
  private let repository: LoginRepositoryInterface

  init(repository: LoginRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(password: String) async throws -> SocialLoginResultModel {
    guard let testId = Bundle.main.object(forInfoDictionaryKey: "TEST_LOGIN_ID") as? String,
          let testUserId = Int(testId),
          let testLoginPassword = Bundle.main.object(forInfoDictionaryKey: "TEST_LOGIN_PASSWORD") as? String else {
      throw TestLoginError.notFound
    }
    
    if password == testLoginPassword {
      return try await repository.testLogin(userId: testUserId)
    } else {
      throw TestLoginError.incorrectPassword
    }
  }
}

