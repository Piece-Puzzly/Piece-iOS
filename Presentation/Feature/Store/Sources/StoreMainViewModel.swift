//
// StoreMainViewModel.swift
// Store
//
// Created by 홍승완 on 2025/11/04.
//

import Observation
@Observable
final class StoreMainViewModel {
  enum Action {
    case onAppear
  }
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
    }
  }
}
