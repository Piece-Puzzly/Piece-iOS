//
//  PCAmplitudeAction.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/18/25.
//

import Foundation

public enum PCAmplitudeAction {
  case valueTalkDuration
  case matchDetailBasicProfileDuration
  
  var screenName: String {
    switch self {
    case .valueTalkDuration:
      return "value_talk_input"
      
    case .matchDetailBasicProfileDuration:
      return "match_detail_basic_profile"
    }
  }
  
  var actionName: String {
    switch self {
    case .valueTalkDuration: 
      return "value_talk_duration"
      
    case .matchDetailBasicProfileDuration:
      return "match_detail_basic_profile_duration"
    }
  }
}
