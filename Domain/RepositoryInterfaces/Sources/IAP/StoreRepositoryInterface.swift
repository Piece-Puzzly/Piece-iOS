//
//  StoreRepositoryInterface.swift
//  RepositoryInterfaces
//
//  Created by 홍승완 on 11/2/25.
//

import Entities

public protocol StoreRepositoryInterface {
  func fetchProducts(productIDs: Set<String>) async throws -> [StoreProductModel]
  func purchase(productID: String) async throws -> IAPResult
}
