//
//  VerifyIAPModel.swift
//  Entities
//
//  Created by 홍승완 on 11/13/25.
//

import Foundation

public struct VerifyIAPModel {
  public let purchaseId: String
  public let rewardPuzzleCount: Int64
  public let message: String

  public init(
    purchaseId: String,
    rewardPuzzleCount: Int64,
    message: String
  ) {
    self.purchaseId = purchaseId
    self.rewardPuzzleCount = rewardPuzzleCount
    self.message = message
  }
}
