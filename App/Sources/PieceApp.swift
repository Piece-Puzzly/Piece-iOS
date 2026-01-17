import PCFirebase
import DesignSystem
import PCAmplitude
import LocalStorage
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import SwiftUI
import PCNetworkMonitor

@main
struct PieceApp: App {
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  
  @State private var networkMonitor = PCNetworkMonitor()
  @State private var remoteGate = RemoteGate()
  @Environment(\.scenePhase) private var scenePhase
  
  init() {
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
      @Bindable var remoteGate = remoteGate
      
      ContentView()
        .preventScreenshot()
        .environment(networkMonitor)
        .onOpenURL(perform: { url in
          if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        })
        .onOpenURL { url in
          GIDSignIn.sharedInstance.handle(url)
        }
        .onChange(of: scenePhase) { _, phase in
          guard phase == .active else { return }
          Task {
            await remoteGate.refresh()
          }
        }
        .pcAlert(isPresented: $remoteGate.showForceUpdate) {
          AlertView(
            title: {
              Text("Piece가 새로운 버전으로\n업데이트되었어요!")
                .pretendard(.heading_M_SB)
                .foregroundStyle(.grayscaleBlack)
            },
            message: "여러분의 의견을 반영하여 사용성을 개선했습니다.\n지금 바로 업데이트해 보세요!",
            secondButtonText: "앱 업데이트하기",
            secondButtonAction: { remoteGate.openAppStore() }
          )
        }
        .pcAlert(isPresented: $remoteGate.showMaintenance) {
          AlertView(
            title: {
              Text("Piece가 잠시 쉬어가요!")
                .pretendard(.heading_M_SB)
                .foregroundStyle(.grayscaleBlack)
            },
            message: { maintenanceMessageView },
            secondButtonText: "닫기",
            secondButtonAction: { exit(0) }
          )
        }
    }
  }
  
  private var maintenanceMessageView: some View {
    VStack(spacing: 12) {
      Text("대규모 업데이트 작업을 진행하고 있어요.\n새롭게 출시될 기능들을 기대해주세요!")
        .foregroundColor(.grayscaleDark2)
        .frame(maxWidth: .infinity)
      
      Group {
        Text("일시 중단 시간: ").foregroundColor(.grayscaleDark3) +
        Text(remoteGate.maintenancePeriod).foregroundStyle(.subDefault)
      }
      .padding(.vertical, 12)
      .frame(maxWidth: .infinity)
      .background(Color.grayscaleLight3)
    }
  }
}
