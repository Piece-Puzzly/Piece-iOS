//
//  EditRejectedWaitingAISummaryViewModel.swift
//  SignUp
//
//  Created by 홍승완 on 8/24/25.
//

import Entities
import Observation
import UseCases

@MainActor
@Observable
final class EditRejectedWaitingAISummaryViewModel {
  enum Action {
    case onAppear
  }
  
  init(
    profile: ProfileModel,
    putProfileUseCase: PutProfileUseCase
  ) {
    self.profile = profile
    self.putProfileUseCase = putProfileUseCase
  }
  
  private(set) var isCreatingSummary: Bool = true
  
  private let profile: ProfileModel
  private let putProfileUseCase: PutProfileUseCase
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      createAISummary()
    }
  }
  
  private func createAISummary() {
    Task {
      do {
        let _ = try await putProfileUseCase.execute(profile: profile)
        isCreatingSummary = false
      } catch {
        print(error)
      }
    }
  }
}

