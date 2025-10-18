//
//  NetworkErrorWindowManager.swift
//  Piece-iOS
//
//  Created by 홍승완 on 10/18/25.
//  Copyright © 2025 puzzly. All rights reserved.
//

import SwiftUI
import PCNetworkMonitor
import Router
import DesignSystem
import Combine

@MainActor
final class NetworkErrorWindowManager: NetworkErrorWindowManagable {
  
  // MARK: - Properties
  private var router: Router?
  private var networkMonitor: PCNetworkMonitor?
  private var overlayWindow: UIWindow?
  private var hasEmptyView: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  
  private var currentWindowScene: UIWindowScene? {
    UIApplication.shared
   .connectedScenes
   .compactMap({ $0 as? UIWindowScene }).first
  }
  
  // MARK: - NetworkErrorWindowManagable
  func configure(
    router: Router,
    networkMonitor: PCNetworkMonitor
  ) {
    self.router = router
    self.networkMonitor = networkMonitor
    
    startNetworkMonitoring()
  }
  
  // MARK: - Network Monitoring
  private func startNetworkMonitoring() {
    guard let networkMonitor else { return }
    
    networkMonitor.connectionPublisher
      .receive(on: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] isConnected in
        guard let self else { return }
        if !isConnected && !self.hasEmptyView {
          self.showOverlayWindow()
        }
      }
      .store(in: &cancellables)
  }
  
  private func showOverlayWindow() {
    guard !hasEmptyView,
          let scene = currentWindowScene else { return }
    
    let window = createOverlayWindow(scene: scene)
    setupWindowAnimation(window: window)
    triggerViewRefresh()
  }
  
  private func hideOverlayWindow() {
    UIView.animate(
      withDuration: 0.28,
      delay: 0,
      options: [.curveEaseInOut],
      animations: { self.overlayWindow?.alpha = 0 }
    ) { _ in
      self.overlayWindow?.isHidden = true
      self.overlayWindow = nil
      self.hasEmptyView = false
    }
  }
}
  
// MARK: - Window Creation Helpers
extension NetworkErrorWindowManager {
  private func setupWindowAnimation(window: UIWindow) {
    UIView.animate(
      withDuration: 0.28,
      delay: 0,
      options: [.curveEaseInOut]
    ) {
      window.alpha = 1
    }
  }
  
  private func triggerViewRefresh() {
    Task {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      
      if !self.hasEmptyView {
        self.router?.push(to: .empty)
        self.hasEmptyView = true
      }
    }
  }
  
  private func createOverlayWindow(scene: UIWindowScene) -> UIWindow {
    let window = UIWindow(windowScene: scene)
    window.windowLevel = .alert + 1000
    window.backgroundColor = .clear
    window.rootViewController = UIHostingController(
      rootView: createNetworkErrorView()
    )
    window.alpha = 0
    window.isHidden = false
    window.makeKeyAndVisible()
    overlayWindow = window
    
    return window
  }
}

// MARK: - NetworkErrorView
extension NetworkErrorWindowManager {
  private func createNetworkErrorView() -> some View {
    NetworkErrorView {
      self.handleRetryButtonTap()
    }
    .environment(networkMonitor)
  }

  private func handleRetryButtonTap() {
    Task {
      dismissEmptyView()
      await waitForAnimation()
      hideOverlayWindow()
    }
  }

  private func dismissEmptyView() {
    withAnimation(.none) {
      self.router?.pop()
    }
    self.hasEmptyView = false
  }

  private func waitForAnimation() async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
  }
}
