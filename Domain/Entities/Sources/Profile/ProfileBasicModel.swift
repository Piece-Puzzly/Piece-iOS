//
//  ProfileBasicModel.swift
//  Entities
//
//  Created by summercat on 2/25/25.
//

public struct ProfileBasicModel {
  public let nickname: String
  public let description: String
  public let age: Int?
  public let birthdate: String
  public let height: Int
  public let weight: Int
  public let job: String
  public let location: String
  public let smokingStatus: String
  public let snsActivityLevel: String
  public let imageUri: String
  public let pendingImageUrl: String?
  public let contacts: [ContactModel]
  
  public init(
    nickname: String,
    description: String,
    age: Int? = nil,
    birthdate: String,
    height: Int,
    weight: Int,
    job: String,
    location: String,
    smokingStatus: String,
    snsActivityLevel: String,
    imageUri: String,
    pendingImageUrl: String?,
    contacts: [ContactModel]
  ) {
    self.nickname = nickname
    self.description = description
    self.age = age
    self.birthdate = birthdate
    self.height = height
    self.weight = weight
    self.job = job
    self.location = location
    self.smokingStatus = smokingStatus
    self.snsActivityLevel = snsActivityLevel
    self.imageUri = imageUri
    self.pendingImageUrl = pendingImageUrl
    self.contacts = contacts
  }
}

public extension ProfileBasicModel {
  static let empty = ProfileBasicModel(
    nickname: "",
    description: "",
    birthdate: "",
    height: 0,
    weight: 0,
    job: "",
    location: "",
    smokingStatus: "",
    snsActivityLevel: "",
    imageUri: "",
    pendingImageUrl: nil,
    contacts: []
  )
}
