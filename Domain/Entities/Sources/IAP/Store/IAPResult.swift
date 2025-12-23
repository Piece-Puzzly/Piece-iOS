//
//  IAPResult.swift
//  Entities
//
//  Created by 홍승완 on 11/3/25.
//

import Foundation

public struct IAPResult {
  public let jwsRepresentation: String
  public let finishTransaction: () async -> Void
  
  public init(jwsRepresentation: String, finishTransaction: @escaping () async -> Void) {
    self.jwsRepresentation = jwsRepresentation
    self.finishTransaction = finishTransaction
  }
}
