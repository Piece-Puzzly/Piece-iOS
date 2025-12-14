//
//  MatchingDetailAlertType.swift
//  MatchingDetail
//
//  Created by 홍승완 on 12/10/25.
//

import Foundation

enum MatchingDetailAlertType: Identifiable {
  case refuse(matchId: Int)           // 거절
  case freeAccept(matchId: Int)       // 무료수락
  case paidAccept(matchId: Int)       // 유료수락
  case paidPhoto(matchId: Int)        // 유료사진
  case timeExpired(matchId: Int)      // 제한시간 종료
  case insufficientPuzzle             // 퍼즐 부족

  var id: String {
    switch self {
    case .refuse(let matchId):
      return "refuse\(matchId)"
    
    case .freeAccept(let matchId):
      return "freeAccept_\(matchId)"
    
    case .paidAccept(let matchId):
      return "paidAccept_\(matchId)"
    
    case .paidPhoto(let matchId):
      return "paidPhoto_\(matchId)"
    
    case .timeExpired(let matchId):
      return "timeExpired_\(matchId)"
      
    case .insufficientPuzzle:
      return "insufficientPuzzle"
    }
  }
}
