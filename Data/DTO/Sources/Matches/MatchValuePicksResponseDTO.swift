//
//  MatchValuePicksResponseDTO.swift
//  DTO
//
//  Created by summercat on 2/11/25.
//

import Entities
import Foundation

public struct MatchValuePicksResponseDTO: Decodable {
  public let matchId: Int
  public let description: String
  public let nickname: String
  public let valuePicks: [MatchValuePickResponseDTO]
  public let matchType: MatchType
  public let createdAt: Date // "2025-12-06T15:51:10.110203"
  public let isImageViewed: Bool
}

public extension MatchValuePicksResponseDTO {
  func toDomain() -> MatchValuePickModel {
    MatchValuePickModel(
      id: matchId,
      description: description,
      nickname: nickname,
      valuePicks: valuePicks.map { $0.toDomain() },
      matchType: matchType,
      createdAt: createdAt,
      isImageViewed: isImageViewed,
    )
  }
}
