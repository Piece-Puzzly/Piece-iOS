//
//  PromotionCashProductModel.swift
//  Entities
//
//  Created by 홍승완 on 11/1/25.
//

import Foundation

public struct PromotionCashProductModel: Identifiable {
  public let id: String
  public let cardImageUrl: String
  
  public init(uuid: String, cardImageUrl: String) {
    self.id = uuid
    self.cardImageUrl = cardImageUrl
  }
}
