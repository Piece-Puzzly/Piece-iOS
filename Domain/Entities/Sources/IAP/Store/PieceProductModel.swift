//
//  PieceProductModel.swift
//  Entities
//
//  Created by 홍승완 on 11/2/25.
//

import Foundation

public struct PieceCashProductsModel {
  public let normalProducts: [NormalProductModel]
  public let promotionProducts: [PromotionProductModel]
  
  public init(
    normalProducts: [NormalProductModel],
    promotionProducts: [PromotionProductModel]
  ) {
    self.normalProducts = normalProducts
    self.promotionProducts = promotionProducts
  }
}
