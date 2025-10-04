//
//  Notification.Name+.swift
//  PCFoundationExtension
//
//  Created by 홍승완 on 8/20/25.
//

import Foundation

// MARK: - Push Notifications
public extension Notification.Name {
  static let deepLink = Notification.Name("DeepLink")
  static let switchHomeTab = Notification.Name("SwitchHomeTab")
  static let fcmToken = Notification.Name("FCMToken")
}
