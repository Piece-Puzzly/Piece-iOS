//
//  CanFreeMatchResponseDTO.swift
//  DTO
//
//  Created by 홍승완 on 12/3/25.
//

import Foundation
import Entities

public struct CanFreeMatchResponseDTO: Decodable {
  let canFreeMatch: Bool

  public init(canFreeMatch: Bool) {
    self.canFreeMatch = canFreeMatch
  }
}

public extension CanFreeMatchResponseDTO {
  func toDomain() -> CanFreeMatchModel {
    CanFreeMatchModel(canFreeMatch: canFreeMatch)
  }
}
