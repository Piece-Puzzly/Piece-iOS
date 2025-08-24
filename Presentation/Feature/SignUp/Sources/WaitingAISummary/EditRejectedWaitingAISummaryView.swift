//
//  EditRejectedWaitingAISummaryView.swift
//  SignUp
//
//  Created by 홍승완 on 8/24/25.
//

import DesignSystem
import Entities
import Router
import SwiftUI
import UseCases

struct EditRejectedWaitingAISummaryView: View {
  @State private var viewModel: EditRejectedWaitingAISummaryViewModel
  @Environment(Router.self) private var router
  
  init(
    profile: ProfileModel,
    putProfileUseCase: PutProfileUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        profile: profile,
        putProfileUseCase: putProfileUseCase
      )
    )
  }
  
  var body: some View {
    VStack(alignment: .center) {
      Spacer()
        .frame(height: 60) // NavigationBar만큼 여백
      titleArea
      Spacer()
      lottie
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 20)
    .background(.grayscaleWhite)
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .onChange(of: viewModel.isCreatingSummary) { _, newValue in
      if newValue == false {
        router.setRoute(.completeEditRejectedProfile)
      }
    }
  }
  
  private var titleArea: some View {
    VStack(alignment: .leading, spacing: 12) {
      title
        .pretendard(.heading_L_SB)
      description
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var title: some View {
    Text("작성하신 가치관 Talk을\n").foregroundStyle(.grayscaleBlack) +
    Text("AI가 요약").foregroundStyle(.primaryDefault) +
    Text("하고 있어요").foregroundStyle(.grayscaleBlack)
  }
  
  private var description: some View {
    Text("당신의 생각을 한층 더 매력적으로!\nAI가 정리해 드릴게요")
      .pretendard(.body_S_M)
      .foregroundStyle(.grayscaleDark3)
  }
  
  private var lottie: some View {
    ZStack(alignment: .center) {
      PCLottieView(.aiSummaryLarge)
      Text("잠시만 기다려주세요")
        .pretendard(.body_S_M)
        .foregroundStyle(.grayscaleDark3)
        .offset(y: 50)
    }
  }
}
