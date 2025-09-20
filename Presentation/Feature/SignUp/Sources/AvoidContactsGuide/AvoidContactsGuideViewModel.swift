//
//  AvoidContactsGuideViewModel.swift
//  SignUp
//
//  Created by eunseou on 1/17/25.
//

import UseCases
import Entities
import SwiftUI
import PCAmplitude

@MainActor
@Observable
final class AvoidContactsGuideViewModel {
  enum Action {
    case onAppear
    case tapDenyButton
    case tapAcceptButton
    case showSettingAlert
    case cancelAlert
  }
  
  private(set) var showToast = false
  var toastMessage: ToastMessage? = nil
  private(set) var isProcessingShowToast = false
  private(set) var moveToCompleteSignUp: Bool = false
  var isPresentedAlert: Bool = false
  private let requestContactsPermissionUseCase: RequestContactsPermissionUseCase
  private let fetchContactsUseCase: FetchContactsUseCase
  private let blockContactsUseCase: BlockContactsUseCase
  
  init(
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase,
    fetchContactsUseCase: FetchContactsUseCase,
    blockContactsUseCase: BlockContactsUseCase
  ) {
    self.requestContactsPermissionUseCase = requestContactsPermissionUseCase
    self.fetchContactsUseCase = fetchContactsUseCase
    self.blockContactsUseCase = blockContactsUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      initializeState()

    case .tapDenyButton:
      moveToCompleteSignUp = true
      
    case .tapAcceptButton:
      Task {
        await handleAcceptButtonTap()
        
        PCAmplitude.trackButtonClick(
          screenName: .avoidanceIntro,
          buttonName: .avoidanceAllow
        )
      }
      
    case .showSettingAlert:
      openSettings()
      
    case .cancelAlert:
      isPresentedAlert = false
    }
  }
  
  @MainActor
  private func handleAcceptButtonTap() async {
    do {
      let isAuthorized = try await requestContactsPermissionUseCase.execute()
      
      if isAuthorized {
        let userContacts = try await fetchContactsUseCase.execute()
        _ = try await blockContactsUseCase.execute(phoneNumbers: userContacts)
        
        await isToastVisible()
      } else {
        isPresentedAlert = true
      }
    } catch {
      setToastMessage(for: .avoidContactsFailure)
      print("\(error.localizedDescription)")
    }
  }
  
  @MainActor
  private func isToastVisible() async {
    showToast = true
    isProcessingShowToast = true /// Showing Toast
    
    try? await Task.sleep(for: .seconds(2))
    showToast = false
    try? await Task.sleep(for: .seconds(0.3)) // 토스트가 사라지는 애니메이션 이후 화면 전환하기 위함
    
    moveToCompleteSignUp = true /// Hiding Toast
    isProcessingShowToast = false
  }
  
  private func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString),
          UIApplication.shared.canOpenURL(url) else { return }
    
    UIApplication.shared.open(url)
  }
  
  private func initializeState() {
    showToast = false
    moveToCompleteSignUp = false
    isPresentedAlert = false
    isProcessingShowToast = false
  }
}

extension AvoidContactsGuideViewModel {
  enum ToastMessage {
    case avoidContactsFailure
    
    var text: String {
      switch self {
      case .avoidContactsFailure:
        return "연락처 차단에 실패했어요"
      }
    }
  }
  
  var showToastBinding: Binding<Bool> {
    return Binding<Bool>(
      get: { self.toastMessage != nil },
      set: { isVisible in
        if !isVisible { self.toastMessage = nil }
      }
    )
  }
  
  private func setToastMessage(for message: ToastMessage?) {
    self.toastMessage = message
  }
}

