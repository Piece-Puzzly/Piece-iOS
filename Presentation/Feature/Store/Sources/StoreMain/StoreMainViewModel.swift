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
    case didTapNormalProduct(NormalProductModel)
    case didTapPromotionProduct(PromotionProductModel)
    case didCompletePurchase
  }
  
  private let getCashProductsUseCase: GetCashProductsUseCase
  private let deletePaymentHistoryUseCase: DeletePaymentHistoryUseCase
  private let fetchValidStoreProductsUseCase: FetchValidStoreProductsUseCase
  
  private(set) var viewState: StoreMainViewState = .loading
  private(set) var normalProducts: [NormalProductModel] = []
  private(set) var promotionProducts: [PromotionProductModel] = []
  private(set) var completedPuzzleCount: Int64 = 0
  private(set) var shouldDismiss: Bool = false
  private(set) var isPurchasing: Bool = false
  var isShowingPurchaseCompleteAlert: Bool = false
  
  
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
//      loadProductsDummy()
      loadProducts()

    case .didTapNormalProduct(let product):
      purchaseNormalProduct(product)

    case .didTapPromotionProduct(let product):
      purchasePromotionProduct(product)

    case .didCompletePurchase:
      completePurchase()
    }
  }
}

// MARK: - Private Methods
private extension StoreMainViewModel {
  func loadProductsDummy() {
    Task {
      try await Task.sleep(for: .seconds(1))
      self.normalProducts = NormalProductModel.default
      self.promotionProducts = PromotionProductModel.default
      self.viewState = .success
    }
  }
  
  func loadProducts() {
    Task {
      let cashProducts = try await getCashProductsUseCase.execute()
      let validProducts = try await fetchValidStoreProductsUseCase.execute(cashProducts: cashProducts)
      self.normalProducts = validProducts.normalProducts
      self.promotionProducts = validProducts.promotionProducts
      self.viewState = .success
    }
  }
  
  func purchaseNormalProduct(_ product: NormalProductModel) {
    guard !isPurchasing else { return }
    
    Task {
      isPurchasing = true
      defer { isPurchasing = false }
      
      try await Task.sleep(for: .seconds(1))
      isShowingPurchaseCompleteAlert = true
      completedPuzzleCount = product.backendProduct.rewardPuzzleCount
    }
  }
  
  func purchasePromotionProduct(_ product: PromotionProductModel) {
    guard !isPurchasing else { return }
    
    Task {
      isPurchasing = true
      defer { isPurchasing = false }
      
      try await Task.sleep(for: .seconds(1))
      isShowingPurchaseCompleteAlert = true
      completedPuzzleCount = 50
    }
  }
  
  func completePurchase() {
    Task {
      isShowingPurchaseCompleteAlert = false
      shouldDismiss = true
    }
  }
}
