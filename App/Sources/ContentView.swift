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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
