//
//  MatchingAlertType.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/29/25.
//

import SwiftUI

enum MatchingAlertType: Identifiable {
  case contactConfirm(matchId: Int)  // 연락처 확인 알럿
  case insufficientPuzzle            // 퍼즐 부족 알럿
  case createNewMatch                // 새로운 인연 알럿
  case matchPoolExhausted            // 매칭 풀 부족 알럿
  
  var id: String {
    switch self {
    case .contactConfirm(let matchId):
      return "contactConfirm_\(matchId)"
    case .insufficientPuzzle:
      return "insufficientPuzzle"
    case .createNewMatch:
      return "createNewMatch"
    case .matchPoolExhausted:
      return "matchPoolExhausted"
    }
  }
}

