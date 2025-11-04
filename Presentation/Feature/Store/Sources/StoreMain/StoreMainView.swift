//
// StoreMainView.swift
// Store
//
// Created by 홍승완 on 2025/11/04.
//

import SwiftUI
import DesignSystem
import UseCases

struct StoreMainView: View {
  @State var viewModel: StoreMainViewModel

  init(
    getCashProductsUseCase: GetCashProductsUseCase,
    deletePaymentHistoryUseCase: DeletePaymentHistoryUseCase,
    fetchValidStoreProductsUseCase: FetchValidStoreProductsUseCase,
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        getCashProductsUseCase: getCashProductsUseCase,
        deletePaymentHistoryUseCase: deletePaymentHistoryUseCase,
        fetchValidStoreProductsUseCase: fetchValidStoreProductsUseCase,
      )
    )
  }
  
  var body: some View {
    VStack {
      Text("Hello, World!")
    }
  }
}
