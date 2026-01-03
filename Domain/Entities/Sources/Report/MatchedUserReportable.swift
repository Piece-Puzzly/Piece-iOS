//
//  MatchedUserReportable.swift
//  Entities
//
//  Created by 홍승완 on 12/14/25.
//

import Foundation

public protocol MatchedUserReportable {
  var matchedUserId: Int { get }
  var nickname: String { get }
}

public struct ReportUserInfo: Hashable {
  public let matchedUserId: Int
  public let nickname: String

  public init(_ reportable: MatchedUserReportable) {
    self.matchedUserId = reportable.matchedUserId
    self.nickname = reportable.nickname
  }
}
