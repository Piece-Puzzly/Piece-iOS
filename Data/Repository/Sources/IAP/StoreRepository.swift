//
//  StoreRepository.swift
//  Repository
//
//  Created by 홍승완 on 11/2/25.
//

import Entities
import RepositoryInterfaces
import StoreKit

final class StoreRepository: StoreRepositoryInterface {
  func fetchProducts(productIDs: Set<String>) async throws -> [StoreProductModel] {
    let products = try await Product.products(for: productIDs)
    
    return products.map {
      StoreProductModel(
        id: $0.id,
        displayName: $0.displayName,
        description: $0.description,
        price: $0.price,
        displayPrice: $0.displayPrice
      )
    }
  }
  
  func purchase(productID: String) async throws -> IAPResult {
    let products = try await Product.products(for: [productID])
    guard let product = products.first else {
      throw CompleteIAPError.productNotFound
    }
    
    let result = try await product.purchase()
    
    switch result {
    case .success(let verificationResult):
      switch verificationResult {
      case .verified(let transaction):
        let jws = verificationResult.jwsRepresentation
        let iapResult = IAPResult(
          jwsRepresentation: jws,
          finishTransaction: { await transaction.finish() }
        )
        return iapResult
        
      case .unverified:   throw CompleteIAPError.purchaseFailed
      }
      
    case .userCancelled:  throw CompleteIAPError.userCancelled
    case .pending:        throw CompleteIAPError.purchasePending
    @unknown default:     throw CompleteIAPError.unknown
    }
  }
}

