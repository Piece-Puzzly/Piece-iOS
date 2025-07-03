//
//  LoginEndPoint.swift
//  PCNetwork
//
//  Created by eunseou on 2/7/25.
//

import Alamofire
import DTO
import Foundation
import LocalStorage

public enum LoginEndpoint: TargetType {
  case loginWithOAuth(body: SocialLoginRequsetDTO)
  case tokenRefresh(body: TokenRefreshRequestDTO)
  case tokenHealthCheck(token: String)
  case registerFcmToken(body: FCMTokenRequestDTO)
  case testLogin(userId: Int)
  
  public var headers: [String : String] {
    switch self {
    case .loginWithOAuth:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson
      ]
    case .tokenRefresh(body: let body):
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
      ]
    case .tokenHealthCheck: [:]
    case .registerFcmToken:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .testLogin:
      [:]
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .loginWithOAuth:
        .post
    case .tokenRefresh: .patch
    case .tokenHealthCheck: .get
    case .registerFcmToken: .post
    case .testLogin: .post
    }
  }
  
  public var path: String {
    switch self {
    case .loginWithOAuth:
      "api/login/oauth"
    case .tokenRefresh:
      "api/login/token/refresh"
    case .tokenHealthCheck:
      "api/login/token/health-check/"
    case .registerFcmToken:
      "api/users/fcm-token"
    case let .testLogin(userId):
      "api/login/test/users/\(userId)"
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case .loginWithOAuth(let body):
        .body(body)
    case let .tokenRefresh(body):
        .body(body)
    case let .tokenHealthCheck(token): .query([URLQueryItem(name: "token", value: token)])
    case let .registerFcmToken(body):
        .body(body)
    case .testLogin:
        .plain
    }
  }
}
