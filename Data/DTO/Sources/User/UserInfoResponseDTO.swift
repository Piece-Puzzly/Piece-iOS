//
//  UserInfoResponseDTO.swift
//  DTO
//
//  Created by summercat on 3/5/25.
//

import Entities
import Foundation

public struct UserInfoResponseDTO: Decodable {
  public let userId: Int
  public let role: String
  public let profileStatus: ProfileStatus?
  public let hasRoleChanged: Bool
  public let accessToken: String?
  public let refreshToken: String?
}

public extension UserInfoResponseDTO {
  func toDomain() -> UserInfoModel {
    UserInfoModel(
      id: userId,
      role: UserRole(role),
      profileStatus: profileStatus
    )
  }
}

extension ProfileStatus: Decodable { }
