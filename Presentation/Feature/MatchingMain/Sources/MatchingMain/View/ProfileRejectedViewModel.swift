//
//  ProfileRejectedViewModel.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import Observation
import UseCases

@MainActor
@Observable
final class ProfileRejectedViewModel {
  enum Action {
    case onAppear
  }
  
  private let getUserRejectUseCase: GetUserRejectUseCase
  init(getUserRejectUseCase: GetUserRejectUseCase) {
    self.getUserRejectUseCase = getUserRejectUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleOnAppear()
    }
  }
  
  private func handleOnAppear() {
  }
  
  private func fetchUserRejectState() async -> ProfileRejectedReason {
  }

}
