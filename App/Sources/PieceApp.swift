import DesignSystem
import PCFirebase
import PCAmplitude
import LocalStorage
import Router
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import SwiftUI

@main
struct PieceApp: App {
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  
  init() {
    print("app init")

    // Amplitude 초기화
    PCAmplitude.configure()
    
    // Kakao SDK 초기화
    guard let kakaoAppKey = Bundle.main.infoDictionary?["NATIVE_APP_KEY"] as? String else {
      print("Failed to load Kakao App Key")
      return
    }
    KakaoSDK.initSDK(appKey: kakaoAppKey)
    
    // 앱 첫 실행 테스트 시, 아래 주석 해제
    // PCUserDefaultsService.shared.resetFirstLaunch()
    if PCUserDefaultsService.shared.checkFirstLaunch() {
      PCUserDefaultsService.shared.initialize()
      PCUserDefaultsService.shared.setDidSeeOnboarding(false)
      PCKeychainManager.shared.deleteAll()
    }
    
    Task {
      do {
        print("🔥 Firebase RemoteConfig start fetching")
        try await PCFirebase.shared.fetchRemoteConfigValues()
      } catch let error as PCFirebaseError {
        print("🔥 RemoteConfig fetch failed:", error.errorDescription)
      } catch {
        print("🔥 RemoteConfig fetch failed with unknown error:", error)
      }
    }
    
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .preventScreenshot()
        .onOpenURL(perform: { url in
          if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        })
        .onOpenURL { url in
          GIDSignIn.sharedInstance.handle(url)
        }
    }
  }
}
