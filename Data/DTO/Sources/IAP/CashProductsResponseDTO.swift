//
//  CashProductsResponseDTO.swift
//  DTO
//
//  Created by 홍승완 on 11/1/25.
//

import Entities
import Foundation

public struct CashProductsResponseDTO: Decodable {
  public let basicCashProducts: [BasicCashProductResponseDTO]
  public let promotionCashProducts: [PromotionCashProductResponseDTO]
}

public extension CashProductsResponseDTO {
  func toDomain() -> CashProductsModel {
    return CashProductsModel(
      basicCashProducts: basicCashProducts.map { $0.toDomain() },
      promotionCashProducts: promotionCashProducts.map { $0.toDomain() }
    )
  }
}

/// Response Example

/*
{
  "status": "success",
  "message": "요청이 성공적으로 처리되었습니다.",
  "data": {
    "basicCashProducts": [
      {
        "uuid": "cac8466e1d114f209759145cf7b4accf",
        "name": "퍼즐 10개",
        "rewardPuzzleCount": 10,
        "originalAmount": 1000,
        "currencyCode": "KRW",
        "discountRate": 10.00,
        "discountedAmount": 900
      },
      
    ],
    "promotionCashProducts": [
      {
        "uuid": "cac8466e1d114f209759145cf7b4accf2",
        "cardImageUrl": "https://piece-object.s3.ap-northeast-2.amazonaws.com/profiles/image/af8524ca-9acd-434e-a4fa-ca34a3a23a5e_%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%86%E1%85%A9%E1%84%89%E1%85%A7%E1%86%AB.png"
      }
    ]
  }
}
*/
