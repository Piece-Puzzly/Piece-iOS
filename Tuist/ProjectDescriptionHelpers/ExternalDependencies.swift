//
//  ExternalDependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 2/8/25.
//

import ProjectDescription

public enum ExternalDependencies {
  case Alamofire
  case KakaoSDKCommon
  case KakaoSDKAuth
  case KakaoSDKUser
  case GoogleSignIn
  case GoogleSignInSwift
  case Lottie
  case FirebaseRemoteConfig
  case FirebaseCore
  case FirebaseAnalytics
  case FirebaseMessaging
  case Mantis
  case AmplitudeSwift
  
  public var name: String {
    switch self {
    case .Alamofire: "Alamofire"
    case .GoogleSignIn: "GoogleSignIn"
    case .GoogleSignInSwift: "GoogleSignInSwift"
    case .KakaoSDKCommon: "KakaoSDKCommon"
    case .KakaoSDKAuth: "KakaoSDKAuth"
    case .KakaoSDKUser: "KakaoSDKUser"
    case .Lottie: "Lottie"
    case .FirebaseRemoteConfig: "FirebaseRemoteConfig"
    case .FirebaseCore: "FirebaseCore"
    case .FirebaseAnalytics: "FirebaseAnalytics"
    case .FirebaseMessaging: "FirebaseMessaging"
    case .Mantis: "Mantis"
    case .AmplitudeSwift: "AmplitudeSwift"
    }
  }
}
