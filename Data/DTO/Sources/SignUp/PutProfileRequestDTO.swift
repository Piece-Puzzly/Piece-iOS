//
//  PutProfileRequestDTO.swift
//  DTO
//
//  Created by 홍승완 on 8/24/25.
//

import Entities
import Foundation

public struct PutProfileRequestDTO: Encodable {
  public init(
    nickname: String,
    description: String,
    birthdate: String,
    height: Int,
    weight: Int,
    job: String,
    location: String,
    smokingStatus: String,
    snsActivityLevel: String,
    contacts: [String : String],
    imageUrl: String,
    valueTalks: [ValueTalkRequestDTO],
    valuePicks: [ValuePickRequestDTO]
  ) {
    self.nickname = nickname
    self.description = description
    self.birthdate = birthdate
    self.height = height
    self.weight = weight
    self.job = job
    self.location = location
    self.smokingStatus = smokingStatus
    self.snsActivityLevel = snsActivityLevel
    self.contacts = contacts
    self.imageUrl = imageUrl
    self.valueTalks = valueTalks
    self.valuePicks = valuePicks
  }
  
  public let nickname: String
  public let description: String
  public let birthdate: String
  public let height: Int
  public let weight: Int
  public let job: String
  public let location: String
  public let smokingStatus: String
  public let snsActivityLevel: String
  public let contacts: [String: String]
  public let imageUrl: String
  public let valueTalks: [ValueTalkRequestDTO]
  public let valuePicks: [ValuePickRequestDTO]
}

public extension ProfileModel {
  func toDto() -> PutProfileRequestDTO {
    // 연도, 월, 일을 추출
    let year = birthdate.prefix(4)
    let month = birthdate.dropFirst(4).prefix(2)
    let day = birthdate.dropFirst(6).prefix(2)
    
    // yyyy-MM-dd 형식으로 조합
    let formattedBirthDate = "\(year)-\(month)-\(day)"
    
    var contactsDictionary: [String: String] = [:]
    contacts.forEach { model in
      contactsDictionary[model.type.rawValue] = model.value
    }
    
    var valueTalkDtos: [ValueTalkRequestDTO] = []
    valueTalks.forEach { model in
      valueTalkDtos.append(ValueTalkRequestDTO(valueTalkId: model.id, answer: model.answer ?? ""))
    }
    
    var valuePickDtos: [ValuePickRequestDTO] = []
    valuePicks.forEach { model in
      valuePickDtos.append(ValuePickRequestDTO(valuePickId: model.id, selectedAnswer: model.selectedAnswer ?? 0))
    }
    
    return PutProfileRequestDTO(
      nickname: nickname,
      description: description,
      birthdate: formattedBirthDate,
      height: height,
      weight: weight,
      job: job,
      location: location,
      smokingStatus: smokingStatus,
      snsActivityLevel: snsActivityLevel,
      contacts: contactsDictionary,
      imageUrl: imageUri,
      valueTalks: valueTalkDtos,
      valuePicks: valuePickDtos
    )
  }
}
