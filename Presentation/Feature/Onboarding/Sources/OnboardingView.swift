//
// OnboardingView.swift
// Onboarding
//
// Created by summercat on 2025/02/12.
//

import DesignSystem
import SwiftUI
import Router
import PCAmplitude

struct OnboardingView: View {
  @State var viewModel = OnboardingViewModel(progressManager: OnboardingProgressManager.shared)
  @Environment(Router.self) var router

  var body: some View {
    VStack(spacing: 0) {
      NavigationBarView()
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)

      OnboardingTitleView()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
      
      OnboardingContentView()
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .transition(.opacity)
      
      OnboardingButtonView()
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
    }
    .frame(maxHeight: .infinity, alignment: .leading)
    .background(Color.grayscaleLight3)
    .environment(viewModel)
    .toolbar(.hidden)
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .trackScreen(trackable: viewModel.trackedScreen)
  }
  
  fileprivate struct NavigationBarView: View {
    @Environment(Router.self) var router
    @Environment(OnboardingViewModel.self) var viewModel
    
    var body: some View {
      NavigationBar(
        title: "",
        titleColor: .grayscaleWhite,
        rightButton:
          Button(
            action: {
              viewModel.handleAction(.resetProgress)
              router.setRoute(.login)
            },
            label: {
              DesignSystemAsset.Icons.close32.swiftUIImage
            }
          )
      )
    }
  }
  
  fileprivate struct OnboardingTitleView: View {
    @Environment(OnboardingViewModel.self) var viewModel

    var body: some View {
      VStack(alignment: .leading, spacing: 0) {
        Text(viewModel.onboardingContent[viewModel.contentTabIndex].title)
          .pretendard(.heading_L_SB)
          .foregroundStyle(Color.grayscaleBlack)
      }
    }
  }
  
  fileprivate struct OnboardingContentView: View {
    @Environment(Router.self) var router
    @Environment(OnboardingViewModel.self) var viewModel

    var body: some View {
      VStack(alignment: .center) {
        Spacer()

        if let lottie = viewModel.onboardingContent[viewModel.contentTabIndex].lottie {
          PCLottieView(
            lottie,
            loopMode: .playOnce,
            toProgress: 0.99,
          )
        } else if let image = viewModel.onboardingContent[viewModel.contentTabIndex].image {
          image
            .resizable()
            .scaledToFit()
        }
      }
    }
  }
}

fileprivate struct OnboardingButtonView: View {
  @Environment(Router.self) var router
  @Environment(OnboardingViewModel.self) var viewModel
  
  var body: some View {
    HStack(spacing: 8) {
      if let resetButtonTitle = viewModel.onboardingContent[viewModel.contentTabIndex].resetButtonTitle {
        RoundedButton(
          type: .outline,
          buttonText: resetButtonTitle,
          width: .maxWidth,
          action: {
            withAnimation {
              viewModel.handleAction(.retryOnboarding)
            }
          }
        )
        
        RoundedButton(
          type: .solid,
          buttonText: viewModel.onboardingContent[viewModel.contentTabIndex].buttonTitle,
          width: .maxWidth,
          action: {
            withAnimation {
              viewModel.handleAction(.resetProgress)
              router.setRoute(.login)
            }
          }
        )
      } else {
        RoundedButton(
          type: .solid,
          buttonText: viewModel.onboardingContent[viewModel.contentTabIndex].buttonTitle,
          width: .maxWidth,
          action: {
            withAnimation {
              viewModel.handleAction(.didTapNextButton)
            }
          }
        )
      }
    }
  }
}

#Preview {
  OnboardingView()
    .environment(Router())
}
