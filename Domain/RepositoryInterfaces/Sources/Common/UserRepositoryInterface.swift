//
//  UserRepositoryInterface.swift
//  RepositoryInterfaces
//
//  Created by summercat on 2/15/25.
//

import Entities

public protocol UserRepositoryInterface {
  func getUserRole() async throws -> UserInfoModel
  func getPuzzleCount() async throws -> PuzzleCountModel
}
