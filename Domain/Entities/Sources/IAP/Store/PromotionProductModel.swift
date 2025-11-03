//
//  PromotionProductModel.swift
//  Entities
//
//  Created by 홍승완 on 11/2/25.
//

import Foundation

public struct PromotionProductModel: Identifiable {
  public let storeProduct: StoreProductModel
  public let backendProduct: PromotionCashProductModel
  
  public var id: String { backendProduct.id }
  
  public init(
    storeProduct: StoreProductModel,
    backendProduct: PromotionCashProductModel
  ) {
    self.storeProduct = storeProduct
    self.backendProduct = backendProduct
  }
}

extension PromotionProductModel {
  public var originPriceString: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
   
    guard let formattedString = formatter.string(from: storeProduct.price as NSDecimalNumber) else {
      return storeProduct.price.description
    }
    
    return formattedString
  }
}
