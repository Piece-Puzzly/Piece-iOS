//
//  UserInfoModel.swift
//  Entities
//
//  Created by summercat on 3/5/25.
//

import Foundation

public struct UserInfoModel {
  public let id: Int
  public let role: UserRole
  public let profileStatus: ProfileStatus?
  public let approvedAt: Date?
  
  public init(
    id: Int,
    role: UserRole,
    profileStatus: ProfileStatus?,
    approvedAt: Date?
  ) {
    self.id = id
    self.role = role
    self.profileStatus = profileStatus
    self.approvedAt = approvedAt
  }
}
