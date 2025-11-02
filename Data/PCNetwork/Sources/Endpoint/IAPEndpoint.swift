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
  
  public var method: HTTPMethod {
    switch self {
    case .getCashProducts: .get
    }
  }
  
  public var path: String {
    switch self {
    case .getCashProducts: "api/cash-products"
    }
  }
  
  public var headers: [String : String] {
    switch self {
    case .getCashProducts:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case .getCashProducts: .plain
    }
  }
}
