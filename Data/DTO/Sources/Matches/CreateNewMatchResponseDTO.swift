//
//  CreateNewMatchResponseDTO.swift
//  DTO
//
//  Created by 홍승완 on 12/3/25.
//

import Foundation
import Entities

public struct CreateNewMatchResponseDTO: Decodable {
  let matchId: Int
  
  public init(matchId: Int) {
    self.matchId = matchId
  }
}

public extension CreateNewMatchResponseDTO {
  func toDomain() -> CreateNewMatchModel {
    CreateNewMatchModel(
      matchId: matchId
    )
  }
}
