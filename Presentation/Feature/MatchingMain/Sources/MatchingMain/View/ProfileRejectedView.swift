//
//  ProfileRejectedView.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import DesignSystem
import PCAmplitude

struct ProfileRejectedView: View {
  @Environment(Router.self) private var router: Router
  
  private let viewModel: ProfileRejectedViewModel
  
  init(viewModel: ProfileRejectedViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    Group {
      switch viewModel.viewState {
      case .loading:
        ProfileRejectContentView(
          message: { ProgressView() },
          action: { }
        )
        
      case .success:
        ProfileRejectContentView(
          message: { ProfileRejectMessageView(reason: viewModel.rejectedReason) },
          action: { router.setRoute(.editRejectedProfile) }
        )
      }
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .trackScreen(trackable: DefaultProgress.matchMainProfileRejectPopup)
  }
}


fileprivate struct ProfileRejectContentView<Message: View>: View {
  private let action: () -> Void
  private let message: Message
  
  init(
    @ViewBuilder message: () -> Message,
    action: @escaping () -> Void
  ) {
    self.action = action
    self.message = message()
  }
  
  var body: some View {
    AlertView(
      icon: DesignSystemAsset.Icons.notice40.swiftUIImage,
      title: { Text("프로필을 수정해주세요") },
      message: { messageView },
      secondButtonText: "프로필 수정하기",
      secondButtonAction: { action() }
    )
  }
  
  private var messageView: some View {
    message
      .foregroundColor(.grayscaleDark3)
      .padding(.vertical, 12)
      .frame(maxWidth: .infinity)
      .background(Color.grayscaleLight3)
  }
}

// MARK: - Profile Reject Message View
fileprivate struct ProfileRejectMessageView: View {
  let reason: ProfileRejectedViewModel.ProfileRejectedReason
  
  var body: some View {
    Group {
      switch reason {
      case .all:
        AllRejectMessageView()
        
      case .image:
        ImageRejectMessageView()
        
      case .valueTalk:
        ValueTalkRejectMessageView()
      }
    }
  }
}

// MARK: - Reject Message Components
fileprivate struct AllRejectMessageView: View {
  var body: some View {
    VStack(spacing: 4) {
      ImageRejectMessageView()
      
      ValueTalkRejectMessageView()
    }
  }
}

fileprivate struct ImageRejectMessageView: View {
  var body: some View {
    Text("얼굴이 잘 보이는 사진").foregroundColor(.subDefault) +
    Text("으로 변경해주세요")
  }
}

fileprivate struct ValueTalkRejectMessageView: View {
  var body: some View {
    Text("가치관 talk을 좀 더 ") +
    Text("정성스럽게 ").foregroundStyle(.subDefault) +
    Text("써주세요")
  }
}
