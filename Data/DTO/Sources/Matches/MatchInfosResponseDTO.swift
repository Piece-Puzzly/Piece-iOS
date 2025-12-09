//
//  MatchInfosResponseDTO.swift
//  DTO
//
//  Created by eunseou on 2/15/25.
//

import SwiftUI
import Entities

public struct MatchInfosResponseDTO: Decodable {
  public let matchId: Int
  public let matchType: MatchType
  public let createdAt: Date // "2025-12-03T19:18:35.496745"
  public let matchedUserId: Int
  public let matchStatus: MatchStatus
  public let description: String
  public let nickname: String
  public let birthYear: String
  public let location: String
  public let job: String
  public let matchedValueCount: Int
  public let matchedValueList: [String]
  public let isBlocked: Bool
  public let isImageViewed: Bool
  public let isContactViewed: Bool
}

public extension MatchInfosResponseDTO {
  func toDomain() -> MatchInfosModel {
    return MatchInfosModel(
      matchId: matchId,
      matchedUserId: matchedUserId,
      matchType: matchType,
      createdAt: createdAt,
      matchStatus: matchStatus,
      description: description,
      nickname: nickname,
      birthYear: birthYear,
      location: location,
      job: job,
      matchedValueCount: matchedValueCount,
      matchedValueList: matchedValueList,
      isBlocked: isBlocked,
      isImageViewed: isImageViewed,
      isContactViewed: isContactViewed
    )
  }
}

extension MatchStatus: Decodable { }
extension MatchType: Decodable { }
