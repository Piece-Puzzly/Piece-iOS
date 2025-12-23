//
//  PostVerifyIAPResponseDTO.swift
//  DTO
//
//  Created by 홍승완 on 11/13/25.
//

import Entities
import Foundation

public struct PostVerifyIAPResponseDTO: Decodable {
  public let purchaseId: String
  public let rewardPuzzleCount: Int64
  public let message: String
}

public extension PostVerifyIAPResponseDTO {
  func toDomain() -> VerifyIAPModel {
    return VerifyIAPModel(
      purchaseId: purchaseId,
      rewardPuzzleCount: rewardPuzzleCount,
      message: message
    )
  }
}
