//
//  NormalProductModel.swift
//  Entities
//
//  Created by 홍승완 on 11/2/25.
//

import Foundation

public struct NormalProductModel: Identifiable {
  public let storeProduct: StoreProductModel
  public let backendProduct: BasicCashProductModel
  
  public var id: String { backendProduct.id }
  
  public init(
    storeProduct: StoreProductModel,
    backendProduct: BasicCashProductModel
  ) {
    self.storeProduct = storeProduct
    self.backendProduct = backendProduct
  }
}

extension NormalProductModel {
  public var name: String { backendProduct.name }
  public var originPrice: Int64 { backendProduct.originalAmount }
  public var rewardPuzzleCount: Int64 { backendProduct.rewardPuzzleCount }
  public var currencyCode: String { backendProduct.currencyCode }
  public var isOnSale: Bool { backendProduct.discountRate > 0 }
  public var salePercent: Int { Int(backendProduct.discountRate) }
  
  public var originPriceString: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: originPrice)) ?? String(originPrice)
  }
}
