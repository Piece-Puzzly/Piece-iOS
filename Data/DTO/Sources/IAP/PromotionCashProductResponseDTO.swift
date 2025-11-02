//
//  PromotionCashProductResponseDTO.swift
//  DTO
//
//  Created by 홍승완 on 11/1/25.
//

import Entities
import Foundation

/// 현금 상품 응답 목록 (프로모션 상품)
/// 
public struct PromotionCashProductResponseDTO: Decodable {
  public let uuid: String
  public let cardImageUrl: String
}

public extension PromotionCashProductResponseDTO {
  func toDomain() -> PromotionCashProductModel {
    return PromotionCashProductModel(
      uuid: uuid,
      cardImageUrl: cardImageUrl
    )
  }
}
