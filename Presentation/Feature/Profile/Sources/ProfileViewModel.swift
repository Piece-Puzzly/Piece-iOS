//
// ProfileViewModel.swift
// Profile
//
// Created by summercat on 2025/01/30.
//

import Foundation
import PCFoundationExtension
import UseCases

@Observable
@MainActor
final class ProfileViewModel {
  enum Action {
    case onAppear
  }
  
  init(
    getProfileUseCase: GetProfileBasicUseCase,
    getNotificationsUseCase: GetNotificationsUseCase
  ) {
    self.getProfileUseCase = getProfileUseCase
    self.getNotificationsUseCase = getNotificationsUseCase
  }
  
  private let getProfileUseCase: GetProfileBasicUseCase
  private let getNotificationsUseCase: GetNotificationsUseCase
  private(set) var isLoading = true
  private(set) var error: Error?
  private(set) var userProfile: UserProfile?
  private(set) var hasUnreadNotifications: Bool = false
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      isLoading = true
      Task {
        await withTaskGroup(of: Void.self) { group in
          group.addTask { await self.fetchUserProfile() }
          group.addTask { await self.checkUnreadNotifications() }
        }
      }
    }
  }
  
  private func fetchUserProfile() async {
    do {
      let entity = try await getProfileUseCase.execute()
      let userProfile = UserProfile(
        nickname: entity.nickname,
        description: entity.description,
        age: entity.age ?? -1,
        birthYear: entity.birthdate.extractYear(),
        height: entity.height,
        weight: entity.weight,
        job: entity.job,
        location: entity.location,
        smokingStatus: entity.smokingStatus,
        imageUri: entity.imageUri
      )
      updateUserProfile(userProfile)
      error = nil
    } catch {
      self.error = error
    }
    isLoading = false
  }
  
  private func updateUserProfile(_ profile: UserProfile) {
    userProfile = profile
  }

  private func checkUnreadNotifications() async {
    do {
      var hasUnread = hasUnreadNotifications
      var isEnd = false

      while !hasUnread && !isEnd {
        let result = try await getNotificationsUseCase.execute()
        hasUnread = hasUnread || result.notifications.contains { !$0.isRead }
        isEnd = result.isEnd
      }

      hasUnreadNotifications = hasUnread
    } catch {
      print("Get Notifications: \(error.localizedDescription)")
    }
  }
}
