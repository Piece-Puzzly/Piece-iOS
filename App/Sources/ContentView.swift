import Coordinator
import Router
import SwiftUI
import DesignSystem

struct ContentView: View {
  @State private var router = Router()
  @State private var coordinator = Coordinator()
  @State private var toastManager = PCToastManager()
  
  var body: some View {
    NavigationStack(path: $router.path) {
      coordinator.view(for: router.initialRoute)
        .id(router.rootViewId)
        .navigationDestination(for: Route.self) { route in
          coordinator.view(for: route)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .environment(router)
    .environment(toastManager)
    .onAppear {
      setupPushNotificationObserver()
    }
  }
  
  // MARK: - 푸쉬 알림 observer 설정
  private func setupPushNotificationObserver() {
    NotificationCenter.default.addObserver(
      forName: .deepLinkHome,
      object: nil,
      queue: .main
    ) { _ in
      print(">>> DEBUG: 🔗 푸쉬 알림으로 홈 이동")
      router.setRoute(.home)
    }
    
    print(">>> DEBUG: ✅ 푸쉬 알림 observer 등록 완료")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
