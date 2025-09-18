//
//  NotificationViewFactory.swift
//  NotificationList
//
//  Created by summercat on 3/19/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct NotificationViewFactory {
  @ViewBuilder
  public static func createNotificationListView(
    getNotificationsUseCase: GetNotificationsUseCase,
    readNotificationUseCase: ReadNotificationUseCase
  ) -> some View {
    NotificationListView(
      getNotificationsUseCase: getNotificationsUseCase,
      readNotificationUseCase: readNotificationUseCase
    )
    .trackScreen(trackable: DefaultProgress.notification)
  }
}
