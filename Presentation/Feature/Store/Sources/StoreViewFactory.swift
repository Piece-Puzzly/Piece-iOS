//
//  StoreViewFactory.swift
//  Store
//
//  Created by 홍승완 on 11/4/25.
//

import Entities
import SwiftUI
import UseCases
import PCAmplitude

public struct StoreViewFactory {
  public static func createStoreMainView(
    getCashProductsUseCase: GetCashProductsUseCase,
    deletePaymentHistoryUseCase: DeletePaymentHistoryUseCase,
    fetchValidStoreProductsUseCase: FetchValidStoreProductsUseCase
  ) -> some View {
    StoreMainView(
      getCashProductsUseCase: getCashProductsUseCase,
      deletePaymentHistoryUseCase: deletePaymentHistoryUseCase,
      fetchValidStoreProductsUseCase: fetchValidStoreProductsUseCase
    )
  }
}
