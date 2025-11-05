//
// StoreMainView.swift
// Store
//
// Created by 홍승완 on 2025/11/04.
//

import SwiftUI
import DesignSystem
import UseCases
import Router

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
    ZStack {
      BackgroundView()
      
      MainContentView(viewModel: viewModel)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
  }
}

// MARK: - Background View
fileprivate struct BackgroundView: View {
  var body: some View {
    Color.grayscaleLight3.edgesIgnoringSafeArea(.all)
  }
}

// MARK: - Main Content View
fileprivate struct MainContentView: View {
  @Environment(Router.self) private var router: Router
  
  private let viewModel: StoreMainViewModel
  
  init(viewModel: StoreMainViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(spacing: 0) {
      StoreNavigationBar(viewModel: viewModel)
      
      StoreMainListContentView(viewModel: viewModel)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .toolbar(.hidden)
  }
}

// MARK: - Store List Content View
fileprivate struct StoreMainListContentView: View {
  private let viewModel: StoreMainViewModel
  
  init(viewModel: StoreMainViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ScrollView {
      switch viewModel.viewState {
      case .loading:
        Text("LOADING STATE")
      case .success:
        Text("SUCCESS STATE")
      case .failure:
        Text("FAILURE STATE")
      }
    }
  }
}
