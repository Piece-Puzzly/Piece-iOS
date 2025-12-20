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
  public let matchType: MatchType
  public let createdAt: Date // "2025-12-06T15:51:10.110203"
  public let matchedUserId: Int
  public let matchStatus: MatchStatus
  public let description: String
  public let nickname: String
  public let valueTalks: [MatchValueTalkResponseDTO]
  public let isImageViewed: Bool
}

public extension MatchValueTalksResponseDTO {
  func toDomain() -> MatchValueTalkModel {
    // matchType이 BASIC이면 createdAt에 5분 추가
    let adjustedCreatedAt: Date
    if matchType == .BASIC {
      adjustedCreatedAt = Calendar.current.date(byAdding: .minute, value: 5, to: createdAt) ?? createdAt
    } else {
      adjustedCreatedAt = createdAt
    }
    
    return MatchValueTalkModel(
      id: matchId,
      matchType: matchType,
      createdAt: adjustedCreatedAt,
      matchedUserId: matchedUserId,
      matchStatus: matchStatus,
      description: description,
      nickname: nickname,
      valueTalks: valueTalks.map { $0.toDomain() },
      isImageViewed: isImageViewed
    )
  }
}
