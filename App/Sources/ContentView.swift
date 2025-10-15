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
  
  @State private var hasEmptyView: Bool = false
  
  @State private var overlayWindow: UIWindow?
  
  @Environment(PCNetworkMonitor.self) var networkMonitor
  
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
    .onChange(of: networkMonitor.isConnected) { _, isConnected in
      if !isConnected {
        showOverlayWindow()
      }
    }
  }
  
  private func showOverlayWindow(animated: Bool = true) {
    guard let scene = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene }).first else { return }
    
    let window = UIWindow(windowScene: scene)
    window.windowLevel = .alert + 1000  // 모든 모달보다 위
    window.backgroundColor = .clear
    window.rootViewController = UIHostingController(rootView:
      NetworkErrorView {
        Task {
          guard hasEmptyView else { return }
          await MainActor.run {
            withAnimation(.none) {
              router.pop()
            }
            hasEmptyView = false
          }
          try? await Task.sleep(nanoseconds: 1_000_000_000)
          await MainActor.run {
            hideOverlayWindow()
          }
        }
      }
      .environment(networkMonitor)
    )
    window.alpha = 0
    window.isHidden = false
    window.makeKeyAndVisible()
    overlayWindow = window
    
    UIView.animate(withDuration: 0.28, delay: 0, options: [.curveEaseInOut]) {
      window.alpha = 1
    }
    
    Task {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      await MainActor.run {
        router.push(to: .empty)
        hasEmptyView = true
      }
    }
  }

  private func hideOverlayWindow() {
    guard let window = overlayWindow else { return }
    
    UIView.animate(withDuration: 0.28, delay: 0, options: [.curveEaseInOut], animations: {
      window.alpha = 0
    }, completion: { _ in
      overlayWindow?.isHidden = true
      overlayWindow = nil
      hasEmptyView = false
    })
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
