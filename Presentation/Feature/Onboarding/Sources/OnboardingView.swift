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
    VStack {
      topBar
      content
      Spacer()
      
      Pagenation(
        totalCount: viewModel.onboardingContent.count,
        currentIndex: viewModel.contentTabIndex
      )
      bottomButton
    }
    .frame(maxHeight: .infinity)
    .background(Color.grayscaleWhite)
    .toolbar(.hidden)
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .toolbar(.hidden)
    .trackScreen(trackable: viewModel.trackedScreen)
  }
  
  private var topBar: some View {
    HStack(alignment: .center) {
      DesignSystemAsset.Images.typeface.swiftUIImage
      Spacer()
      PCTextButton(content: "건너뛰기")
        .opacity(viewModel.isSkipButtonVisible ? 1 : 0)
        .onTapGesture {
          viewModel.handleAction(.resetProgress)
          router.setRoute(.login)
        }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 20)
    .padding(.vertical, 16)
  }
  
  private var content: some View {
    TabView(selection: $viewModel.contentTabIndex) {
      ForEach(
        Array(viewModel.onboardingContent.enumerated()),
        id: \.offset
      ) { index, content in
        tab(content: content)
          .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
  
  private func tab(content: OnboardingContent) -> some View {
    VStack(alignment: .center) {
      content.image
        .frame(width: 300, height: 300)
      
      VStack(alignment: .leading, spacing: 12) {
        Text(content.title)
          .pretendard(.heading_L_SB)
          .foregroundStyle(Color.grayscaleBlack)
        
        Text(content.description)
          .pretendard(.body_S_M)
          .foregroundStyle(Color.grayscaleDark3)
      }
      .frame(width: 320, alignment: .leading)
    }
    .frame(maxWidth: .infinity)
  }
  
  private var bottomButton: some View {
    RoundedButton(
      type: .solid,
      buttonText: viewModel.isLastTab ? "시작하기" : "다음",
      width: .maxWidth
    ) {
      withAnimation {
        if viewModel.isLastTab {
          viewModel.handleAction(.resetProgress)
          router.setRoute(.login)
        } else {
          viewModel.handleAction(.didTapNextButton)
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .padding(.bottom, 10)
  }
}

#Preview {
  OnboardingView()
    .environment(Router())
}
