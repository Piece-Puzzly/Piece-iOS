//
//  PuzzleCountResponseDTO.swift
//  DTO
//
//  Created by 홍승완 on 11/24/25.
//

import Foundation
import Entities

public struct PuzzleCountResponseDTO: Decodable {
  public let puzzleCount: Int

  public init(puzzleCount: Int) {
    self.puzzleCount = puzzleCount
  }
}

public extension PuzzleCountResponseDTO {
  func toDomain() -> PuzzleCountModel {
    PuzzleCountModel(puzzleCount: puzzleCount)
  }
}
