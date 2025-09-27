//
//  WithdrawConfirmViewModel.swift
//  Withdraw
//
//  Created by eunseou on 2/17/25.
//

import SwiftUI
import UseCases
import Router
import LocalStorage
import KakaoSDKUser
import AuthenticationServices
import PCAmplitude

@MainActor
@Observable
final class WithdrawConfirmViewModel: NSObject {
  enum Action {
    case confirmWithdraw
  }
  
  init(
    deleteUserAccountUseCase: DeleteUserAccountUseCase,
    appleAuthServiceUseCase: AppleAuthServiceUseCase,
    withdrawReason: String
  ) {
    self.deleteUserAccountUseCase = deleteUserAccountUseCase
    self.appleAuthServiceUseCase = appleAuthServiceUseCase
    self.withdrawReason = withdrawReason
  }
  
  private(set) var destination: Route?
  private var withdrawReason: String
  private let deleteUserAccountUseCase: DeleteUserAccountUseCase
  private let appleAuthServiceUseCase: AppleAuthServiceUseCase
  
  func handleAction(_ action: Action) {
    switch action {
    case .confirmWithdraw:
      Task { await handleConfirmWithdraw() }
    }
  }
  
  private func handleConfirmWithdraw() async {
    guard let socialLoginType = PCUserDefaultsService.shared.getSocialLoginType() else {
      print("Unsupported login type")
      return
    }
    let providerName = socialLoginType.rawValue
    
    switch socialLoginType {
    case .apple:
      await revokeAppleIDCredential(with: providerName)
    case .kakao:
      await revokeKakao(with: providerName)
    case .google:
      await revokeGoogle(with: providerName)
    }
  }
  
  private func revokeKakao(with providerName: String) async {
    print("🔍 Kakao 탈퇴 진행")
    
    await withCheckedContinuation { continuation in
      UserApi.shared.unlink { error in
        if let error = error {
          print("❌ Kakao unlink error: \(error)")
        } else {
          print("✅ Kakao unlink success")
        }
        continuation.resume()
      }
    }
    
    do {
      do {
        _ = try await deleteUserAccountUseCase.execute(
          providerName: providerName,
          oauthCredential: "",
          reason: withdrawReason
        )
        print("✅ DeleteUserAccount success")
      } catch let error as NSError {
        // 200 상태 코드인 경우 성공으로 처리
        if error.localizedDescription.contains("Status Code: 200") {
          print("✅ DeleteUserAccount 성공 (Status 200)")
        } else {
          throw error
        }
      }
      
      // 성공 시 initialize 호출
      await MainActor.run {
        initialize()
      }
    } catch {
      print("\(error.localizedDescription)")
    }
  }
  
  private func revokeAppleIDCredential(with providerName: String) async {
    print("🔍 Apple 탈퇴 진행")
    
    do {
      let appleIDProvider = try await appleAuthServiceUseCase.execute()
      print("✅ Apple authorization code : \(appleIDProvider.authorizationCode)")
      do {
        _ = try await deleteUserAccountUseCase.execute(
          providerName: providerName,
          oauthCredential: appleIDProvider.authorizationCode,
          reason: withdrawReason
        )
        print("✅ DeleteUserAccount success")
      } catch let error as NSError {
        if error.localizedDescription.contains("Status Code: 200") {
          print("✅ DeleteUserAccount 성공 (Status 200)")
        } else {
          throw error
        }
      }
      
      await MainActor.run {
        initialize()
      }
    } catch {
      print("\(error.localizedDescription)")
    }
  }
  
  private func revokeGoogle(with providerName: String) async {
    print("🔍 Google 탈퇴 진행")
    
    do {
      _ = try await deleteUserAccountUseCase.execute(
        providerName: providerName,
        oauthCredential: "",
        reason: withdrawReason
      )
      print("✅ DeleteUserAccount success")
      
      await MainActor.run {
        initialize()
      }
    } catch let error as NSError {
      if error.localizedDescription.contains("Status Code: 200") {
        print("✅ DeleteUserAccount 성공 (Status 200)")
        await MainActor.run {
          initialize()
        }
      } else {
        print("\(error.localizedDescription)")
      }
    }
  }
  
  private func initialize() {
    print("✅ Withdraw started")
    clearUserDataPreservingFCMToken()
    
    destination = .splash
    print("✅ Withdraw completed - moved to splash")
  }
  
  private func clearUserDataPreservingFCMToken() {
    let fcmToken = PCKeychainManager.shared.read(.fcmToken)
    PCKeychainManager.shared.deleteAll()
    PCUserDefaultsService.shared.initialize()
    PCAmplitude.clearUserId()
    
    if let fcmToken {
      PCKeychainManager.shared.save(.fcmToken, value: fcmToken)
      print("✅ User data cleared with FCM token preserved")
    } else {
      print("✅ User data cleared")
    }
  }
}
