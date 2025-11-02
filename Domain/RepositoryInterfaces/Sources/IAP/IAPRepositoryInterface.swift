//
//  IAPRepositoryInterface.swift
//  RepositoryInterfaces
//
//  Created by 홍승완 on 11/1/25.
//

import Entities

public protocol IAPRepositoryInterface {
  func getCashProducts() async throws -> CashProductsModel
}
