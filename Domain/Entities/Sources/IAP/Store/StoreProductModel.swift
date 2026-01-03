//
//  StoreProductModel.swift
//  Entities
//
//  Created by 홍승완 on 11/2/25.
//

import Foundation

// MARK: - StoreKit Product
public struct StoreProductModel {
  public let id: String
  public let displayName: String
  public let description: String
  public let price: Decimal
  public let displayPrice: String
  
  public init(
    id: String,
    displayName: String,
    description: String,
    price: Decimal,
    displayPrice: String,
  ) {
    self.id = id
    self.displayName = displayName
    self.description = description
    self.price = price
    self.displayPrice = displayPrice
  }
}
