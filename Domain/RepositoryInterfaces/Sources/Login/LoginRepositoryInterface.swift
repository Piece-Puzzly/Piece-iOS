//
//  LoginRepositoryInterface.swift
//  RepositoryInterfaces
//
//  Created by eunseou on 2/8/25.
//

import SwiftUI
import Entities

public protocol LoginRepositoryInterface {
  func socialLogin(providerName: SocialLoginType, token: String) async throws -> SocialLoginResultModel
  func sendSMSCode(phoneNumber: String) async throws -> VoidModel
  func verifySMSCode(phoneNumber: String, code: String) async throws -> VerifySMSCodeResponseModel
  func checkTokenHealth(token: String) async throws -> VoidModel
  func registerFcmToken(token: String) async throws -> VoidModel
  func testLogin(userId: Int) async throws -> SocialLoginResultModel
}
