//
// BlockUserView.swift
// BlockUser
//
// Created by summercat on 2025/02/12.
//

import DesignSystem
import Router
import SwiftUI
import UseCases
import Entities

struct BlockUserView: View {
  @State private var viewModel: BlockUserViewModel
  @Environment(Router.self) private var router
  
  init(
    info: BlockUserInfo,
    blockUserUseCase: BlockUserUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        info: info,
        blockUserUseCase: blockUserUseCase
      )
    )
  }
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "차단하기",
        leftButtonTap: {
          router.pop()
        }
      )
      content
    }
    .frame(maxWidth: .infinity)
    .toolbar(.hidden)
    .pcAlert(isPresented: $viewModel.isBlockUserAlertPresented) {
      AlertView(
        title: {
          Text("\(viewModel.nickname)님을 차단할까요?")
            .pretendard(.heading_M_SB)
            .foregroundStyle(Color.grayscaleBlack)
        },
        message: "차단하면 상대방을 영영 만날 수 없게 되며,\n되돌릴 수 없습니다.",
        firstButtonText: "취소",
        secondButtonText: "차단하기"
      ) {
        viewModel.handleAction(.didTapBlockUserAlertBackButton)
      } secondButtonAction: {
        viewModel.handleAction(.didTapBlockUserAlertBlockUserButton)
      }
    }
    .pcAlert(isPresented: $viewModel.isBlockUserCompleteAlertPresented) {
      AlertView(
        title: {
          Text("\(viewModel.nickname)님을 차단했습니다.")
            .pretendard(.heading_M_SB)
            .foregroundStyle(Color.grayscaleBlack)
        },
        message: "상대방과의 만남이 즉시 종료됩니다.",
        secondButtonText: "홈으로"
      ) {
        viewModel.handleAction(.didTapBlockUserCompleteButton)
        router.popToRoot()
      }
    }
  }
  
  private var content: some View {
    VStack(spacing: 0) {
      title
      list
      Spacer()
      bottomButton
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
  }
  
  private var title: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("\(viewModel.nickname)님을 차단할까요?")
        .pretendard(.heading_L_SB)
        .foregroundStyle(Color.grayscaleBlack)
      
      Text("하단 내용을 확인해 주세요.")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.top, 20)
  }
  
  private var list: some View {
    VStack(spacing: 0) {
      listRow(
        image: DesignSystemAsset.Icons.blockingHeart.swiftUIImage,
        text: "차단하는 즉시\n상대방과의 매칭이 종료됩니다."
      )
      Divider(weight: .normal, isVertical: false)
      
      listRow(
        image: DesignSystemAsset.Icons.blockingPuzzle.swiftUIImage,
        text: "차단된 상대와\n더 이상 매칭되지 않습니다."
      )
      Divider(weight: .normal, isVertical: false)
      
      listRow(
        image: DesignSystemAsset.Icons.blockingAlarm.swiftUIImage,
        text: "상대방에게\n차단한 사실을 알리지 않습니다."
      )
    }
    .padding(.top, 52)
  }
  
  private func listRow(image: Image, text: String) -> some View {
    HStack(alignment: .center, spacing: 12) {
      image
      Text(text)
        .pretendard(.body_M_SB)
        .foregroundStyle(Color.grayscaleBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.vertical, 16)
  }
  
  private var bottomButton: some View {
    RoundedButton(
      type: .solid,
      buttonText: "다음",
      width: .maxWidth
    ) {
      viewModel.handleAction(.didTapBottomButton)
    }
  }
}
//
//#Preview {
//  BlockUserView()
//    .environment(Router())
//}
