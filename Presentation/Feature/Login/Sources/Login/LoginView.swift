//
//  LoginView.swift
//  Login
//
//  Created by eunseou on 1/10/25.
//

import SwiftUI
import DesignSystem
import PCFoundationExtension
import UseCases
import Router
import LocalStorage

struct LoginView: View {
  @State var viewModel: LoginViewModel
  
  @Environment(Router.self) private var router: Router
  
  init(
    socialLoginUseCase: SocialLoginUseCase,
    testLoginUseCase: TestLoginUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        socialLoginUseCase: socialLoginUseCase,
        testLoginUseCase: testLoginUseCase
      )
    )
  }
  
  var body: some View {
    ZStack {
      Color.grayscaleWhite.ignoresSafeArea()
      VStack(alignment: .center) {
        VStack(alignment: .leading, spacing: 12) {
          VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
              Text("Piece")
                .foregroundStyle(Color.primaryDefault)
                .contentShape(Rectangle())
                .onTapGesture(count: 5) {
                  viewModel.showTestPasswordAlert = true
                }
              Text("에서 마음이 통하는")
                .foregroundStyle(Color.grayscaleBlack)
            }
            Text("이상형을 만나보세요")
              .foregroundStyle(Color.grayscaleBlack)
          }
          Text("서로의 빈 곳을 채우며 맞물리는 퍼즐처럼.\n서로의 가치관과 마음이 연결되는 순간을 만들어갑니다.")
            .pretendard(.body_S_M)
            .foregroundStyle(Color.grayscaleDark3)
        }
        .padding(.horizontal, 20)
        .pretendard(.heading_L_SB)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer()
        
        DesignSystemAsset.Images.imgLogin.swiftUIImage
          .resizable()
          .frame(maxWidth: .infinity)
        
        Spacer()
        
        VStack(spacing: 10) {
          appleLoginButton
          kakaoLoginButton
          googleLoginButton
        }
        .padding(.horizontal, 20)
      }
      .padding(.bottom, 10)
      .padding(.top, 80)
    }
    .onChange(of: viewModel.destination) { _, newValue in
      guard let newValue else { return }
      router.setRoute(newValue)
    }
    .pcAlert(isPresented: $viewModel.showBannedAlert) {
      AlertView(
        icon: DesignSystemAsset.Icons.notice40.swiftUIImage ,
        title: {
          Text("계정 이용이 영구 제한되었어요")
            .pretendard(.heading_M_SB)
            .foregroundStyle(.grayscaleBlack)
        },
        message: "궁금한 점이 있다면 고객센터로 문의해 주세요.",
        firstButtonText: "문의하기",
        secondButtonText: "종료",
        firstButtonAction: { router.push(to: .settingsWebView(title: "문의하기", uri: viewModel.inquiriesUri)) },
        secondButtonAction: { exit(0) }
      )
    }
    .alert("테스트 로그인 비밀번호를 입력해주세요", isPresented: $viewModel.showTestPasswordAlert) {
      TextField("", text: $viewModel.testPassword)
      Button("확인") {
        viewModel.handleAction(.submitTestLoginPassword)
      }
    } message: {
      Text("Provide test login password")
    }
    .toolbar(.hidden, for: .navigationBar)
  }
  
  private var appleLoginButton: some View {
    loginButton(
      icon: DesignSystemAsset.Icons.apple20.swiftUIImage,
      title: "애플로 시작하기",
      titleColor: .grayscaleWhite,
      backgroundColor: .grayscaleBlack,
      action: { viewModel.handleAction(.tapAppleLoginButton) }
    )
  }
  
  private var kakaoLoginButton: some View {
    loginButton(
      icon: DesignSystemAsset.Icons.kakao20.swiftUIImage,
      title: "카카오로 시작하기",
      titleColor: .grayscaleBlack,
      backgroundColor: Color(hex: 0xFFE812),
      action: { viewModel.handleAction(.tapKakaoLoginButton) }
    )
  }
  
  private var googleLoginButton: some View {
    loginButton(
      icon: DesignSystemAsset.Icons.google20.swiftUIImage,
      title: "구글로 시작하기",
      titleColor: .grayscaleBlack,
      backgroundColor: .grayscaleWhite,
      borderColor: .grayscaleLight1,
      action: { viewModel.handleAction(.tapGoogleLoginButton) }
    )
  }
  
  private func loginButton(
    icon: Image,
    title: String,
    titleColor: Color,
    backgroundColor: Color,
    borderColor: Color? = nil,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      HStack(spacing: 12) {
        icon
        Text(title)
          .pretendard(.body_M_SB)
          .foregroundStyle(titleColor)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
      .background(backgroundColor)
      .cornerRadius(8)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .strokeBorder(borderColor ?? Color.clear, lineWidth: 1)
      )
    }
  }
}

//#Preview {
//  LoginView(viewModel: LoginViewModel())
//}
