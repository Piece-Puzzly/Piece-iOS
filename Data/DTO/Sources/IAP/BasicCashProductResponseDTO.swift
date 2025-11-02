//
//  BasicCashProductResponseDTO.swift
//  DTO
//
//  Created by 홍승완 on 11/1/25.
//

import Entities
import Foundation

/// 현금 상품 응답 목록 (일반 상품)
///
public struct BasicCashProductResponseDTO: Decodable {
  public let uuid: String
  public let name: String
  public let rewardPuzzleCount: Int64
  public let originalAmount: Int64
  public let currencyCode: String
  public let discountRate: Double
  public let discountedAmount: Int64
}

public extension BasicCashProductResponseDTO {
  func toDomain() -> BasicCashProductModel {
    return BasicCashProductModel(
      uuid: uuid,
      name: name,
      rewardPuzzleCount: rewardPuzzleCount,
      originalAmount: originalAmount,
      currencyCode: currencyCode,
      discountRate: discountRate,
      discountedAmount: discountedAmount
    )
  }
}

