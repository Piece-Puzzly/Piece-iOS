//
//  UserEndpoint.swift
//  PCNetwork
//
//  Created by summercat on 3/5/25.
//

import Alamofire
import DTO
import LocalStorage
import Entities

public enum UserEndpoint: TargetType {
  case withdrawWithPiece(WithdrawRequestDTO)
  case getUserRole
  case userReject
  case getPuzzleCount
  
  public var method: Alamofire.HTTPMethod {
    switch self {
    case .withdrawWithPiece: .delete
    case .getUserRole: .get
    case .userReject: .get
    case .getPuzzleCount: .get
    }
  }
  
  public var path: String {
    switch self {
    case .withdrawWithPiece(let dto):
      dto.providerName == SocialLoginType.apple.rawValue
      ? "api/users/oauth"
      : "api/users"
    case .getUserRole: "api/users/info"
    case .userReject: "api/users/reject"
    case .getPuzzleCount: "api/users/puzzle"
    }
  }
  
  public var headers: [String : String] {
    switch self {
    case .withdrawWithPiece:
      [
        NetworkHeader.contentType : NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .getUserRole:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .userReject:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .getPuzzleCount:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case let .withdrawWithPiece(body): .body(body)
    case .getUserRole: .plain
    case .userReject: .plain
    case .getPuzzleCount: .plain
    }
  }
}

