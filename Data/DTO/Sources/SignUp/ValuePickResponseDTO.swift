//
//  ValuePickResponseDTO.swift
//  DTO
//
//  Created by summercat on 2/12/25.
//

import Entities
import Foundation

public struct ValuePickResponseDTO: Decodable {
  public let id: Int
  public let category: String
  public let question: String
  public let answers: [ValuePickAnswerResponseDTO]
  
  public init(
    id: Int,
    category: String,
    question: String,
    answers: [ValuePickAnswerResponseDTO]
  ) {
    self.id = id
    self.category = category
    self.question = question
    self.answers = answers
  }
}

public extension ValuePickResponseDTO {
  func toDomain() -> ValuePickModel {
    return ValuePickModel(
      id: id,
      category: category,
      question: question,
      answers: answers.map {
        ValuePickAnswerModel(number: $0.number, content: $0.content)
      },
      selectedAnswer: nil
    )
  }
}
