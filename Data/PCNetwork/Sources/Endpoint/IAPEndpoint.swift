//
//  IAPEndpoint.swift
//  PCNetwork
//
//  Created by 홍승완 on 11/1/25.
//

import Alamofire
import DTO
import LocalStorage

public enum IAPEndpoint: TargetType {
  case getCashProducts
  case postVerifyIAP(PostVerifyIAPRequestDTO)
  case deletePaymentHistory /// 개발 환경 전용 API (for. 프로모션 결제 상품 테스트)
  
  public var method: HTTPMethod {
    switch self {
    case .getCashProducts: .get
    case .postVerifyIAP: .post
    case .deletePaymentHistory: .delete
    }
  }
  
  public var path: String {
    switch self {
    case .getCashProducts: "api/cash-products"
    case .postVerifyIAP: "api/payments/in-app"
    case .deletePaymentHistory: "api/payments"
    }
  }
  
  public var headers: [String : String] {
    switch self {
    case .getCashProducts:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .postVerifyIAP:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? ""),
        NetworkHeader.contentType: NetworkHeader.applicationJson
      ]
    case .deletePaymentHistory:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case .getCashProducts: .plain
    case let .postVerifyIAP(dto): .body(dto)
    case .deletePaymentHistory: .plain
    }
  }
}
