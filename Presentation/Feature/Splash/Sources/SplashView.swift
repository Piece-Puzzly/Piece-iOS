//
// SplashView.swift
// Splash
//
// Created by summercat on 2025/02/14.
//

import DesignSystem
import Router
import SwiftUI
import UseCases

struct SplashView: View {
  @State var viewModel: SplashViewModel
  @Environment(Router.self) var router
  
  init(getUserInfoUseCase: GetUserInfoUseCase) {
    _viewModel = .init(
      wrappedValue: .init(
        getUserInfoUseCase: getUserInfoUseCase
      )
    )
  }
  
  var body: some View {
    ZStack {
      Color.clear
      
      DesignSystemAsset.Icons.logoCircle3x.swiftUIImage
        .resizable()
        .frame(width: 160, height: 160)
        .toolbar(.hidden)
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .onChange(of: viewModel.destination) { _, destination in
      guard let destination else { return }
      router.setRoute(destination)
    }
    .pcAlert(isPresented: $viewModel.showNeedsForceUpdateAlert) {
      AlertView(
        title: {
          Text("Piece가 새로운 버전으로\n업데이트되었어요!")
            .pretendard(.heading_M_SB)
            .foregroundStyle(.grayscaleBlack)
        },
        message: "여러분의 의견을 반영하여 사용성을 개선했습니다.\n지금 바로 업데이트해 보세요!",
        secondButtonText: "앱 업데이트하기"
      ) {
        viewModel.handleAction(.openAppStore)
      }
    }
    .pcAlert(isPresented: $viewModel.showMaintenanceAlert) {
      AlertView(
        title: {
          Text("Piece가 잠시 쉬어가요!")
            .pretendard(.heading_M_SB)
            .foregroundStyle(.grayscaleBlack)
        },
        message: { maintenanceMessageView },
        secondButtonText: "닫기",
        secondButtonAction: { exit(0) }
      )
    }
    .pcAlert(
      isPresented: $viewModel.showBannedAlert,
      alert: {
        AlertView(
          title: {
            Text("계정 이용이 영구 제한되었습니다.")
              .pretendard(.heading_M_SB)
              .foregroundStyle(.grayscaleBlack)
          },
          message: "궁금한 점이 있다면 고객센터로 문의해주세요.",
          firstButtonText: "문의하기",
          secondButtonText: "종료",
          firstButtonAction: { router.push(to: .settingsWebView(title: "문의하기", uri: viewModel.inquiriesUri)) },
          secondButtonAction: { exit(0) }
        )
      }
    )
  }
  
  private var maintenanceMessageView: some View {
    VStack(spacing: 12) {
      Text("대규모 업데이트 작업을 진행하고 있어요.\n새롭게 출시될 기능들을 기대해주세요!")
        .foregroundColor(.grayscaleDark2)
        .frame(maxWidth: .infinity)
      
      Group {
        Text("일시 중단 시간: ").foregroundColor(.grayscaleDark3) +
        Text("1.NN(N) 08:00 - 09:00").foregroundStyle(.subDefault)
      }
      .padding(.vertical, 12)
      .frame(maxWidth: .infinity)
      .background(Color.grayscaleLight3)
    }
  }
}
