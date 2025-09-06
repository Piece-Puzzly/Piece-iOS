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

@Observable
final class PermissionRequestViewModel {
  private(set) var isPhotoPermissionGranted: Bool = false
  private(set) var isNotificationPermissionGranted: Bool = false
  private(set) var isContactsPermissionGranted: Bool = false
  private(set) var showToAvoidContactsView: Bool = false
  var shouldShowSettingsAlert: Bool = false // 카메라 권한 거절 상태에 설정창으로 보내기 위한 flag
  var nextButtonType: RoundedButton.ButtonType {
    isPhotoPermissionGranted ? .solid : .disabled
  }
  private let photoPermissionUseCase: PhotoPermissionUseCase
  private let requestContactsPermissionUseCase: RequestContactsPermissionUseCase
  private let requestNotificationPermissionUseCase: RequestNotificationPermissionUseCase
  
  enum Action {
    case onAppear
    case showShettingAlert
    case tapNextButton
    case cancelAlert
  }
  
  init(
    photoPermissionUseCase: PhotoPermissionUseCase,
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase,
    requestNotificationPermissionUseCase: RequestNotificationPermissionUseCase
  ) {
    self.photoPermissionUseCase = photoPermissionUseCase
    self.requestContactsPermissionUseCase = requestContactsPermissionUseCase
    self.requestNotificationPermissionUseCase = requestNotificationPermissionUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      resetNavigationState()
      
    case .showShettingAlert:
      openSettings()
      
    case .cancelAlert:
      Task { await resetAlertState() }
      
    case .tapNextButton:
      navigateToAvoidContactsView()
    }
  }
  
  func checkPermissions() async {
    await fetchPermissions()
    await updateSettingsAlertState()
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
  private func fetchPermissions() async {
    do {
      isPhotoPermissionGranted = await photoPermissionUseCase.execute()
      isNotificationPermissionGranted = try await requestNotificationPermissionUseCase.execute()
      isContactsPermissionGranted = try await requestContactsPermissionUseCase.execute()
    } catch {
      print("Permission request error: \(error)")
    }
  }
  
  @MainActor
  private func updateSettingsAlertState() async {
    shouldShowSettingsAlert = !isPhotoPermissionGranted
  }
  
  @MainActor
  private func resetAlertState() async {
    shouldShowSettingsAlert = false
    try? await Task.sleep(nanoseconds: 100_000_000)  // 0.1초 뒤에 설정 창이 뜨도록
    shouldShowSettingsAlert = true
  }
  
  private func openSettings() {
    guard let settingUrl = URL(string: UIApplication.openSettingsURLString),
          UIApplication.shared.canOpenURL(settingUrl) else {
      return
    }
    UIApplication.shared.open(settingUrl)
  }
}
