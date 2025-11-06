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
  }
  
  private let getCashProductsUseCase: GetCashProductsUseCase
  private let deletePaymentHistoryUseCase: DeletePaymentHistoryUseCase
  private let fetchValidStoreProductsUseCase: FetchValidStoreProductsUseCase
  
  private(set) var viewState: StoreMainViewState = .loading
  private(set) var normalProducts: [NormalProductModel] = []
  private(set) var promotionProducts: [PromotionProductModel] = []
  
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
        try await Task.sleep(for: .seconds(1))
        self.normalProducts = StoreMainViewModel.dummyNormalProducts
        self.promotionProducts = StoreMainViewModel.dummyPromotionProducts
        self.viewState = .success
      }
      
    case .didTapNormalProduct(let product):
      print(product.name)
      
    case .didTapPromotionProduct(let product):
      print(product.originPriceString)
    }
  }
}

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

