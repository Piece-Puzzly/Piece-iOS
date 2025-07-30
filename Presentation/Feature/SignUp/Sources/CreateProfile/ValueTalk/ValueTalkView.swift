//
//  ValueTalkView.swift
//  SignUp
//
//  Created by summercat on 2/8/25.
//

import DesignSystem
import Entities
import SwiftUI
import UseCases

struct ValueTalkView: View {
  enum Field: Hashable {
    case valueTalkEditor(Int)
  }
  
  @Bindable var viewModel: ValueTalkViewModel
  @FocusState private var focusField: Field?
  var didTapBottomButton: () -> Void

  init(
    viewModel: ValueTalkViewModel,
    didTapBottomButton: @escaping () -> Void
  ) {
    self.viewModel = viewModel
    self.didTapBottomButton = didTapBottomButton
  }

  var body: some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          focusField = nil
        }
      
      VStack(spacing: 0) {
        ScrollViewReader { proxy in
          ScrollView {
            content
          }
          .onChange(of: focusField) { _, newValue in
            if case let .valueTalkEditor(id) = newValue {
              withAnimation {
                proxy.scrollTo(id, anchor: .top)
              }
            }
          }
          .overlay(alignment: .bottom) {
            PCToast(
              isVisible: $viewModel.showToast,
              icon: DesignSystemAsset.Icons.notice20.swiftUIImage,
              text: "모든 항목을 작성해 주세요"
            )
            .padding(.bottom, 8)
          }
        }
        
        buttonArea
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

  private var content: some View {
    VStack(spacing: 0) {
      title
      valueTalks
      Spacer()
        .frame(height: 60)
    }
    .frame(maxWidth: .infinity)
  }

  private var title: some View {
    VStack(spacing: 12) {
      Text("가치관 Talk,\n당신의 이야기를 들려주세요")
        .pretendard(.heading_L_SB)
        .foregroundStyle(Color.grayscaleBlack)
        .frame(maxWidth: .infinity, alignment: .leading)

      Text("AI 요약으로 내용을 더 잘 이해할 수 있도록 도와드려요.\n프로필 생성 후, '프로필-가치관 Talk'에서 확인해보세요!")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
        .frame(maxWidth: .infinity, alignment: .leading)

    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
    .padding(.bottom, 16)
  }

  private var valueTalks: some View {
    ForEach(
      Array(zip(viewModel.cardViewModels.indices, viewModel.cardViewModels)),
      id: \.1.model.id
    ) { index, valueTalk in
      ValueTalkCard(
        viewModel: Binding(
        get: { viewModel.cardViewModels[index] },
        set: { viewModel.cardViewModels[index] = $0 }),
        focusState: $focusField
      )
      .id(valueTalk.model.id)
      
      if index < viewModel.valueTalks.count - 1 {
        Divider(weight: .thick, isVertical: false)
      }
    }
  }

  private var buttonArea: some View {
    RoundedButton(
      type: .solid,
      buttonText: "프로필 생성하기",
      width: .maxWidth
    ) {
      viewModel.handleAction(.didTapBottomButton)
      didTapBottomButton()
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .padding(.bottom, 10)
    .background(Color.grayscaleWhite)
  }
}
