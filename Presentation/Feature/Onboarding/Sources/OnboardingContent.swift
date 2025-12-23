//
//  OnboardingContent.swift
//  Onboarding
//
//  Created by summercat on 2/12/25.
//

import SwiftUI
import DesignSystem

struct OnboardingContent {
  let lottie: Lotties?
  let image: Image?
  let title: String
  let buttonTitle: String
  let resetButtonTitle: String?
  
  init(
    lottie: Lotties? = nil,
    image: Image? = nil,
    title: String,
    buttonTitle: String,
    resetButtonTitle: String? = nil
  ) {
    self.lottie = lottie
    self.image = image
    self.title = title
    self.buttonTitle = buttonTitle
    self.resetButtonTitle = resetButtonTitle
  }
  
  static let `default`: [OnboardingContent] = [
    OnboardingContent(
      lottie: .onboarding_basic,
      title: "매일 밤 10시,\n가치관이 맞는 인연을\n이어줘요",
      buttonTitle: "인연을 더 만나려면?"
    ),
    OnboardingContent(
      lottie: .onboarding_premium,
      title: "원한다면, 퍼즐로\n더 많은 인연을\n이어갈 수 있어요",
      buttonTitle: "만남은 어떻게 이루어지나요?"
    ),
    OnboardingContent(
      lottie: .onboarding_greenlight,
      title: "상대가 먼저 다가오면\n‘그린라이트’,\n서로 통하면 만남이 시작돼요",
      buttonTitle: "나와 맞는 인연을 만나려면?"
    ),
    OnboardingContent(
      lottie: .onboarding_talk,
      title: "정성이 담긴 프로필은\n꼭 맞는 인연을 만날\n가능성이 높아요",
      buttonTitle: "안전하게 만나고 싶어요"
    ),
    OnboardingContent(
      image: DesignSystemAsset.Images.onboardingScreenshot.swiftUIImage,
      title: "스크린샷은 제한되어 있으니,\n안심하고 인연을 찾아보세요",
      buttonTitle: "시작할래요!",
      resetButtonTitle: "다시 볼래요"
    ),
  ]
}
