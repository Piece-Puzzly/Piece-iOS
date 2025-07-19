//
//  WithdrawConfirmView.swift
//  Withdraw
//
//  Created by 김도형 on 2/13/25.
//

import SwiftUI
import DesignSystem
import PCFoundationExtension
import Router
import UseCases

struct WithdrawConfirmView: View {
  @State var viewModel: WithdrawConfirmViewModel
  @Environment(Router.self)
  private var router: Router
  
  init(
    deleteUserAccountUseCase: DeleteUserAccountUseCase,
    appleAuthServiceUseCase: AppleAuthServiceUseCase,
    reason: String
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        deleteUserAccountUseCase: deleteUserAccountUseCase,
        appleAuthServiceUseCase: appleAuthServiceUseCase,
        withdrawReason: reason
      )
    )
  }
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "탈퇴하기",
        leftButtonTap: { router.pop() }
      )
      
      Rectangle()
        .foregroundStyle(Color.grayscaleLight2)
        .frame(height: 1)
        .padding(.horizontal, 0)
      
      title
        .padding(.top, 20)
        .padding(.horizontal, 20)
      
      DesignSystemAsset.Images.imgLeave.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 300, height: 300)
        .padding(.top, 60)
      
      Spacer()
      
      RoundedButton(
        type: .solid,
        buttonText: "탈퇴할래요",
        width: .maxWidth,
        action: { viewModel.handleAction(.confirmWithdraw) }
      )
      .padding(.horizontal, 20)
      .padding(.vertical, 12)
    }
    .toolbar(.hidden)
    .onChange(of: viewModel.destination) { _, destination in
      guard let destination else { return }
      router.setRoute(destination)
    }
  }
}

private extension WithdrawConfirmView {
  var title: some View {
    HStack {
      VStack(alignment: .leading, spacing: 12) {
        Text("정말 탈퇴하시겠어요?")
          .pretendard(.heading_L_SB)
          .foregroundStyle(.grayscaleBlack)
        
        Text("탈퇴하면 계정과 관련된 모든 정보가 삭제되며\n복구할 수 없습니다.")
          .pretendard(.body_S_M)
          .foregroundStyle(.grayscaleDark3)
      }
      
      Spacer()
    }
  }
}
