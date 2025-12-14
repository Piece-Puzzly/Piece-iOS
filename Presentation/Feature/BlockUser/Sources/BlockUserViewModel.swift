//
// BlockUserViewModel.swift
// BlockUser
//
// Created by summercat on 2025/02/12.
//

import Observation
import UseCases
import PCAmplitude
import Entities

@Observable
final class BlockUserViewModel {
  enum Action {
    case didTapBottomButton
    case didTapBlockUserAlertBackButton
    case didTapBlockUserAlertBlockUserButton
    case didTapBlockUserCompleteButton
  }
  
  init(
    info: BlockUserInfo,
    blockUserUseCase: BlockUserUseCase
  ) {
    self.matchId = info.matchId
    self.nickname = info.nickname
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
        _ = try await blockUserUseCase.execute(matchId: matchId)
        isBlockUserCompleteAlertPresented = true
      } catch {
        print(error)
      }
    }
  }
}
