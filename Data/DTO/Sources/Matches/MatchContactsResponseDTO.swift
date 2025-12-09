//
//  MatchContactsResponseDTO.swift
//  DTO
//
//  Created by summercat on 2/20/25.
//

import Entities
import Foundation

public struct MatchContactsResponseDTO: Decodable {
  public let nickname: String
  public let imageUrl: String
  public let contacts: [ContactResponseDTO]
}

public extension MatchContactsResponseDTO {
  func toDomain() -> MatchContactsModel {
    MatchContactsModel(
      nickname: nickname,
      imageUrl: imageUrl,
      contacts: contacts.map { $0.toDomain() },
    )
  }
}
  
public struct ContactResponseDTO: Decodable {
  public let type: ContactTypeResponseDTO
  public let value: String
}

public extension ContactResponseDTO {
  func toDomain() -> ContactModel {
    ContactModel(
      type: type.toDomain(),
      value: value
    )
  }
}


public enum ContactTypeResponseDTO: Decodable {
  case kakao
  case openKakao
  case instagram
  case phone
  case unknown(type: String)
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let type = try container.decode(String.self)
    
    switch type {
    case "KAKAO_TALK_ID": self = .kakao
    case "OPEN_CHAT_URL": self = .openKakao
    case "INSTAGRAM_ID": self = .instagram
    case "PHONE_NUMBER": self = .phone
    default: self = .unknown(type: type ?? "unknown")
    }
  }
}

public extension ContactTypeResponseDTO {
  func toDomain() -> ContactModel.ContactType {
    switch self {
    case .kakao: return .kakao
    case .openKakao: return .openKakao
    case .instagram: return .instagram
    case .phone: return .phone
    case .unknown: return .unknown
    }
  }
}
