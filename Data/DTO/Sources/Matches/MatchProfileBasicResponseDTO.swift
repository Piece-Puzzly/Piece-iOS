//
//  MatchProfileBasicResponseDTO.swift
//  DTO
//
//  Created by summercat on 2/11/25.
//

import Entities
import Foundation

public struct MatchProfileBasicResponseDTO: Decodable {
  public let matchId: Int
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

public extension MatchProfileBasicResponseDTO {
  func toDomain() -> MatchProfileBasicModel {
    MatchProfileBasicModel(
      id: matchId,
      matchType: matchType,
      createdAt: createdAt,
      description: description,
      nickname: nickname,
      age: age,
      birthYear: birthYear,
      height: height,
      weight: weight,
      location: location,
      job: job,
      smokingStatus: smokingStatus,
      isImageViewed: isImageViewed
    )
  }
}
