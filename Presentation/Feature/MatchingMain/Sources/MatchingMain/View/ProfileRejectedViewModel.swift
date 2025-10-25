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
  enum ProfileRejectedViewState: Equatable {
    case loading
    case success
  }
  
  enum ProfileRejectedReason: Equatable {
    case all
    case image
    case valueTalk
  }
  
  enum Action {
    case onAppear
  }
  
  private let getUserRejectUseCase: GetUserRejectUseCase
  
  var viewState: ProfileRejectedViewState = .loading
  var rejectedReason: ProfileRejectedReason = .all
  
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
    Task {
      viewState = .loading
      rejectedReason = await fetchUserRejectState()
      viewState = .success
    }
  }
  
  private func fetchUserRejectState() async -> ProfileRejectedReason {
    do {
      let userRejectState = try await getUserRejectUseCase.execute()
      switch (userRejectState.reasonImage, userRejectState.reasonValues) {
      case (true, true):
        return .all
        
      case (true, false):
        return .image
        
      case (false, true):
        return .valueTalk
        
      case (false, false):
        return .all
      }
    } catch {
      print("ERROR: \(error.localizedDescription)")
      return .all
    }
  }

}
