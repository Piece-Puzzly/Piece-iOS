//
//  ProfileValuePickModel.swift
//  Entities
//
//  Created by summercat on 2/13/25.
//

import Foundation

public struct ProfileValuePickModel: Identifiable, Hashable {
  public init(
    id: Int,
    valuePickId: Int,
    category: String,
    question: String,
    answers: [ValuePickAnswerModel],
    selectedAnswer: Int?
  ) {
    self.id = id
    self.valuePickId = valuePickId
    self.category = category
    self.question = question
    self.answers = answers
    self.selectedAnswer = selectedAnswer
  }
  
  public let id: Int
  public let valuePickId: Int
  public let category: String
  public let question: String
  public let answers: [ValuePickAnswerModel]
  public var selectedAnswer: Int?
}

extension ProfileValuePickModel {
  public func toValuePickModel() -> ValuePickModel {
    ValuePickModel(
      id: valuePickId,
      category: category,
      question: question,
      answers: answers,
      selectedAnswer: selectedAnswer
    )
  }
}
