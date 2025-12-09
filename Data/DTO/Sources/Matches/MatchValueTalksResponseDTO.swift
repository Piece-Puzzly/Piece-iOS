//
//  MatchValueTalksResponseDTO.swift
//  DTO
//
//  Created by summercat on 2/11/25.
//

import Entities
import Foundation

public struct MatchValueTalksResponseDTO: Decodable {
  public let matchId: Int
  public let description: String
  public let nickname: String
  public let valueTalks: [MatchValueTalkResponseDTO]
  public let matchType: MatchType
  public let createdAt: Date // "2025-12-06T15:51:10.110203"
  public let isImageViewed: Bool
}

public extension MatchValueTalksResponseDTO {
  func toDomain() -> MatchValueTalkModel {
    MatchValueTalkModel(
      id: matchId,
      description: description,
      nickname: nickname,
      valueTalks: valueTalks.map { $0.toDomain() },
      matchType: matchType,
      createdAt: createdAt,
      isImageViewed: isImageViewed,
    )
  }
}
