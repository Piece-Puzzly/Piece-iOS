//
//  MatchingCardModel.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/16/25.
//

import Foundation
import Entities

struct MatchingCardModel: Identifiable {
  private(set) var id: Int
  private(set) var matchInfosModel: MatchInfosModel
  private(set) var isSelected: Bool
  
  init(
    matchId: Int,
    matchInfosModel: MatchInfosModel,
    isSelected: Bool
  ) {
    self.id = matchId
    self.matchInfosModel = matchInfosModel
    self.isSelected = isSelected
  }
}

extension MatchingCardModel {
  var matchingType: MatchingType { matchInfosModel.matchingType }
  
  var matchStatus: MatchStatus { matchInfosModel.matchStatus }
  var reamainingTime: String { "23:59:59" }
  
  var description: String { matchInfosModel.description }
  var nickname: String { matchInfosModel.nickname }
  var matchedValueCount: String { String(matchInfosModel.matchedValueCount) }
  
  var birthYear: String { matchInfosModel.birthYear }
  var location: String { matchInfosModel.location }
  var job: String { matchInfosModel.job }
  
  var isBlocked: Bool { matchInfosModel.isBlocked }
}
