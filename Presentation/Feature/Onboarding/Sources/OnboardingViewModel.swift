//
// OnboardingViewModel.swift
// Onboarding
//
// Created by summercat on 2025/02/12.
//

import DesignSystem
import LocalStorage
import Observation
import PCAmplitude

@Observable
final class OnboardingViewModel {
  enum Action {
    case onAppear
    case didTapNextButton
    case resetProgress
    case retryOnboarding
  }
  
  init(progressManager: AmplitudeProgressManagable) {
    self.progressManager = progressManager
  }
  
  private let progressManager: AmplitudeProgressManagable
  
  let onboardingContent = OnboardingContent.default
  
  var contentTabIndex: Int = 0
  
  var isLastTab: Bool {
    contentTabIndex == onboardingContent.count - 1
  }
  
  var trackedScreen: OnboardingProgress {
    return OnboardingProgress.allCases[contentTabIndex]
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      PCUserDefaultsService.shared.setDidSeeOnboarding(true)
      
    case .didTapNextButton:
      contentTabIndex += 1
      
    case .resetProgress:
      progressManager.resetProgress()
      
    case .retryOnboarding:
      contentTabIndex = 0
    }
  }
}
