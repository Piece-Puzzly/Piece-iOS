//
//  ValueTalkModel.swift
//  MatchingDetail
//
//  Created by summercat on 1/5/25.
//

import Foundation
import Entities

extension ValueTalkModel: MatchedUserBlockable { }
extension ValueTalkModel: MatchedUserReportable { }

struct ValueTalkModel {
  let id: Int
  let matchType: MatchType
  let createdAt: Date
  let matchedUserId: Int
  let matchStatus: MatchStatus
  let description: String
  let nickname: String
  let valueTalks: [ValueTalk]
  let isImageViewed: Bool
  
  init(model: MatchValueTalkModel) {
    self.id = model.id
    self.matchType = model.matchType
    self.createdAt = model.createdAt
    self.matchedUserId = model.matchedUserId
    self.matchStatus = model.matchStatus
    self.description = model.description
    self.nickname = model.nickname
    self.valueTalks = model.valueTalks.map {
      ValueTalk(
        id: UUID(),
        topic: $0.category,
        summary: $0.summary,
        answer: $0.answer
      )
    }
    self.isImageViewed = model.isImageViewed
  }
}
