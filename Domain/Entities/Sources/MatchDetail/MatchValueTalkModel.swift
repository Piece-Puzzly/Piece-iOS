//
//  MatchValueTalkModel.swift
//  Entities
//
//  Created by summercat on 1/30/25.
//

import Foundation

public struct MatchValueTalkModel: Identifiable {
  public init(
    id: Int,
    matchType: MatchType,
    createdAt: Date,
    matchedUserId: Int,
    matchStatus: MatchStatus,
    description: String,
    nickname: String,
    valueTalks: [MatchValueTalkItemModel],
    isImageViewed: Bool
  ) {
    self.id = id
    self.matchType = matchType
    self.createdAt = createdAt
    self.matchedUserId = matchedUserId
    self.matchStatus = matchStatus
    self.description = description
    self.nickname = nickname
    self.valueTalks = valueTalks
    self.isImageViewed = isImageViewed
  }
  
  public let id: Int
  public let matchType: MatchType
  public let createdAt: Date // "2025-12-06T15:51:10.110203"
  public let matchedUserId: Int
  public let matchStatus: MatchStatus
  public let description: String
  public let nickname: String
  public let valueTalks: [MatchValueTalkItemModel]
  public let isImageViewed: Bool
}
