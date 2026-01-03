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
  
  case matchAlert = "match_dialog" // 로그는 안드로이드 네이밍 기준으로 "{$}_dialog"
  case matchContact = "match_contact"
  case storeMain = "store_main"
}

public enum PCAmplitudeButtonName {
  case avoidanceAllow
  case photoView
  case userDescription
  case checkRelationShip
  case profileRegisterNext
  case home
  
  /// 매칭 메인, 매칭 상세
  case newMatchingFree
  case newMatchingPurchase
  case insufficientPuzzlePurchase
  
  case matchMatched
  case matchAuto
  case matchBasic

  case checkPictureMatchingPurchase
  case acceptMatching
  case acceptMatchingPurchase
  
  case refuseMatching
  case profileImage
  
  case contactMatchingPurchase
  case image
  case promotionProduct
  case normalProduct(name: String, price: String)
  
  var buttonName: String {
    switch self {
    case .avoidanceAllow: return "avoidance_allow"
    case .photoView: return "photo_view"
    case .userDescription: return "userDescription"
    case .checkRelationShip: return "checkRelationShip"
    case .profileRegisterNext: return "profile_register_next"
    case .home: return "home"
    case .newMatchingFree: return "new_matching_free"
    case .newMatchingPurchase: return "new_matching_purchase"
    case .insufficientPuzzlePurchase: return "insufficient_puzzle_purchase"
    case .matchMatched: return "match_matched"
    case .matchAuto: return "match_auto"
    case .matchBasic: return "match_basic"
    case .checkPictureMatchingPurchase: return "check_picture_matching_purchase"
    case .acceptMatching: return "accept_matching"
    case .acceptMatchingPurchase: return "accept_matching_purchase"
    case .refuseMatching: return "refuse_matching"
    case .profileImage: return "profile_image"
    case .contactMatchingPurchase: return "contact_matching_purchase"
    case .image: return "image"
    case .promotionProduct: return "store_main_banner"
    case .normalProduct(let name, let price): return "store_main_banner_\(name)_\(price)"
    }
  }
}
