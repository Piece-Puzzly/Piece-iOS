//
//  MatchInfosModle.swift
//  Entities
//
//  Created by eunseou on 2/15/25.
//

import SwiftUI

public struct MatchInfosModel {
  public let matchId: Int
  public let matchedUserId: Int
  public let matchStatus: MatchStatus
  public let description: String
  public let nickname: String
  public let birthYear: String
  public let location: String
  public let job: String
  public let matchedValueCount: Int
  public let matchedValueList: [String]
  public let blocked: Bool
  
  public init(
    matchId: Int,
    matchedUserId: Int,
    matchStatus: MatchStatus,
    description: String,
    nickname: String,
    birthYear: String,
    location: String,
    job: String,
    matchedValueCount: Int,
    matchedValueList: [String],
    blocked: Bool
  ) {
    self.matchId = matchId
    self.matchedUserId = matchedUserId
    self.matchStatus = matchStatus
    self.description = description
    self.nickname = nickname
    self.birthYear = birthYear
    self.location = location
    self.job = job
    self.matchedValueCount = matchedValueCount
    self.matchedValueList = matchedValueList
    self.blocked = blocked
  }
}
