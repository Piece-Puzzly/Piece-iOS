//
//  ProfileCreator.swift
//  SignUp
//
//  Created by summercat on 2/10/25.
//

import Entities
import PCAmplitude

final class ProfileCreator {
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
    
    PCAmplitude.trackButtonClick(
      screenName: .registerBasicProfile,
      buttonName: .profileRegisterNext,
      properties: [.result: isValid]
    )
  }
  
  func updateValuePicks(_ valuePicks: [ValuePickModel]) {
    print(valuePicks)
    self.valuePicks = valuePicks
  }
  
  func isValuePicksValid(_ isValid: Bool) {
    isValuePicksValid = isValid
    
    PCAmplitude.trackButtonClick(
      screenName: .registerValuePick,
      buttonName: .profileRegisterNext,
      properties: [.result: isValid]
    )
  }
  
  func updateValueTalks(_ valueTalks: [ValueTalkModel]) {
    self.valueTalks = valueTalks
    print(valueTalks)
  }
  
  func isValueTalksValid(_ isValid: Bool) {
    isValueTalksValid = isValid
    
    PCAmplitude.trackButtonClick(
      screenName: .registerValueTalk,
      buttonName: .profileRegisterNext,
      properties: [.result: isValid]
    )
  }
  
  func isProfileValid() -> Bool {
    isBasicInfoValid && isValuePicksValid && isValueTalksValid
  }
  
  func createProfile() -> ProfileModel {
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
