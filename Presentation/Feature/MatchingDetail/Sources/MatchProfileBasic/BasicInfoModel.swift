//
//  BasicInfoModel.swift
//  MatchingDetail
//
//  Created by summercat on 1/4/25.
//

import Observation
import Entities
import Foundation

struct BasicInfoModel {
  let id: Int
  let matchType: MatchType
  let createdAt: Date
  let matchedUserId: Int
  let matchStatus: MatchStatus
  let description: String
  let nickname: String
  let age: Int
  let birthYear: String
  let height: Int
  let weight: Int
  let location: String
  let job: String
  let smokingStatus: String
  let isImageViewed: Bool
  
  init(model: MatchProfileBasicModel) {
    self.id = model.id
    self.matchType = model.matchType
    self.createdAt = model.createdAt
    self.matchedUserId = model.matchedUserId
    self.matchStatus = model.matchStatus
    self.description = model.description
    self.nickname = model.nickname
    self.age = model.age
    self.birthYear = model.birthYear
    self.height = model.height
    self.weight = model.weight
    self.location = model.location
    self.job = model.job
    self.smokingStatus = model.smokingStatus
    self.isImageViewed = model.isImageViewed
  }
}
