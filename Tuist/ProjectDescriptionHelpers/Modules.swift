//
//  Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 12/18/24.
//

import ProjectDescription

public enum Modules {
  case data
  case domain
  case utility
  case presentation
}

// MARK: - Data

public extension Modules {
  enum Data: String {
    case LocalStorage // 임시
    case PCNetwork
    case DTO
    case Repository
    
    var path: String {
      "Data/\(self.rawValue)"
    }
    
    var targetName: String {
      "\(self.rawValue)"
    }
  }
}

// MARK: - Domain

public extension Modules {
  enum Domain: String {
    case Entities
    case UseCases
    case RepositoryInterfaces
    
    var path: String {
      switch self {
      default: "Domain/\(self.rawValue)"
      }
    }
    
    var targetName: String {
      "\(self.rawValue)"
    }
  }
}

// MARK: - Utility

public extension Modules {
  enum Utility: String {
    case PCFoundationExtension
    case PCFirebase
    case PCAmplitude
    case PCNetworkMonitor
    
    var path: String {
      "Utility/\(self.rawValue)"
    }
    
    var targetName: String {
      "\(self.rawValue)"
    }
  }
}

// MARK: - Presentation

public extension Modules {
  enum Presentation: String {
    // 공통
    case DesignSystem
    case Router
    case Coordinator
    case Onboarding
    case PCWebView
    
    // 피처
    case Splash
    case Login
    case SignUp
    case Home
    case Profile
    case Settings
    case MatchingMain
    case MatchingDetail
    case MatchResult
    case EditValueTalk
    case EditValuePick
    case Withdraw
    case BlockUser
    case ReportUser
    case PreviewProfile
    case NotificationList
    case EditProfile
    case PCImagePicker
    
    var path: String {
      switch self {
      case .DesignSystem, .Router, .Coordinator: "Presentation/\(self.rawValue)"
      default: "Presentation/Feature/\(self.rawValue)"
      }
    }
    
    var targetName: String {
      "\(self.rawValue)"
    }
  }
}
