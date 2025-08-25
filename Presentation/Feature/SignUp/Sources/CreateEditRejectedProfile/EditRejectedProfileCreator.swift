//
//  EditRejectedProfileCreator.swift
//  SignUp
//
//  Created by 홍승완 on 8/24/25.
//

import Entities

final class EditRejectedProfileCreator {
  private(set) var basicInfo: ProfileBasicModel = ProfileBasicModel.empty
  private(set) var valueTalks: [ValueTalkModel] = []
  private(set) var valuePicks: [ValuePickModel] = []
  private var isBasicInfoValid: Bool = false
  private var isValuePicksValid: Bool = false
  private var isValueTalksValid: Bool = false
  
  func updateBasicInfo(_ profile: ProfileBasicModel) {
    print(profile)
    self.basicInfo = profile
  }
  
  func isBasicInfoValid(_ isValid: Bool) {
    isBasicInfoValid = isValid
  }
  
  func updateValuePicks(_ valuePicks: [ValuePickModel]) {
    print(valuePicks)
    self.valuePicks = valuePicks
  }
  
  func isValuePicksValid(_ isValid: Bool) {
    isValuePicksValid = isValid
  }
  
  func updateValueTalks(_ valueTalks: [ValueTalkModel]) {
    self.valueTalks = valueTalks
    print(valueTalks)
  }
  
  func isValueTalksValid(_ isValid: Bool) {
    isValueTalksValid = isValid
  }
  
  func isProfileValid() -> Bool {
    isBasicInfoValid && isValuePicksValid && isValueTalksValid
  }
  
  func createEditRejectedProfile() -> ProfileModel {
    return ProfileModel(
      nickname: basicInfo.nickname,
      description: basicInfo.description,
      birthdate: basicInfo.birthdate,
      height: basicInfo.height,
      weight: basicInfo.weight,
      job: basicInfo.job,
      location: basicInfo.location,
      smokingStatus: basicInfo.smokingStatus,
      snsActivityLevel: basicInfo.snsActivityLevel,
      imageUri: basicInfo.imageUri,
      contacts: basicInfo.contacts,
      valueTalks: valueTalks,
      valuePicks: valuePicks
    )
  }
}

