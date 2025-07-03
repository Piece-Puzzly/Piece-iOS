//
//  TestLoginError.swift
//  UseCases
//
//  Created by summercat on 6/29/25.
//

import Foundation

public enum TestLoginError: LocalizedError {
  case notFound
  case incorrectPassword
  
  public var errorDescription: String? {
    switch self {
    case .notFound:
      return "cannot find test login id/password from Info.plist"
    case .incorrectPassword:
      return "test login password is not correct"
    }
  }
}
