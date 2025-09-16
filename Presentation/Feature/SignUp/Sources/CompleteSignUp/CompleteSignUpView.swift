//
//  CompleteSignUpView.swift
//  SignUp
//
//  Created by eunseou on 2/15/25.
//

import SwiftUI
import DesignSystem
import Router
import PCAmplitude

struct CompleteSignUpView: View {
 // @State var viewModel: CompleteSignUpViewModel
  @Environment(Router.self) private var router: Router
  
  var body: some View {
    VStack(alignment: .center) {
      title
      
      PCLottieView(
        .piece_logo_wide,
        loopMode: .playOnce
      )
      
      Spacer()
      
      nextButton
    }
    .padding([.horizontal, .top], 20)
    .padding(.bottom, 10)
    .toolbar(.hidden, for: .navigationBar)
  }
  
  private var title: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Piece")
        .foregroundStyle(Color.primaryDefault) +
      Text("에 가입하신 것을\n환영해요")
    }
    .pretendard(.heading_L_SB)
    .foregroundStyle(Color.grayscaleBlack)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.bottom, 60)
    .padding(.top,60)
  }
  
  private var nextButton: some View {
    RoundedButton(
      type: .solid,
      buttonText: "프로필 생성하기",
      width: .maxWidth,
      action: {
        /// View가 완전히 메모리에서 내려간 후 초기화
        router.setRoute(.createProfile) {
          SignUpProgressManager.shared.resetProgress()
        }
      }
    )
  }
}

//#Preview {
//  CompleteSignUpView()
//}
