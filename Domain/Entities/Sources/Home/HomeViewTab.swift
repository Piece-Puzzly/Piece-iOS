//
//  HomeViewTab.swift
//  Home
//
//  Created by 홍승완 on 9/30/25.
//

import Foundation

public enum HomeViewTab: String {
  /// ProfileView
  case profile
  
  /// MatchingHomeView
  case home
  
  /// SettingsView
  case settings
  
  public init?(rawValue: String) {
    switch rawValue {
      case "profile":
      self = .profile
    case "home":
      self = .home
    case "settings":
      self = .settings
    default:
      self = .home
    }
  }
}

