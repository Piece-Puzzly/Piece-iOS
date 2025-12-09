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
    description: String,
    nickname: String,
    valuePicks: [MatchValuePickItemModel],
    matchType: MatchType,
    createdAt: Date,
    isImageViewed: Bool,
  ) {
    self.id = id
    self.description = description
    self.nickname = nickname
    self.valuePicks = valuePicks
    self.matchType = matchType
    self.createdAt = createdAt
    self.isImageViewed = isImageViewed
  }
  
  public let id: Int
  public let description: String
  public let nickname: String
  public let valuePicks: [MatchValuePickItemModel]
  public let matchType: MatchType
  public let createdAt: Date // "2025-12-06T15:51:10.110203"
  public let isImageViewed: Bool
}
