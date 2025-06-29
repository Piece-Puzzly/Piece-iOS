//
//  NetworkService.swift
//  Network
//
//  Created by eunseou on 2/1/25.
//

import Alamofire
import DTO
import Foundation
import LocalStorage
import PCFoundationExtension

public class NetworkService {
  public static let shared = NetworkService()
  private let authQueue = DispatchQueue(label: "authQueue")
  private let networkLogger: NetworkLogger
  private let dateFormatter = DateFormatter()
  private var session: Session
  
  private init() {
    // Get tokens from keychain
    let accessToken = PCKeychainManager.shared.read(.accessToken) ?? ""
    let refreshToken = PCKeychainManager.shared.read(.refreshToken) ?? ""
    
    // Parse expiration time from token
    var expiration = Date(timeIntervalSinceNow: 60 * 60 * 24) // Default fallback
    if let claims = accessToken.decodeJWT(),
       let exp = claims["exp"] as? TimeInterval {
      expiration = Date(timeIntervalSince1970: exp)
    }
    
    // Create credential and session
    let credential = OAuthCredential(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiration: expiration
    )
    
    let authenticator = OAuthAuthenticator()
    let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
    let networkLogger = NetworkLogger()
    self.networkLogger = networkLogger
    self.session = Session(
      interceptor: interceptor,
      eventMonitors: [networkLogger]
    )
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
  }
  
  public func request<T: Decodable>(endpoint: TargetType) async throws -> T {
    print("🛰 request path: \(endpoint.path)")
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    return try await withCheckedThrowingContinuation { continuation in
      session.request(endpoint)
        .validate()
        .responseDecodable(
          of: APIResponse<T>.self,
          decoder: decoder
        ) { response in
          switch response.result {
          case .success(let apiResponse):
            print("🛰 API Response \(apiResponse.status): \(apiResponse.message)")
            continuation.resume(returning: apiResponse.data)
          case .failure(let error):
            if let afError = error.asAFError {
              let networkError = NetworkError.from(afError: afError)
              print("🛰 NetworkError Description: \(networkError.errorDescription)")
              continuation.resume(throwing: networkError)
            } else {
              continuation.resume(throwing: NetworkError.statusCode(-1))
            }
          }
        }
    }
  }
  
  public func requestWithoutAuth<T: Decodable>(endpoint: TargetType) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      AF.request(endpoint)
        .validate()
        .responseDecodable(of: APIResponse<T>.self) { response in
          switch response.result {
          case .success(let apiResponse):
            print("🛰 API Response \(apiResponse.status): \(apiResponse.message)")
            continuation.resume(returning: apiResponse.data)
          case .failure(let error):
            if let afError = error.asAFError {
              let networkError = NetworkError.from(afError: afError)
              print("🛰 NetworkError Description: \(networkError.errorDescription)")
              continuation.resume(throwing: networkError)
            } else {
              continuation.resume(throwing: NetworkError.statusCode(-1))
            }
          }
        }
    }
  }
  
  public func uploadImage<T: Decodable>(endpoint: TargetType, imageData: Data) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      session.upload(
        multipartFormData: {
          $0.append(
            imageData,
            withName: "file",
            fileName: "image.jpg",
            mimeType: "image/png"
          )
        },
        with: endpoint)
      .validate()
      .responseDecodable(of: APIResponse<T>.self) { response in
        switch response.result {
        case .success(let apiResponse):
          continuation.resume(returning: apiResponse.data)
        case .failure(let error):
          if let afError = error.asAFError {
            let networkError = NetworkError.from(afError: afError)
            continuation.resume(throwing: networkError)
          } else {
            continuation.resume(throwing: NetworkError.statusCode(-1))
          }
        }
      }
    }
  }
  
  public func updateCredentials() {
    authQueue.async { [weak self] in
      guard let self else { return }
      
      let accessToken = PCKeychainManager.shared.read(.accessToken) ?? ""
      let refreshToken = PCKeychainManager.shared.read(.refreshToken) ?? ""
      
      print("🛰 Session 업데이트 - Access Token: \(accessToken)")
      print("🛰 Session 업데이트 - Refresh Token: \(refreshToken)")
      
      var expiration = Date(timeIntervalSinceNow: 60 * 60 * 24) // Default fallback
      if let claims = accessToken.decodeJWT(),
         let exp = claims["exp"] as? TimeInterval {
        expiration = Date(timeIntervalSince1970: exp)
      }
      
      let credential = OAuthCredential(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiration: expiration
      )
      
      let authenticator = OAuthAuthenticator()
      let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
      self.session = Session(
        interceptor: interceptor,
        eventMonitors: [self.networkLogger]
      )
    }
  }
}
