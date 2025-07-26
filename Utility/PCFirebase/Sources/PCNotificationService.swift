//
//  PCNotificationService.swift
//  PCFirebase
//
//  Created by summercat on 2/22/25.
//

import FirebaseMessaging
import PCNetwork
import Repository
import UIKit
import UseCases

public final class PCNotificationService: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
  public static let shared = PCNotificationService()
  
  public func requestPushPermission() {
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
      print("🔔 알림 권한 요청 결과: granted=\(granted)")
      if granted {
        print("🔔 사용자가 알림 권한을 허용했습니다")
        
        // 메인 스레드에서 APNs 등록 실행
        DispatchQueue.main.async {
          print("🍎 APNs 원격 알림 등록 요청...")
          
          // 현재 등록 상태 확인
          let isRegistered = UIApplication.shared.isRegisteredForRemoteNotifications
          print("🍎 현재 원격 알림 등록 상태: \(isRegistered)")
          
          // 앱 상태 확인
          let appState = UIApplication.shared.applicationState
          print("🍎 현재 앱 상태: \(appState.rawValue) (0=active, 1=inactive, 2=background)")
          
          // APNs 등록 요청 실행
          UIApplication.shared.registerForRemoteNotifications()
          print("🍎 registerForRemoteNotifications() 호출 완료")
          
          // 1초 후 등록 상태 다시 확인
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let newState = UIApplication.shared.isRegisteredForRemoteNotifications
            print("🍎 등록 요청 1초 후 상태: \(newState)")
            if !newState {
              print("🍎 ⚠️ 1초 후에도 등록되지 않음 - entitlements 또는 인증서 문제 가능성")
            }
          }
        }
      } else if let error = error {
        print("🔔 알림 권한 요청 에러: \(error)")
      } else {
        print("🔔 사용자가 알림 권한을 거부했습니다")
      }
    }
  }
  
  // 현재 알림 권한 상태 확인
  public func checkNotificationPermission() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      print("🔔 현재 알림 설정:")
      print("  - Authorization Status: \(settings.authorizationStatus.rawValue)")
      print("  - Alert Setting: \(settings.alertSetting.rawValue)")
      print("  - Badge Setting: \(settings.badgeSetting.rawValue)")
      print("  - Sound Setting: \(settings.soundSetting.rawValue)")
      print("  - Critical Alert Setting: \(settings.criticalAlertSetting.rawValue)")
      print("  - Announcement Setting: \(settings.announcementSetting.rawValue)")
      
      switch settings.authorizationStatus {
      case .authorized:
        print("🔔 알림이 완전히 허용됨")
      case .denied:
        print("🔔 알림이 거부됨")
      case .notDetermined:
        print("🔔 알림 권한이 아직 결정되지 않음")
      case .provisional:
        print("🔔 임시 알림 권한")
      case .ephemeral:
        print("🔔 임시 앱 알림 권한")
      @unknown default:
        print("🔔 알 수 없는 알림 상태")
      }
    }
  }
  
  // FCM 토큰 강제 갱신
  public func refreshFCMToken() {
    Messaging.messaging().deleteToken { error in
      if let error = error {
        print("🔥 FCM 토큰 삭제 에러: \(error)")
      } else {
        print("🔥 FCM 토큰 삭제 성공, 새 토큰 요청 중...")
        Messaging.messaging().token { token, error in
          if let error = error {
            print("🔥 FCM 토큰 재발급 에러: \(error)")
          } else if let token = token {
            print("🔥 새로운 FCM 토큰: \(token)")
          }
        }
      }
    }
  }
  
  public func setApnsToken(_ token: Data) {
    let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
    print("🍎 APNs 토큰 설정: \(tokenString)")
    Messaging.messaging().apnsToken = token
    
    // APNs 토큰 설정 후 FCM 토큰 요청
    Messaging.messaging().token { token, error in
      if let error = error {
        print("🔥 FCM 토큰 요청 에러: \(error)")
      } else if let token = token {
        print("🔥 APNs 토큰 설정 후 FCM 토큰: \(token)")
      }
    }
  }
  
  // MARK: - UserNotificationCenterDelegate
  
  // Foreground 상태에서 푸시 알림을 받았을 때 호출되는 메소드
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo
    
    print("🔔 Foreground에서 알림 수신:")
    print("  - Title: \(notification.request.content.title)")
    print("  - Body: \(notification.request.content.body)")
    print("  - UserInfo: \(userInfo)")
    
    // TODO: - 필요 시 딥링크 처리 로직 추가
    return [.banner, .list, .sound]
  }
  
  // Background 상태에서 푸시 알림을 받았을 때 호출되는 메소드
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    let userInfo = response.notification.request.content.userInfo
    print("🔔 Background에서 알림 응답:")
    print("  - Action Identifier: \(response.actionIdentifier)")
    print("  - UserInfo: \(userInfo)")
  }
  
  // MARK: - MessagingDelegate
  
  public func setDelegate() {
    Messaging.messaging().delegate = self
    print("🔥 Firebase Messaging delegate 설정 완료")
  }
  
  public func enableAutoInit() {
    Messaging.messaging().isAutoInitEnabled = true
    print("🔥 Firebase Messaging 자동 초기화 활성화")
  }
  
  public func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    if let fcmToken {
      print("🔥 Firebase FCM 토큰 수신: \(fcmToken)")
      print("🔥 토큰 길이: \(fcmToken.count) 문자")
      
      let dataDict: [String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      
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
    } else {
      print("🔥 FCM 토큰이 nil입니다")
    }
  }
}
