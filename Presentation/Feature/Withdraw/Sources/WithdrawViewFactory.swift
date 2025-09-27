//
//  WithdrawViewFactory.swift
//  Withdraw
//
//  Created by 김도형 on 2/13/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct WithdrawViewFactory {
    public static func createWithdrawView() -> some View {
        WithdrawView(viewModel: WithdrawViewModel())
        .trackScreen(trackable: DefaultProgress.withdrawalReason)
    }
    
  public static func createWithdrawConfirmView(
    deleteUserAccountUseCase: DeleteUserAccountUseCase,
    appleAuthServiceUseCase: AppleAuthServiceUseCase,
    reason: String
  ) -> some View {
      WithdrawConfirmView(
        deleteUserAccountUseCase: deleteUserAccountUseCase,
        appleAuthServiceUseCase: appleAuthServiceUseCase,
        reason: reason
      )
      .trackScreen(trackable: DefaultProgress.withdrawalConfirm)
    }
}
