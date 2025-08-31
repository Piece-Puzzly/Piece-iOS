//
//  LoginRepository.swift
//  Repository
//
//  Created by eunseou on 2/8/25.
//

import DTO
import Entities
import LocalStorage
import PCNetwork
import RepositoryInterfaces
import Foundation

public final class LoginRepository: LoginRepositoryInterface {

  private let networkService: NetworkService
  
  public init (networkService: NetworkService) {
    self.networkService = networkService
  }
  
  public func socialLogin(
    providerName: SocialLoginType,
    token: String
  ) async throws -> SocialLoginResultModel {
    let body = SocialLoginRequsetDTO(providerName: providerName, token: token)
    let endpoint = LoginEndpoint.loginWithOAuth(body: body)
    let responseDTO: SocialLoginResponseDTO = try await networkService.requestWithoutAuth(endpoint: endpoint)
    PCKeychainManager.shared.save(.accessToken, value: responseDTO.accessToken)
    PCKeychainManager.shared.save(.refreshToken, value: responseDTO.refreshToken)
    networkService.updateCredentials()
    
    if let fcmToken = PCKeychainManager.shared.read(.fcmToken) {
      let dataDict: [String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: .fcmToken, object: nil, userInfo: dataDict)
    }

    return responseDTO.toDomain()
  }
  
  public func sendSMSCode(phoneNumber: String) async throws -> VoidModel {
    let body = SMSCodeRequestDTO(phoneNumber: phoneNumber)
    let endpoint = RegisterEndpoint.sendSMSCode(body: body)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  public func verifySMSCode(phoneNumber: String, code: String) async throws -> VerifySMSCodeResponseModel {
    let body = VerifySMSCodeRequestDTO(phoneNumber: phoneNumber, code: code)
    let endpoint = RegisterEndpoint.verifySMSCode(body: body)
    let responseDTO: VerifySMSCodeResponseDTO = try await networkService.request(endpoint: endpoint)
    if let accessToken = responseDTO.accessToken,
       let refreshToken = responseDTO.refreshToken {
      PCKeychainManager.shared.save(.accessToken, value: accessToken)
      PCKeychainManager.shared.save(.refreshToken, value: refreshToken)
      networkService.updateCredentials()
    }
    return responseDTO.toDomain()
  }
  
  public func checkTokenHealth(token: String) async throws -> VoidModel {
    let endpoint = LoginEndpoint.tokenHealthCheck(token: token)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  public func registerFcmToken(token: String) async throws -> VoidModel {
    let requestDto = FCMTokenRequestDTO(token: token)
    let endpoint = LoginEndpoint.registerFcmToken(body: requestDto)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  public func testLogin(userId: Int) async throws -> SocialLoginResultModel {
    let endpoint = LoginEndpoint.testLogin(userId: userId)
    let responseDTO: SocialLoginResponseDTO = try await networkService.requestWithoutAuth(endpoint: endpoint)
    PCKeychainManager.shared.save(.accessToken, value: responseDTO.accessToken)
    PCKeychainManager.shared.save(.refreshToken, value: responseDTO.refreshToken)
    networkService.updateCredentials()
    return responseDTO.toDomain()
  }
}
