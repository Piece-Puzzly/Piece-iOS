//
//  MatchContactsModel.swift
//  Entities
//
//  Created by summercat on 2/20/25.
//

public struct MatchContactsModel {
  public let nickname: String
  public let imageUrl: String
  public let contacts: [ContactModel]
  
  public init(
    nickname: String,
    imageUrl: String,
    contacts: [ContactModel],
  ) {
    self.nickname = nickname
    self.imageUrl = imageUrl
    self.contacts = contacts
  }
}
