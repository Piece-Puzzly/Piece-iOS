//
//  ProfileValuePickResponseDTO.swift
//  DTO
//
//  Created by summercat on 2/12/25.
//

import Entities
import Foundation

public struct ProfileValuePickResponseDTO: Decodable {
  public let profileValuePickId: Int
  public let valuePickId: Int
  public let category: String
  public let question: String
  public let answers: [ValuePickAnswerResponseDTO]
  public let selectedAnswer: Int
}

public extension ProfileValuePickResponseDTO {
  func toDomain() -> ProfileValuePickModel {
    return ProfileValuePickModel(
      id: profileValuePickId,
      valuePickId: valuePickId,
      category: category,
      question: question,
      answers: answers.map {
        ValuePickAnswerModel(number: $0.number, content: $0.content)
      },
      selectedAnswer: selectedAnswer
    )
  }
}
