//
//  MatchProfileBasicModel.swift
//  Entities
//
//  Created by summercat on 1/30/25.
//

import Foundation

public struct MatchProfileBasicModel: Identifiable {
  public init(
    id: Int, // MARK: matchId
    matchType: MatchType,
    createdAt: Date,
    description: String,
    nickname: String,
    age: Int,
    birthYear: String,
    height: Int,
    weight: Int,
    location: String,
    job: String,
    smokingStatus: String,
    isImageViewed: Bool
  ) {
    self.id = id
    self.matchType = matchType
    self.createdAt = createdAt
    self.description = description
    self.nickname = nickname
    self.age = age
    self.birthYear = birthYear
    self.height = height
    self.weight = weight
    self.location = location
    self.job = job
    self.smokingStatus = smokingStatus
    self.isImageViewed = isImageViewed
  }

  public let id: Int // MARK: matchId
  public let matchType: MatchType
  public let createdAt: Date
  public let description: String
  public let nickname: String
  public let age: Int
  public let birthYear: String
  public let height: Int
  public let weight: Int
  public let location: String
  public let job: String
  public let smokingStatus: String
  public let isImageViewed: Bool
}
