//
//  VerifingContactView.swift
//  Login
//
//  Created by eunseou on 1/11/25.
//

import SwiftUI
import DesignSystem
import Router
import UseCases
import PCAmplitude

struct VerifingContactView: View {
  @State var viewModel: VerifingContactViewModel
  @FocusState private var isPhoneNumberFocused: Bool
  @FocusState private var isVerificationCodeFocused: Bool
  
  @Environment(Router.self) private var router: Router
  @Environment(\.scenePhase) private var scenePhase
  
  init(
    sendSMSCodeUseCase: SendSMSCodeUseCase,
    verifySMSCodeUseCase: VerifySMSCodeUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        sendSMSCodeUseCase: sendSMSCodeUseCase,
        verifySMSCodeUseCase: verifySMSCodeUseCase
      )
    )
  }
  
  var body: some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          isPhoneNumberFocused = false
          isVerificationCodeFocused = false
        }
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        Spacer()
          .frame(height: 60)
        
        VStack(alignment: .leading, spacing: 12) {
          Text("휴대폰 번호")
            .foregroundStyle(Color.primaryDefault) +
          Text("로\n인증을 진행해 주세요")
          Text("신뢰도 높은 매칭과 안전한 커뮤니티를 위해\n휴대폰 번호로 인증해 주세요.")
            .pretendard(.body_S_M)
            .foregroundStyle(Color.grayscaleDark3)
        }
        .pretendard(.heading_L_SB)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer()
          .frame(height: 68)
        
        VStack(spacing: 32) {
          PCTextField(
            title: "휴대폰 번호",
            text: $viewModel.phoneNumber,
            focusState: $isPhoneNumberFocused,
            focusField: true
          )
          .infoText("- 없이 숫자만 입력해주세요")
          .withButton(
            RoundedButton(
              type: viewModel.phoneNumberTextfieldButtonType,
              buttonText: viewModel.recivedCertificationNumberButtonText,
              width: .maxWidth,
              action: {
                viewModel.handleAction(.reciveCertificationNumber)
              }
            ),
            width: viewModel.recivedCertificationNumberButtonWidth
          )
          .onChange{ newValue in
            viewModel.phoneNumber = newValue.filter { $0.isNumber }
          }
          .textContentType(.telephoneNumber)
          .keyboardType(.numberPad)
          .disabled(viewModel.isPhoneVerificationCompleted)
          
          if viewModel.showVerificationField {
            PCTextField(
              title: "인증번호",
              text: $viewModel.verificationCode,
              focusState: $isVerificationCodeFocused,
              focusField: true
            )
            .infoText(
              viewModel.verificationFieldInfoText,
              color: viewModel.verrificationFieldInfoTextColor
            )
            .rightText(viewModel.timerText, textColor: .primaryDefault)
            .withButton(
              RoundedButton(
                type: viewModel.verificationCodeTextfieldButtonType,
                buttonText: "확인",
                width: .maxWidth,
                action: {
                  viewModel.handleAction(.checkCertificationNumber)
                }
              )
            )
            .keyboardType(.numberPad)
            .disabled(viewModel.isPhoneVerificationCompleted)
          }
          Spacer()
          
          RoundedButton(
            type: viewModel.nextButtonType,
            buttonText: "다음",
            icon: nil,
            width: .maxWidth,
            action: {
              viewModel.handleAction(.tapNextButton)
              isVerificationCodeFocused = false
            }
          )
        }
        .padding(.bottom, 10)
      }
      .padding(.horizontal, 20)
      .onChange(of: viewModel.tapNextButtonFlag) { _, newValue in
        router.setRoute(.termsAgreement)
      }
      .onChange(of: scenePhase) {
        viewModel.handleAction(.updateScenePhase(scenePhase))
      }
      .ignoresSafeArea(.keyboard)
      .toolbar(.hidden, for: .navigationBar)
    }
    .onChange(of: viewModel.showDuplicatePhoneNumberAlert) { _, isPresented in
      if isPresented {
        PCAmplitude.trackScreenView(DefaultProgress.alreadyRegisteredPopup.rawValue)
      }
    }
    .pcAlert(
      isPresented: $viewModel.showDuplicatePhoneNumberAlert) {
        AlertView(
          icon: DesignSystemAsset.Icons.notice40.swiftUIImage,
          title: {
            Text("\(viewModel.oauthProviderName) 계정으로 가입되어 있어요")
              .pretendard(.heading_M_SB)
              .foregroundStyle(.grayscaleBlack)
          },
          message: "가입하신 수단으로 다시 로그인해 주세요.",
          secondButtonText: "확인",
          secondButtonAction: {
            router.setRoute(.login)
          }
        )
      }
  }
}
//
//#Preview {
//  VerifingContactView(
//    viewModel: VerifingContactViewModel(
//      phoneNumber: "01012345678",
//      verificationCode: ""
//    )
//  )
//}
