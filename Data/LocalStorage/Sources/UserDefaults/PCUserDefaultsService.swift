//
//  PCUserDefaultsService.swift
//  LocalStorage
//
//  Created by summercat on 2/13/25.
//

import Entities
import Foundation

public final class PCUserDefaultsService {
  public static let shared = PCUserDefaultsService()
  
  private init() { }
  
  var didSeeOnboarding: Bool {
    get {
      PCUserDefaults.objectFor(key: .didSeeOnboarding) as? Bool ?? true
    }
    set {
      _ = PCUserDefaults.setObjectFor(key: .didSeeOnboarding, object: newValue)
    }
  }
  
  // 처음 앱을 실행하는지
  var isFirstLaunch: Bool {
    get {
      PCUserDefaults.objectFor(key: .isFirstLaunch) as? Bool ?? true
    }
    set {
      _ = PCUserDefaults.setObjectFor(key: .isFirstLaunch, object: newValue)
    }
  }
  
  var socialLoginType: String {
    get {
      PCUserDefaults.objectFor(key: .socialLoginType) as? String ?? ""
    }
    set {
      _ = PCUserDefaults.setObjectFor(key: .socialLoginType, object: newValue)
    }
  }
  
  var userRole: UserRole {
    get {
      if let value = PCUserDefaults.objectFor(key: .userRole) as? String {
        return UserRole(value)
      } else {
        return .NONE
      }
    }
    set {
      _ = PCUserDefaults.setObjectFor(key: .userRole, object: newValue.rawValue)
    }
  }
  
  var matchedUserId: Int? {
    get {
      PCUserDefaults.objectFor(key: .matchedUserId) as? Int
    }
    set {
      _ = PCUserDefaults.setObjectFor(key: .matchedUserId, object: newValue)
    }
  }
  
  var matchStatus: MatchStatus? {
    get {
      if let value = PCUserDefaults.objectFor(key: .matchStatus) as? String {
        return MatchStatus(value)
      }
      return nil
    }
    set {
      _ = PCUserDefaults.setObjectFor(key: .matchStatus, object: newValue?.rawValue)
    }
  }
  
  var latestSyncDate: Date? {
    get {
      PCUserDefaults.objectFor(key: .latestSyncDate) as? Date
    }
    set {
      _ = PCUserDefaults.setObjectFor(key: .latestSyncDate, object: newValue)
    }
  }
}

public extension PCUserDefaultsService {
  // 로그아웃 시 UserDefaults 초기화 메서드
  func initialize() {
    didSeeOnboarding = false
    socialLoginType = ""
    userRole = .NONE
  }
  
  func getDidSeeOnboarding() -> Bool {
    didSeeOnboarding
  }
  
  func setDidSeeOnboarding(_ didSeeOnboarding: Bool) {
    self.didSeeOnboarding = didSeeOnboarding
  }
  
  func setSocialLoginType(_ type: SocialLoginType) {
    self.socialLoginType = type.rawValue
  }
  
  func getSocialLoginType() -> SocialLoginType? {
    switch socialLoginType {
    case "apple":
      return .apple
    case "kakao":
      return .kakao
    case "google":
      return .google
    default:
      return nil
    }
  }
  
  /// 첫 실행 여부 확인
  func checkFirstLaunch() -> Bool {
    if isFirstLaunch {
      isFirstLaunch = false
      return true
    }
    return false
  }
  
  // 강제로 첫 실행 플래그를 리셋 (테스트용)
  func resetFirstLaunch() {
    isFirstLaunch = true
    didSeeOnboarding = false
    matchedUserId = nil
    matchStatus = nil
  }
  
  func getUserRole() -> UserRole {
    userRole
  }
  
  func setUserRole(_ userRole: UserRole) {
    self.userRole = userRole
  }
  
  func getMatchedUserId() -> Int? {
    matchedUserId
  }
  
  func setMatchedUserId(_ id: Int) {
    matchedUserId = id
  }
  
  func getMatchStatus() -> MatchStatus? {
    matchStatus
  }
  
  func setMatchStatus(_ status: MatchStatus) {
    matchStatus = status
  }
  
  
  // MARK: - 연락처 동기화 관련 get/set
  func getLatestSyncDate() -> Date? {
    latestSyncDate
  }
  
  func setLatestSyncDate(_ date: Date) {
    latestSyncDate = date
  }
}
