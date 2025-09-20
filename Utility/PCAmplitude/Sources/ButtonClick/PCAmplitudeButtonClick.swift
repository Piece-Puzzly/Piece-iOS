//
//  PCAmplitudeButtonClick.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/20/25.
//

import Foundation

public enum PCAmplitudeButtonClickScreen: String {
  case avoidanceIntro = "avoidance_intro"
  
  case registerBasicProfile = "register_basic_profile"
  case registerValuePick = "register_value_pick"
  case registerValueTalk = "register_value_talk"
  case registerProfileComplete = "register_profile_complete"
  
  case matchMainHome = "match_main_home"
  
  case matchDetailBasicInfo = "match_detail_basic_info"
  case matchDetailValuePick = "match_detail_value_pick"
  case matchDetailValueTalk = "match_detail_value_talk"
}

public enum PCAmplitudeButtonName: String {
  case avoidanceAllow = "avoidance_allow"
  case photoView = "photo_view"
  case userDescription = "userDescription"
  case checkRelationShip = "checkRelationShip"
  case profileRegisterNext = "profile_register_next"
  case home = "home"
}
