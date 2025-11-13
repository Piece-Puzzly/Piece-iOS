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

extension NormalProductModel {
  public static let `default`: [NormalProductModel] = [
    NormalProductModel(
      storeProduct: StoreProductModel(id: "1", displayName: "", description: "", price: 0, displayPrice: ""),
      backendProduct: BasicCashProductModel(uuid: "11", name: "5 퍼즐", rewardPuzzleCount: 5, originalAmount: 9900, currencyCode: "", discountRate: 0, discountedAmount: 9900)
    ),
    NormalProductModel(
      storeProduct: StoreProductModel(id: "2", displayName: "", description: "", price: 0, displayPrice: ""),
      backendProduct: BasicCashProductModel(uuid: "22", name: "10 퍼즐", rewardPuzzleCount: 10, originalAmount: 19000, currencyCode: "", discountRate: 10, discountedAmount: 17100)
    ),
    NormalProductModel(
      storeProduct: StoreProductModel(id: "3", displayName: "", description: "", price: 0, displayPrice: ""),
      backendProduct: BasicCashProductModel(uuid: "33", name: "20 퍼즐", rewardPuzzleCount: 20, originalAmount: 38000, currencyCode: "", discountRate: 15, discountedAmount: 32300)
    ),
    NormalProductModel(
      storeProduct: StoreProductModel(id: "4", displayName: "", description: "", price: 0, displayPrice: ""),
      backendProduct: BasicCashProductModel(uuid: "44", name: "50 퍼즐", rewardPuzzleCount: 50, originalAmount: 95000, currencyCode: "", discountRate: 20, discountedAmount: 76000)
    )
  ]
}
