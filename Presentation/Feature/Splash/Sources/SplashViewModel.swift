//
// SplashViewModel.swift
// Splash
//
// Created by summercat on 2025/02/14.
//

import LocalStorage
import Observation
import PCFirebase
import PCFoundationExtension
import PCNetwork
import Router
import UseCases
import UIKit
import Entities

@MainActor
@Observable
final class SplashViewModel {
  enum Action {
    case onAppear
    case openAppStore
  }
  
  let inquiriesUri = "https://kd0n5.channel.io/home"
  var showNeedsForceUpdateAlert: Bool = false
  var showBannedAlert: Bool = false
  private(set) var destination: Route?
  
  private let getUserInfoUseCase: GetUserInfoUseCase
  
  init(getUserInfoUseCase: GetUserInfoUseCase) {
    self.getUserInfoUseCase = getUserInfoUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      onAppear()
      
    case .openAppStore:
      openAppStore()
    }
  }
  
  private func onAppear() {
    /// 1.  강제 업데이트 필요 여부 확인
    /// 2. 온보딩 여부 확인
    /// - 온보딩 본 적 없으면 온보딩 화면으로
    /// - 본 적 있으면 토큰 확인
    /// 3. 인증 토큰 확인
    /// - accessToken이 유효하면 바로 사용
    /// - accessToken이 유효하지 않으면 refreshToken으로 갱신 시도 (Interceptor에서 처리)
    /// - 둘 다 없거나 갱신 실패시 로그인 화면으로 이동
    /// 4. 인증 성공 후 role에 따라 화면 분기 처리
    /// - NONE: 소셜 로그인 완료, SMS 인증 전 > SMS 인증 화면으로
    /// - REGISTER: SMS 인증 완료 > 프로필 등록 화면으로
    /// - PENDING: 프로필 등록 완료, 프로필 심사중 > 매칭 메인 - 심사중
    /// - USER: 프로필 심사 완료 > 매칭 메인
    
    print("Splash onAppear called")
    
    Task {
      do {
        await checkForceUpdate()
        guard !showNeedsForceUpdateAlert else { return }
        
        guard checkOnboarding() else { return }
        checkAccesstoken()
        try await setRoute()
      } catch let error as NetworkError {
        var destination: Route = .login
        switch error {
        case .badRequest(let error):
          print("bad request error: \(error?.message ?? "")")
        case .unauthorized(let error):
          print("unauthorized")
          if error?.code == "INVALID_REFRESH_TOKEN" {
            print(error?.code)
            destination = .login
          } else if error?.code == "EXPIRED_REFRESH_TOKEN" {
            print(error?.code)
            destination = .login
          }
        case .forbidden:
          print("forbidden")
          destination = .login
        case .notFound:
          print("not found")
          destination = .login
        case .internalServerError:
          print("internal server error")
          // TODO: - 네트워크 에러 화면으로 라우팅
        case .statusCode(let int):
          print("status code: \(int)")
        case .missingStatusCode:
          print("missing status code")
        case .emptyResponse:
          print("empty response")
        case .encodingFailed:
          print("encoding failed")
        case .decodingFailed:
          print("decoding failed")
        case .noRefreshToken:
          print("no refresh token")
        }
        self.destination = destination
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        destination = .login
      }
    }
  }
  
  // MARK: - onAppear 시 로직
  
  private func checkForceUpdate() async {
    do {
      try await PCFirebase.shared.fetchRemoteConfigValues()
      let currentVersion = AppVersion.appVersion()
      
      #if DEBUG
      let minimumVersion = PCFirebase.shared.minimumVersionDebug()
      #else
      let minimumVersion = PCFirebase.shared.minimumVersion()
      #endif

      let needsForceUpdate = currentVersion.compare(minimumVersion, options: .numeric) == .orderedAscending
      
      NSLog(needsForceUpdate ? ">>> LOG:🚨 강제 업데이트 필요합니다." : ">>> LOG: 🔹 업데이트가 없습니다.")
      NSLog(">>> LOG: 🔔 currentVersion(\(currentVersion))")
      NSLog(">>> LOG: 🔔 minimumVersion(\(minimumVersion))")
      NSLog(">>> LOG: 🔔 needsForceUpdate(\(needsForceUpdate))")
      showNeedsForceUpdateAlert = needsForceUpdate
    } catch {
      print("🔥 Failed to check for updates: \(error.localizedDescription)")
      showNeedsForceUpdateAlert = false
    }
  }
  
  private func checkOnboarding() -> Bool {
    guard PCUserDefaultsService.shared.getDidSeeOnboarding() else {
      print("온보딩을 본 적 없어 온보딩 화면으로 이동")
      destination = .onboarding
      return false
    }
    return true
  }
  
  private func checkAccesstoken() {
    // 로그인 여부 확인 ( AccessToken 유무 확인 )
    guard let accessToken = PCKeychainManager.shared.read(.accessToken) else {
      print("AccessToken이 없어서 로그인 화면으로 이동")
      destination = .login
      return
    }
    print("SplashView AccessToken: \(accessToken)")
  }
  
  private func openAppStore() {
    let appId = "6742348014"
    let appStoreUrl = "itms-apps://itunes.apple.com/app/apple-store/\(appId)"
    guard let url = URL(string: appStoreUrl) else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
  
  private func setRoute() async throws {
    // 사용자 role에 따라 화면 분기 처리
    let userInfo = try await getUserInfoUseCase.execute()
    let userRole = userInfo.role
    PCUserDefaultsService.shared.setUserRole(userRole)
    
    switch userRole {
    case .NONE:
      print("---NONE---")
      destination = .login
    case .REGISTER:
      print("---REGISTER---")
      destination = .login
    case .PENDING:
      print("---PENDING---")
      destination = .home
    case .USER:
      print("---USER---")
      destination = .home
    case .BANNED:
      print("---BANNED---")
      showBannedAlert = true
      destination = nil
    @unknown default:
      destination = .login
    }
  }
}
