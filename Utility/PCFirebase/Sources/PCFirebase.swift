//
//  PCFirebase.swift
//  PCFirebase
//
//  Created by summercat on 2/16/25.
//

import FirebaseCore
import FirebaseCrashlytics
import FirebaseRemoteConfig

public final class PCFirebase {
  public static let shared = PCFirebase()
  
  private var remoteConfig: RemoteConfig?
  
  private init() { }
  
  public func configureFirebaseApp() throws {
    guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
      let options = FirebaseOptions(contentsOfFile: filePath) else {
      throw PCFirebaseError.invalidConfiguration
    }
    
    if FirebaseApp.app() == nil {
      FirebaseApp.configure(options: options)
      
      setCrashlytics()
    }
  }
  
  private func setCrashlytics() {
    #if DEBUG
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
    NSLog("🔥 Crashlytics disabled in DEBUG mode")
    #else
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
    NSLog("🔥 Crashlytics enabled in RELEASE mode")
    #endif
  }
  
  public func setRemoteConfig() throws {
    guard FirebaseApp.app() != nil else {
      throw PCFirebaseError.firebaseNotInitialized
    }
    
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    #if DEBUG
    settings.minimumFetchInterval = 0
    #else
    settings.minimumFetchInterval = 43_200
    #endif
    
    remoteConfig.configSettings = settings
    
    if let path = Bundle.module.path(forResource: "remote_config_defaults", ofType: "plist"),
       let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
       let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: NSObject] {
      // plist로부터 기본값을 설정
      remoteConfig.setDefaults(plist)
    }
    self.remoteConfig = remoteConfig
  }
  
  public func fetchRemoteConfigValues() async throws {
    guard let remoteConfig = self.remoteConfig else {
      throw PCFirebaseError.remoteConfigNotInitialized
    }
    
    try await remoteConfig.ensureInitialized()
    
    do {
      let status = try await remoteConfig.fetchAndActivate()
      guard status == .successFetchedFromRemote || status == .successUsingPreFetchedData else {
        print("🔥 Remote config fetch error status: \(status)")
        throw PCFirebaseError.fetchFailed
      }
        
      let allKeys = remoteConfig.allKeys(from: .remote)
      for key in allKeys {
        print("🔥 Firebase RemoteConfig key: \(key), value: \(remoteConfig[key].stringValue)")
      }
    } catch {
      print("🔥 Remote config fetch error details: \(error)")
      throw PCFirebaseError.fetchFailed
    }
  }
  
  public func minimumVersion() -> String {
    return string(forKey: .minimumVersion)
  }
  
  public func minimumVersionDebug() -> String {
    return string(forKey: .minimumVersionDebug)
  }
  
  public func needsForceUpdate() -> Bool {
    return bool(forKey: .needsForceUpdate)
  }
}

extension PCFirebase {
  public func logCrashlytics(_ message: String) {
    Crashlytics.crashlytics().log(message)
  }
  
  public func setCrashlyticsUserId(_ userId: String) {
    Crashlytics.crashlytics().setUserID(userId)
  }
  
  public func setCrashlyticsCustomKey(_ key: String, value: Any) {
    Crashlytics.crashlytics().setCustomValue(value, forKey: key)
  }
  
  public func recordCrashlyticsError(_ error: Error) {
    Crashlytics.crashlytics().record(error: error)
  }
  
  public func testCrashlytics() {
    // 커스텀 로그 기록
    logCrashlytics("Test log message")
    
    // 커스텀 키 설정
    setCrashlyticsCustomKey("test_key", value: "test_value")
    
    // 비치명적 오류 기록
    let error = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    recordCrashlyticsError(error)
    
    print("🔥 Crashlytics 테스트 데이터 전송 완료")
  }
}

extension PCFirebase {
  func bool(forKey key: PCRemoteConfigKey) -> Bool {
    guard let remoteConfig else { return false }
    return remoteConfig[key.rawValue].boolValue
  }
  
  func string(forKey key: PCRemoteConfigKey) -> String {
    guard let remoteConfig else { return "" }
    return remoteConfig[key.rawValue].stringValue
  }
  
  func int(forKey key: PCRemoteConfigKey) -> Int {
    guard let remoteConfig else { return -1 }
    return remoteConfig[key.rawValue].numberValue.intValue
  }
  
  func double(forKey key: PCRemoteConfigKey) -> Double {
    guard let remoteConfig else { return -1 }
    return remoteConfig[key.rawValue].numberValue.doubleValue
  }
}
