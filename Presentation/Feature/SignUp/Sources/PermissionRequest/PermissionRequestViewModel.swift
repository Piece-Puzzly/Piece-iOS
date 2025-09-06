//
//  PermissionRequestViewModel.swift
//  SignUp
//
//  Created by eunseou on 1/15/25.
//

import SwiftUI
import DesignSystem
import Observation
import UseCases
import LocalStorage

@Observable
final class PermissionRequestViewModel {
  enum PermissionAlertType {
    case photo
    case notification
    case contacts
  }
  
  private var alertQueue: [PermissionAlertType] = []
  
  private(set) var isPhotoPermissionGranted: Bool = false
  private(set) var isNotificationPermissionGranted: Bool = false
  private(set) var isContactsPermissionGranted: Bool = false
  private(set) var showToAvoidContactsView: Bool = false
  private(set) var hasCheckedPermissions: Bool = false
  var showPhotoAlert: Bool = false
  var showNotificationAlert: Bool = false
  var showAcquaintanceBlockAlert: Bool = false
  var nextButtonType: RoundedButton.ButtonType {
    isPhotoPermissionGranted ? .solid : .disabled
  }
  private let photoPermissionUseCase: PhotoPermissionUseCase
  private let requestNotificationPermissionUseCase: RequestNotificationPermissionUseCase
  private let requestContactsPermissionUseCase: RequestContactsPermissionUseCase
  
  enum Action {
    case onAppear
    case showShettingAlert
    case tapNextButton
    case cancelAlertRequired
    case cancelAlertOptional
    case requestPermissions
  }
  
  init(
    photoPermissionUseCase: PhotoPermissionUseCase,
    requestNotificationPermissionUseCase: RequestNotificationPermissionUseCase,
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase
  ) {
    self.photoPermissionUseCase = photoPermissionUseCase
    self.requestNotificationPermissionUseCase = requestNotificationPermissionUseCase
    self.requestContactsPermissionUseCase = requestContactsPermissionUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      hasCheckedPermissions = PCUserDefaultsService.shared.getHasRequestedPermissions()
      resetNavigationState()
      
      Task {
        !hasCheckedPermissions
        ? await checkPermissions()
        : await requestPermissionAlerts()
      }

    case .showShettingAlert:
      openSettings()
      
    case .cancelAlertRequired:
      Task { await resetAlertState() }
    
    case .cancelAlertOptional:
      onAlertDismissed()
      
    case .tapNextButton:
      navigateToAvoidContactsView()
      
    case .requestPermissions:
      Task { await requestPermissionAlerts() }
    }
  }
}

// MARK: 네비게이팅
private extension PermissionRequestViewModel {
  func navigateToAvoidContactsView() {
    showToAvoidContactsView = true
  }
  
  func resetNavigationState() {
    showToAvoidContactsView = false
  }
}

private extension PermissionRequestViewModel {
  private func checkPermissions() async {
    await fetchPermissions()
    await updateSettingsAlertState()
  }
  
  private func fetchPermissions() async {
    do {
      isPhotoPermissionGranted = await photoPermissionUseCase.execute()
      isNotificationPermissionGranted = try await requestNotificationPermissionUseCase.execute()
      isContactsPermissionGranted = try await requestContactsPermissionUseCase.execute()
    } catch {
      print("Permission request error: \(error)")
    }
  }
  
  private func requestPermissionAlerts() async {
    await fetchPermissions()
    
    alertQueue.removeAll()
    
    if !isPhotoPermissionGranted {
      alertQueue.append(.photo)
    }
    
    if !isNotificationPermissionGranted {
      alertQueue.append(.notification)
    }
    
    if !isContactsPermissionGranted {
      alertQueue.append(.contacts)
    }
    
    showNextAlert()
  }
  
  private func showNextAlert() {
    guard !alertQueue.isEmpty else { return }
    
    let alertType = alertQueue.removeFirst()
    
    switch alertType {
    case .photo:
      showPhotoAlert = true
    case .notification:
      showNotificationAlert = true
    case .contacts:
      showAcquaintanceBlockAlert = true
    }
  }
  
  private func onAlertDismissed() {
    showNextAlert()
  }
  
  @MainActor
  private func updateSettingsAlertState() async {
    showPhotoAlert = !isPhotoPermissionGranted
  }
  
  @MainActor
  private func resetAlertState() async {
    showPhotoAlert = false
    try? await Task.sleep(nanoseconds: 100_000_000)  // 0.1초 뒤에 설정 창이 뜨도록
    showPhotoAlert = true
  }
  
  private func openSettings() {
    guard let settingUrl = URL(string: UIApplication.openSettingsURLString),
          UIApplication.shared.canOpenURL(settingUrl) else {
      return
    }
    UIApplication.shared.open(settingUrl)
    
    showNextAlert()
  }
}
