//
// StoreMainViewModel.swift
// Store
//
// Created by 홍승완 on 2025/11/04.
//

import Observation
import UseCases
import Entities

@Observable
final class StoreMainViewModel {
  enum StoreMainViewState: Equatable {
    case loading
    case success
    case failure
  }
  
  enum Action {
    case onAppear
  }
  
  private let getCashProductsUseCase: GetCashProductsUseCase
  private let deletePaymentHistoryUseCase: DeletePaymentHistoryUseCase
  private let fetchValidStoreProductsUseCase: FetchValidStoreProductsUseCase
  
  var viewState: StoreMainViewState = .loading
  
  init(
    getCashProductsUseCase: GetCashProductsUseCase,
    deletePaymentHistoryUseCase: DeletePaymentHistoryUseCase,
    fetchValidStoreProductsUseCase: FetchValidStoreProductsUseCase
  ) {
    self.getCashProductsUseCase = getCashProductsUseCase
    self.deletePaymentHistoryUseCase = deletePaymentHistoryUseCase
    self.fetchValidStoreProductsUseCase = fetchValidStoreProductsUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        try await Task.sleep(for: .seconds(3))
        self.viewState = .success
      }
    }
  }
}
