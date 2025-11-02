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
}

