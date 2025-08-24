//
//  EditRejectedValuePickView.swift
//  SignUp
//
//  Created by 홍승완 on 8/24/25.
//

import DesignSystem
import Entities
import SwiftUI
import UseCases

struct EditRejectedValuePickView: View {
  @Bindable var viewModel: EditRejectedValuePickViewModel
  var didTapBottomButton: () -> Void
  
  init(
    viewModel: EditRejectedValuePickViewModel,
    didTapBottomButton: @escaping () -> Void
  ) {
    self.viewModel = viewModel
    self.didTapBottomButton = didTapBottomButton
  }
  
  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        ScrollView {
          content
        }
        .overlay(alignment: .bottom) {
          PCToast(
            isVisible: $viewModel.showToast,
            icon: DesignSystemAsset.Icons.notice20.swiftUIImage,
            text: "모든 항목을 작성해 주세요"
          )
          .padding(.bottom, 8)
        }
        
        buttonArea
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  private var content: some View {
    VStack(alignment: .leading, spacing: 0) {
      title
      valuePicks
      Spacer()
        .frame(height: 60)
    }
    .frame(maxWidth: .infinity)
  }
  
  private var title: some View {
    VStack(spacing: 12) {
      Text("가치관 Pick,\n당신의 연애 취향을 알려주세요")
        .pretendard(.heading_L_SB)
        .foregroundStyle(Color.grayscaleBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text("선택 후에도 언제든 수정할 수 있어요.")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
        .frame(maxWidth: .infinity, alignment: .leading)
      
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
    .padding(.bottom, 16)
  }
  
  private var valuePicks: some View {
    VStack(spacing: 16) {
      ForEach(
        Array(zip(viewModel.valuePicks.indices, viewModel.valuePicks)),
        id: \.1.id
      ) { index, valuePick in
        ValuePickCard(valuePick: valuePick) { model in
          viewModel.handleAction(.updateValuePick(model))
        }
        if index < viewModel.valuePicks.count - 1 {
          Divider(weight: .thick, isVertical: false)
        }
      }
    }
  }
  
  private var buttonArea: some View {
    RoundedButton(
      type: .solid,
      buttonText: "다음",
      width: .maxWidth
    ) {
      viewModel.handleAction(.didTapBottomButton)
      if viewModel.isNextButtonEnabled {
        didTapBottomButton()
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .padding(.bottom, 10)
    .background(Color.grayscaleWhite)
  }
}

