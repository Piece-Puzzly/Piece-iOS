//
//  FetchValidStoreProductsUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 11/2/25.
//

import Entities
import RepositoryInterfaces

public protocol FetchValidStoreProductsUseCase {
  func execute(cashProducts: CashProductsModel) async throws -> PieceCashProductsModel
}

final class FetchValidStoreProductsUseCaseImpl: FetchValidStoreProductsUseCase {
  private let repository: StoreRepositoryInterface
  
  init(repository: StoreRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(cashProducts: CashProductsModel) async throws -> PieceCashProductsModel {
    let basicProductIDs = cashProducts.basicCashProducts.map { $0.id }
    let promotionProductIDs = cashProducts.promotionCashProducts.map { $0.id }
    let allProductIDs = Set(basicProductIDs + promotionProductIDs)
    
    let validStoreProducts = try await repository.fetchProducts(productIDs: allProductIDs)
    let validProductIDs = Set(validStoreProducts.map { $0.id })
    
    let normalProducts = cashProducts.basicCashProducts
      .filter { validProductIDs.contains($0.id) }
      .compactMap { basicProduct -> NormalProductModel? in
        guard let storeProduct = validStoreProducts.first(where: { $0.id == basicProduct.id }) else {
          return nil
        }
        return NormalProductModel(storeProduct: storeProduct, backendProduct: basicProduct)
      }
    
    let promotionProducts = cashProducts.promotionCashProducts
      .filter { validProductIDs.contains($0.id) }
      .compactMap { promoProduct -> PromotionProductModel? in
        guard let storeProduct = validStoreProducts.first(where: { $0.id == promoProduct.id }) else {
          return nil
        }
        return PromotionProductModel(storeProduct: storeProduct, backendProduct: promoProduct)
      }
    
    return PieceCashProductsModel(
      normalProducts: normalProducts,
      promotionProducts: promotionProducts
    )
  }
}
