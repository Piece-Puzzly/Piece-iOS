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
    description: String,
    nickname: String,
    valueTalks: [MatchValueTalkItemModel],
    matchType: MatchType,
    createdAt: Date,
    imageViewed: Bool,
  ) {
    self.id = id
    self.description = description
    self.nickname = nickname
    self.valueTalks = valueTalks
    self.matchType = matchType
    self.createdAt = createdAt
    self.imageViewed = imageViewed
  }
  
  public let id: Int
  public let description: String
  public let nickname: String
  public let valueTalks: [MatchValueTalkItemModel]
  public let matchType: MatchType
  public let createdAt: Date // "2025-12-06T15:51:10.110203"
  public let imageViewed: Bool
}
