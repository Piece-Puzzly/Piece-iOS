//
//  BasicCashProductModel.swift
//  Entities
//
//  Created by 홍승완 on 11/1/25.
//

import Foundation

public struct BasicCashProductModel: Identifiable {
  public let id: String
  public let name: String
  public let rewardPuzzleCount: Int64
  public let originalAmount: Int64
  public let currencyCode: String
  public let discountRate: Double
  public let discountedAmount: Int64
  
  public init(
    uuid: String,
    name: String,
    rewardPuzzleCount: Int64,
    originalAmount: Int64,
    currencyCode: String,
    discountRate: Double,
    discountedAmount: Int64
  ) {
    self.id = uuid
    self.name = name
    self.rewardPuzzleCount = rewardPuzzleCount
    self.originalAmount = originalAmount
    self.currencyCode = currencyCode
    self.discountRate = discountRate
    self.discountedAmount = discountedAmount
  }
}
