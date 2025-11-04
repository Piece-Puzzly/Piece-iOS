//
//  CompleteIAPUseCase.swift
//  UseCases
//
//  Created by 홍승완 on 11/3/25.
//

import Entities
import RepositoryInterfaces

public protocol CompleteIAPUseCase {
  func execute(productID: String) async throws -> VoidModel
}

final class CompleteIAPUseCaseImpl: CompleteIAPUseCase {
  private let storeRepository: StoreRepositoryInterface
  private let iapRepository: IAPRepositoryInterface
  
  init(
    storeRepository: StoreRepositoryInterface,
    iapRepository: IAPRepositoryInterface
  ) {
    self.storeRepository = storeRepository
    self.iapRepository = iapRepository
  }
  
  func execute(productID: String) async throws -> VoidModel {
    /// 1. StoreKit에서 구매
    let purchaseResult = try await storeRepository.purchase(productID: productID)
    
    /// 2. 서버 검증
    do {
      _ = try await iapRepository.postVerifyIAP(
        productUUID: productID,
        purchaseCredential: purchaseResult.jwsRepresentation,
        store: .appStore
      )
      
      /// 3.1. 성공 시 finish 호출
      await purchaseResult.finishTransaction()
      return VoidModel()
    } catch {
      /// 3.2. 검증 실패해도 finish 호출 (다음 구매 UI 막힘 방지)
      await purchaseResult.finishTransaction()
      throw error
    }
  }
}
