//
//  ReportsEndpoint.swift
//  PCNetwork
//
//  Created by summercat on 2/16/25.
//

import Alamofire
import DTO
import LocalStorage

public enum ReportsEndpoint: TargetType {
  case report(ReportsRequestDTO)
  
  public var method: Alamofire.HTTPMethod {
    switch self {
    case .report: .post
    }
  }
  
  public var path: String {
    switch self {
    case .report: "api/reports"
    }
  }
  
  public var headers: [String : String] {
    switch self {
    case .report:
      [
        NetworkHeader.contentType : NetworkHeader.applicationJson,
        NetworkHeader.authorization : NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case let .report(dto): .body(dto)
    }
  }
}
