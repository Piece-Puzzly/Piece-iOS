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
  
  init(getProfileUseCase: GetProfileBasicUseCase) {
    self.getProfileUseCase = getProfileUseCase
  }
  
  private let getProfileUseCase: GetProfileBasicUseCase
  private(set) var isLoading = true
  private(set) var error: Error?
  private(set) var userProfile: UserProfile?
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      isLoading = true
      Task { await fetchUserProfile() }
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
}
