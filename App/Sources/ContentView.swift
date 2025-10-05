import Coordinator
import Router
import SwiftUI
import DesignSystem
import Entities
import LocalStorage
import PCNetworkMonitor

struct ContentView: View {
  @State private var router = Router()
  @State private var coordinator = Coordinator()
  @State private var toastManager = PCToastManager()
  @State private var networkMonitor = PCNetworkMonitor()
  
  var body: some View {
    NavigationStack(path: $router.path) {
      RootView(
        coordinator: coordinator,
        initialRoute: router.initialRoute
      )
      .navigationDestination(for: Route.self) { route in
        coordinator.view(for: route)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .environment(router)
    .environment(toastManager)
    .environment(networkMonitor)
    .onReceive(NotificationCenter.default.publisher(for: .deepLink)) { notification in
      guard
        let raw = notification.userInfo?["notificationType"] as? String,
        let notificationType = NotificationType.from(raw: raw),
        let accessToken = PCKeychainManager.shared.read(.accessToken),
        !accessToken.isEmpty
      else {
        router.setRoute(.login)
        return
      }
      handleDeepLink(with: notificationType)
    }
  }
  
  private func handleDeepLink(with type: NotificationType) {
    switch type {
      // 매칭 메인
    case .profileApproved, .matchNew, .matchAccepted, .matchCompleted:
      router.setRoute(.home)
      
      // 프로필 리젝 팝업
    case .profileRejected:
      router.setRoute(.home)
      
      // 프로필 메인 -> 기본 정보 수정
    case .profileImageApproved, .profileImageRejected:
      router.setRoute(.home) {
        postSwitchHomeTab(.profile)
        router.push(to: .editProfile)
      }
    }
  }
  
  private func postSwitchHomeTab(_ tab: HomeViewTab) {
    NotificationCenter.default.post(
      name: .switchHomeTab,
      object: nil,
      userInfo: ["homeViewTab": tab.rawValue]
    )
  }
}

fileprivate struct RootView: View {
  let coordinator: Coordinator
  let initialRoute: Route
  
  var body: some View {
    coordinator.view(for: initialRoute)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
