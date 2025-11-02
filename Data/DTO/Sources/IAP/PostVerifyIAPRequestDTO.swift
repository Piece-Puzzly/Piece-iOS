//
//  PostVerifyIAPRequestDTO.swift
//  DTO
//
//  Created by 홍승완 on 11/2/25.
//

import Entities
import Foundation

public struct PostVerifyIAPRequestDTO: Encodable {
  public let productUUID: String
  public let purchaseCredential: String
  public let store: AppStoreType
  
  public init(productUUID: String, purchaseCredential: String, store: AppStoreType) {
    self.productUUID = productUUID
    self.purchaseCredential = purchaseCredential
    self.store = store
  }
}
