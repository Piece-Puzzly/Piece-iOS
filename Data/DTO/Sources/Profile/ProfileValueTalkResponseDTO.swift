//
//  ProfileValueTalkResponseDTO.swift
//  DTO
//
//  Created by summercat on 2/13/25.
//

import Entities
import Foundation

public struct ProfileValueTalkResponseDTO: Decodable {
  public let profileValueTalkId: Int
  public let valueTalkId: Int
  public let title: String
  public let category: String
  public let summary: String
  public let answer: String
  public let placeholder: String
  public let guides: [String]
}

public extension ProfileValueTalkResponseDTO {
  func toDomain() -> ProfileValueTalkModel {
    ProfileValueTalkModel(
      id: profileValueTalkId,
      valueTalkId: valueTalkId,
      title: title,
      category: category,
      summary: summary,
      answer: answer,
      placeholder: placeholder,
      guides: guides
    )
  }
}
