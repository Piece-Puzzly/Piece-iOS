//
//  AppDelegate.swift
//  Piece-iOS
//
//  Created by summercat on 2/22/25.
//  Copyright © 2025 puzzly. All rights reserved.
//

import PCFirebase
import UIKit
import Network
import PCNetwork
import LocalStorage
import Repository
import UseCases

final class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
  
  private let networkMonitor = NWPathMonitor()
  private let networkQueue = DispatchQueue(label: "NetworkMonitor")
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    
    print("🚀 앱 시작 - didFinishLaunchingWithOptions")
    
    // 네트워크 모니터링 시작
    startNetworkMonitoring()
    
    // FCM 토큰 알림 구독
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleFCMTokenNotification),
      name: .fcmToken,
      object: nil
    )
    
    // Firebase 설정
    do {
      print("🔥 Firebase 설정 시작...")
      try PCFirebase.shared.configureFirebaseApp()
      print("🔥 Firebase 설정 성공")
    } catch let error as PCFirebaseError {
      print("🔥 Firebase 설정 실패: \(error.errorDescription ?? "Unknown error")")
    } catch {
      print("🔥 Firebase 설정 실패 (알 수 없는 에러): \(error)")
    }
    
    // Firebase RemoteConfig 설정
    do {
      print("🔥 Firebase RemoteConfig 설정 시작...")
      try PCFirebase.shared.setRemoteConfig()
      print("🔥 Firebase RemoteConfig 설정 성공")
    } catch let error as PCFirebaseError {
      print("🔥 RemoteConfig 설정 실패: \(error.errorDescription ?? "Unknown error")")
    } catch {
      print("🔥 RemoteConfig 설정 실패 (알 수 없는 에러): \(error)")
    }
    
    // MARK: - Firebase Cloud Messaging (푸시알림) 설정
    print("🔔 푸시 알림 설정 시작...")
    
    // Firebase Messaging delegate 설정 (APNs 등록 전에 설정)
    PCNotificationService.shared.setDelegate()
    PCNotificationService.shared.enableAutoInit()
    
    // 알림 권한 요청
    PCNotificationService.shared.requestPushPermission()
    
    // 현재 알림 권한 상태 확인 (비동기)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      PCNotificationService.shared.checkNotificationPermission()
      self.checkAPNsRegistrationStatus()
    }
    
    print("🚀 앱 초기화 완료")
    return true
  }
  
  // APNs 등록 상태 확인
  private func checkAPNsRegistrationStatus() {
    print("🍎 APNs 등록 상태 확인 중...")
    
    if UIApplication.shared.isRegisteredForRemoteNotifications {
      print("🍎 앱이 원격 알림에 등록되어 있음")
    } else {
      print("🍎 앱이 원격 알림에 등록되어 있지 않음")
      print("🍎 APNs 재등록 시도...")
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
  
  // 네트워크 모니터링
  private func startNetworkMonitoring() {
    networkMonitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        print("🌐 네트워크 연결됨: \(path.availableInterfaces)")
      } else {
        print("🌐 네트워크 연결 안됨")
      }
    }
    networkMonitor.start(queue: networkQueue)
  }
  
  @objc private func handleFCMTokenNotification(_ notification: Notification) {
    guard let fcmToken = notification.userInfo?["token"] as? String else { return }
    
    // KeyChain에 FCMToken 저장
    PCKeychainManager.shared.save(.fcmToken, value: fcmToken)
    
    // Access Token이 있는지 확인
    guard let accessToken = PCKeychainManager.shared.read(.accessToken), !accessToken.isEmpty else {
      print("🔥 Access Token이 없어서 FCM 토큰 전송을 건너뜁니다")
      return
    }
    
    // 서버에 FCM 토큰을 전송하는 로직
    print("🔥 서버에 FCM 토큰 전송 시작...")
    let repositoryFactory = RepositoryFactory(
      networkService: NetworkService.shared,
      sseService: SSEService.shared
    )
    let loginRepository = repositoryFactory.createLoginRepository()
    let registerFcmTokenUseCase = UseCaseFactory.createRegisterFcmTokenUseCase(repository: loginRepository)
    Task {
      do {
        _ = try await registerFcmTokenUseCase.execute(token: fcmToken)
        print("🔥 서버에 FCM 토큰 전송 성공")
      } catch {
        print("🔥 서버에 FCM 토큰 전송 실패: \(error)")
      }
    }
  }
  
  // 앱이 종료된 상태에서 푸시 알림을 받았을 때 호출되는 메소드
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any]
  ) async -> UIBackgroundFetchResult {
    print("🔔 백그라운드에서 원격 알림 수신: \(userInfo)")
    return .newData
  }
  
  // APNs 등록 성공 시 호출
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("🍎 APNs 등록 성공!")
    print("🍎 APNs Device Token: \(tokenString)")
    print("🍎 토큰 길이: \(deviceToken.count) bytes")
    
    // Firebase에 APNs 토큰 전달
    PCNotificationService.shared.setApnsToken(deviceToken)
  }
  
  // APNs 등록 실패 시 호출
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
    print("🍎 ============ APNs 등록 실패 ============")
    print("🍎 에러: \(error.localizedDescription)")
    print("🍎 에러 코드: \((error as NSError).code)")
    print("🍎 에러 도메인: \((error as NSError).domain)")
    print("🍎 에러 상세: \(error)")
    
    // 일반적인 에러 원인 분석
    let nsError = error as NSError
    switch nsError.code {
    case 3000...3999:
      print("🍎 네트워크 관련 에러 - WiFi/셀룰러 연결을 확인하세요")
    case 3010:
      print("🍎 APNs 서버 연결 실패 - 방화벽이나 네트워크 제한을 확인하세요")
    default:
      print("🍎 알 수 없는 에러 코드")
    }
    
    // 시뮬레이터에서 실행 중인지 확인
    #if targetEnvironment(simulator)
    print("🍎 시뮬레이터에서는 푸시 알림을 받을 수 없습니다. 실기기에서 테스트해주세요.")
    #else
    print("🍎 실기기에서 실행 중 - APNs 서버 연결 또는 인증서 문제일 가능성")
    #endif
    
    // 5초 후 재시도
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      print("🍎 APNs 등록 재시도...")
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
}
