//
//  ProfileValueTalkModel.swift
//  Entities
//
//  Created by summercat on 2/13/25.
//

public struct ProfileValueTalkModel: Identifiable, Hashable {
  public let id: Int
  public let valueTalkId: Int
  public let title: String
  public let category: String
  public var summary: String
  public var answer: String
  public let placeholder: String
  public let guides: [String]
  
  public init(
    id: Int,
    valueTalkId: Int,
    title: String,
    category: String,
    summary: String,
    answer: String,
    placeholder: String,
    guides: [String]
  ) {
    self.id = id
    self.valueTalkId = valueTalkId
    self.title = title
    self.category = category
    self.summary = summary
    self.answer = answer
    self.placeholder = placeholder
    self.guides = guides
  }
}

extension ProfileValueTalkModel {
  public func toValueTalkModel() -> ValueTalkModel {
    ValueTalkModel(
      id: self.valueTalkId,
      category: self.category,
      title: self.title,
      placeholder: self.placeholder,
      guides: self.guides,
      answer: self.answer
    )
  }
}
