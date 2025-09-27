//
//  AmplitudeEvent.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/13/25.
//

import Foundation

public enum AmplitudeEventType: String {
  case screenView = "screen_view"
  case buttonClick = "button_click"
  case action = "action"
}

public enum AmplitudeParameterKey: String {
  case screenName = "screen_name"
  case buttonName = "button_name"
  case actionName = "action_name"
  case duration = "duration"
  case result = "result"
  case entryRoute = "entry_route"
}
