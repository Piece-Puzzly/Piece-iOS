//
// NotificationListViewModel.swift
// NotificationList
//
// Created by summercat on 2025/02/26.
//

import Foundation
import UseCases

@MainActor
@Observable
final class NotificationListViewModel {
  enum Action {
    case loadNotifications
    case didTapBackButton
    case didTapNotificationItem(NotificationItemModel)
  }
  
  private(set) var notifications: [NotificationItemModel] = []
  @ObservationIgnored private(set) var isEnd = false
  private(set) var error: Error?
  var showSpinner: Bool = false
  var shouldDismiss: Bool = false
  
  private let getNotificationsUseCase: GetNotificationsUseCase
  private let readNotificationUseCase: ReadNotificationUseCase
  
  init(
    getNotificationsUseCase: GetNotificationsUseCase,
    readNotificationUseCase: ReadNotificationUseCase
  ) {
    self.getNotificationsUseCase = getNotificationsUseCase
    self.readNotificationUseCase = readNotificationUseCase
    
    Task {
      showSpinner = true
      await loadNotifications()
      showSpinner = false
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .loadNotifications:
      Task {
        showSpinner = true
        await loadNotifications()
        showSpinner = false
      }
      
    case .didTapBackButton:
      Task {
        showSpinner = true
        await readNotifications()
        showSpinner = false
        
        shouldDismiss = true
      }
      
    case .didTapNotificationItem(let item):
      Task {
        showSpinner = true
        await readNotifications(for: item)
        showSpinner = false
      }
    }
  }
  
  private func loadNotifications() async {
    if isEnd { return }
    do {
      let result = try await getNotificationsUseCase.execute()
      notifications.append(
        contentsOf: result.notifications.map {
          NotificationItemModel(
            id: $0.id,
            type: $0.type,
            title: $0.title,
            body: $0.body,
            dateTime: $0.dateTime,
            isRead: $0.isRead
          )
        })
      isEnd = result.isEnd
    } catch {
      self.error = error
    }
  }
  
  private func readNotifications() async {
    let unreadNotifications = notifications.filter { !$0.isRead }
    for notification in unreadNotifications {
      do {
        _ = try await readNotificationUseCase.execute(id: notification.id)
      } catch {
        self.error = error
      }
    }
  }
  
  private func readNotifications(for item: NotificationItemModel) async {
    guard !item.isRead else { return }
    
    do {
      _ = try await readNotificationUseCase.execute(id: item.id)
      
      if let index = notifications.firstIndex(where: { $0.id == item.id }) {
        notifications[index] = NotificationItemModel(
          id: notifications[index].id,
          type: notifications[index].type,
          title: notifications[index].title,
          body: notifications[index].body,
          dateTime: notifications[index].dateTime,
          isRead: true
        )
      }
    } catch {
      self.error = error
    }
  }
}
