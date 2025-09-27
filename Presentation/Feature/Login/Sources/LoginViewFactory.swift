//
//  LoginViewFactory.swift
//  Login
//
//  Created by eunseou on 2/7/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct LoginViewFactory {
  @ViewBuilder
  public static func createLoginView(
    socialLoginUseCase: SocialLoginUseCase,
    testLoginUseCase: TestLoginUseCase
  ) -> some View {
    LoginView(
      socialLoginUseCase: socialLoginUseCase,
      testLoginUseCase: testLoginUseCase
    )
    .trackScreen(trackable: DefaultProgress.loginIntro)
  }
  
  @ViewBuilder
  public static func createVerifingContactView(
    sendSMSCodeUseCase: SendSMSCodeUseCase,
    verifySMSCodeUseCase: VerifySMSCodeUseCase
  ) -> some View {
    VerifingContactView(
      sendSMSCodeUseCase: sendSMSCodeUseCase,
      verifySMSCodeUseCase: verifySMSCodeUseCase
    )
    .trackScreen(trackable: DefaultProgress.loginPhoneVerify)
  }
}
