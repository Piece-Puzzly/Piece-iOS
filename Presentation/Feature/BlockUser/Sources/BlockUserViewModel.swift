//
// BlockUserViewModel.swift
// BlockUser
//
// Created by summercat on 2025/02/12.
//

import Observation
import UseCases
import PCAmplitude

@Observable
final class BlockUserViewModel {
  enum Action {
    case didTapBottomButton
    case didTapBlockUserAlertBackButton
    case didTapBlockUserAlertBlockUserButton
    case didTapBlockUserCompleteButton
  }
  
  init(matchId: Int, nickname: String, blockUserUseCase: BlockUserUseCase) {
    self.matchId = matchId
    self.nickname = nickname
    self.blockUserUseCase = blockUserUseCase
  }
  
  let matchId: Int
  let nickname: String
  
  var isBlockUserAlertPresented: Bool = false
  var isBlockUserCompleteAlertPresented: Bool = false
  
  private let blockUserUseCase: BlockUserUseCase
  
  func handleAction(_ action: Action) {
    switch action {
    case .didTapBottomButton:
      isBlockUserAlertPresented = true
      PCAmplitude.trackScreenView(DefaultProgress.blockConfirmPopup.rawValue)
      
    case .didTapBlockUserAlertBackButton:
      isBlockUserAlertPresented = false
      
    case .didTapBlockUserAlertBlockUserButton:
      blockUser()
      PCAmplitude.trackScreenView(DefaultProgress.blockCompletePopup.rawValue)
      
    case .didTapBlockUserCompleteButton:
      isBlockUserCompleteAlertPresented = false
    }
  }
  
  private func blockUser() {
    Task {
      do {
        isBlockUserAlertPresented = false
        let result = try await blockUserUseCase.execute(matchId: matchId)
        isBlockUserCompleteAlertPresented = true
      } catch {
        print(error)
      }
    }
  }
}
