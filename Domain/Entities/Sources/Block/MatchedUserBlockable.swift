//
//  MatchedUserBlockable.swift
//  Entities
//
//  Created by 홍승완 on 12/14/25.
//

import Foundation

public protocol MatchedUserBlockable {
  var id: Int { get }
  var nickname: String { get }
}

public struct BlockUserInfo: Hashable {
  public let matchId: Int
  public let nickname: String
  
  public init(_ blockable: any MatchedUserBlockable) {
    self.matchId = blockable.id
    self.nickname = blockable.nickname
  }
}
