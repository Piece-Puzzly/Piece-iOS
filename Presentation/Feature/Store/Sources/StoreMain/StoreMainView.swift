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
import Entities

struct StoreMainView: View {
  @State var viewModel: StoreMainViewModel
  
  @Environment(Router.self) private var router: Router

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
    .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
      if shouldDismiss { router.pop() }
    }
    .pcAlert(isPresented: $viewModel.isShowingPurchaseCompleteAlert) {
      AlertView(
        title: {
          Text("퍼즐 ").foregroundStyle(Color.grayscaleBlack) +
          Text("\(viewModel.completedPuzzleCount)").foregroundStyle(Color.primaryDefault) +
          Text("개를 구매했어요").foregroundStyle(Color.grayscaleBlack)
        },
        message: "지금 바로 새로운 인연을 만나보세요!",
        secondButtonText: "홈으로",
        secondButtonAction: { viewModel.handleAction(.didCompletePurchase) }
      )
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
        .padding(.horizontal, 20)
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
      LazyVStack(spacing: 0) {
        switch viewModel.viewState {
        case .loading:
          Text("LOADING STATE")
        
        case .success:
          PieceProductSectionView(viewModel: viewModel)
            .padding(.vertical, 20)
        
        case .failure:
          Text("FAILURE STATE")
        }
        
        StoreMainDescriptionView()
          .padding(.top, 12)
          .padding(.bottom, 60)
      }
      .immediateScrollTap()
    }
    .scrollIndicators(.hidden)
  }
}

fileprivate struct PieceProductSectionView: View {
  private let viewModel: StoreMainViewModel
  
  init(viewModel: StoreMainViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(spacing: 12) {
      PromotionProductSectionView(
        items: viewModel.promotionProducts,
        onTap: { viewModel.handleAction(.didTapPromotionProduct($0)) }
      )

      NormalProductSectionView(
        items: viewModel.normalProducts,
        onTap: { viewModel.handleAction(.didTapNormalProduct($0)) }
      )
    }
  }
}
