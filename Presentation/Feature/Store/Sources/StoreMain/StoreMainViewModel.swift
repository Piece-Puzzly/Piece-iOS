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
  func loadProducts() {
    Task {
      try await Task.sleep(for: .seconds(1))
      self.normalProducts = StoreMainViewModel.dummyNormalProducts
      self.promotionProducts = StoreMainViewModel.dummyPromotionProducts
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

// MARK: - Dummy Data (추후 제거)
extension StoreMainViewModel {
  static let dummyNormalProducts: [NormalProductModel] = [
    NormalProductModel(
      storeProduct: StoreProductModel(id: "1", displayName: "", description: "", price: 0, displayPrice: ""),
      backendProduct: BasicCashProductModel(uuid: "11", name: "5 퍼즐", rewardPuzzleCount: 5, originalAmount: 9900, currencyCode: "", discountRate: 0, discountedAmount: 9900)
    ),
    NormalProductModel(
      storeProduct: StoreProductModel(id: "2", displayName: "", description: "", price: 0, displayPrice: ""),
      backendProduct: BasicCashProductModel(uuid: "22", name: "10 퍼즐", rewardPuzzleCount: 10, originalAmount: 19000, currencyCode: "", discountRate: 10, discountedAmount: 17100)
    ),
    NormalProductModel(
      storeProduct: StoreProductModel(id: "3", displayName: "", description: "", price: 0, displayPrice: ""),
      backendProduct: BasicCashProductModel(uuid: "33", name: "20 퍼즐", rewardPuzzleCount: 20, originalAmount: 38000, currencyCode: "", discountRate: 15, discountedAmount: 32300)
    ),
    NormalProductModel(
      storeProduct: StoreProductModel(id: "4", displayName: "", description: "", price: 0, displayPrice: ""),
      backendProduct: BasicCashProductModel(uuid: "44", name: "50 퍼즐", rewardPuzzleCount: 50, originalAmount: 95000, currencyCode: "", discountRate: 20, discountedAmount: 76000)
    )
  ]
  
  static let dummyPromotionProducts: [PromotionProductModel] = [
    PromotionProductModel(
      storeProduct: StoreProductModel(id: "", displayName: "", description: "", price: 19000, displayPrice: ""),
      backendProduct: PromotionCashProductModel(uuid: "", cardImageUrl: "https://piece-object.s3.ap-northeast-2.amazonaws.com/promtions/First_payment_promotion+_banner.svg")
    )
  ]
}

