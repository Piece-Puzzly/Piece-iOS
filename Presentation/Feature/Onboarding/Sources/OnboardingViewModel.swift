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
  }
  
  init(progressManager: AmplitudeProgressManagable) {
    self.progressManager = progressManager
  }
  
  private let progressManager: AmplitudeProgressManagable
  
  let onboardingContent = [
    OnboardingContent(
      image: DesignSystemAsset.Images.imgMatching300.swiftUIImage,
      title: "하루 한 번,\n1:1로 만나는 특별한 인연",
      description: "매일 밤 10시, 새로운 매칭 조각이 도착해요.\n천천히 프로필을 살펴보고, 맞춰볼지 결정해보세요."
    ),
    OnboardingContent(
      image: DesignSystemAsset.Images.imgNoscreenshot.swiftUIImage,
      title: "안심하고\n소중한 만남을 즐기세요",
      description: "스크린샷은 제한되어 있어요.\n오직 이 공간에서만, 편안하게 인연을 찾아보세요."
    ),
  ]
  
  var isSkipButtonVisible = true
  
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
    }
  }
}
