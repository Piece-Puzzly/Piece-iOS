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
      if granted {
        print("User granted Notification Permissions")
      } else if let error = error {
        print("에러: \(error)")
      }
    }
    
    DispatchQueue.main.async {
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
  
  public func setApnsToken(_ token: Data) {
    Messaging.messaging().apnsToken = token
  }
  
  // MARK: - UserNotificationCenterDelegate
  
  // Foreground 상태에서 푸시 알림을 받았을 때 호출되는 메소드
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo
    
    // TODO: - 필요 시 딥링크 처리 로직 추가
    print(userInfo)
    return [.banner, .list, .sound]
  }
  
  // Background 상태에서 푸시 알림을 받았을 때 호출되는 메소드
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    let userInfo = response.notification.request.content.userInfo
    print(userInfo)
  }
  
  // MARK: - MessagingDelegate
  
  public func setDelegate() {
    Messaging.messaging().delegate = self
  }
  
  public func enableAutoInit() {
    Messaging.messaging().isAutoInitEnabled = true
  }
  
  public func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    if let fcmToken {
      print("Firebase registration token: \(String(describing: fcmToken))")
      let dataDict: [String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      
      // TODO: - 서버에 FCM 토큰을 전송하는 로직
      // Note: This callback is fired at each app startup and whenever a new token is generated.
      let repositoryFactory = RepositoryFactory(
        networkService: NetworkService.shared,
        sseService: SSEService.shared
      )
      let loginRepository = repositoryFactory.createLoginRepository()
      let registerFcmTokenUseCase = UseCaseFactory.createRegisterFcmTokenUseCase(repository: loginRepository)
      Task {
        do {
          _ = try await registerFcmTokenUseCase.execute(token: fcmToken)
        } catch {
          print(error)
        }
      }
    }

  }
}
