//
//  ValuePickModel.swift
//  Entities
//
//  Created by summercat on 1/30/25.
//

public struct ValuePickModel: Hashable, Identifiable {
  public init(
    id: Int,
    category: String,
    question: String,
    answers: [ValuePickAnswerModel],
    selectedAnswer: Int?
  ) {
    self.id = id
    self.category = category
    self.question = question
    self.answers = answers
    self.selectedAnswer = selectedAnswer
  }
  
  public let id: Int
  public let category: String
  public let question: String
  public let answers: [ValuePickAnswerModel]
  public var selectedAnswer: Int?
}
