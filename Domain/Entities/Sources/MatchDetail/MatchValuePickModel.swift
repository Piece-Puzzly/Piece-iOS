//
//  MatchValuePickModel.swift
//  Entities
//
//  Created by summercat on 1/30/25.
//

import Foundation

public struct MatchValuePickModel: Identifiable {
  public init(
    id: Int,
    matchType: MatchType,
    createdAt: Date, // "2025-12-06T1
    matchedUserId: Int,
    matchStatus: MatchStatus,
    description: String,
    nickname: String,
    valuePicks: [MatchValuePickItemModel],
    isImageViewed: Bool,
  ) {
    self.id = id
    self.matchType = matchType
    self.createdAt = createdAt
    self.matchedUserId = matchedUserId
    self.matchStatus = matchStatus
    self.description = description
    self.nickname = nickname
    self.valuePicks = valuePicks
    self.isImageViewed = isImageViewed
  }

  public let id: Int
  public let matchType: MatchType
  public let createdAt: Date // "2025-12-06T15:51:10.110203"
  public let matchedUserId: Int
  public let matchStatus: MatchStatus
  public let description: String
  public let nickname: String
  public let valuePicks: [MatchValuePickItemModel]
  public let isImageViewed: Bool
}
