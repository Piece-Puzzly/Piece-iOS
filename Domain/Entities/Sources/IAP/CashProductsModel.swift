//
//  CashProductsModel.swift
//  Entities
//
//  Created by 홍승완 on 11/1/25.
//

import Foundation

public struct CashProductsModel {
  public let basicCashProducts: [BasicCashProductModel]
  public let promotionCashProducts: [PromotionCashProductModel]
  
  public init(
    basicCashProducts: [BasicCashProductModel],
    promotionCashProducts: [PromotionCashProductModel]
  ) {
    self.basicCashProducts = basicCashProducts
    self.promotionCashProducts = promotionCashProducts
  }
}
