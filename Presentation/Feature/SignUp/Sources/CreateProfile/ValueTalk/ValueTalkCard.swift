//
//  ValueTalkCard.swift
//  SignUp
//
//  Created by summercat on 2/9/25.
//

import DesignSystem
import Entities
import SwiftUI

struct ValueTalkCard: View {
  private enum Constants {
    static let minAnswerCount: Int = 30
    static let maxAnswerCount: Int = 300
  }
  
  private var focusState: FocusState<ValueTalkView.Field?>.Binding
  @Binding private var viewModel: ValueTalkCardViewModel

  init(
    viewModel: Binding<ValueTalkCardViewModel>,
    focusState: FocusState<ValueTalkView.Field?>.Binding
  ) {
    self._viewModel = viewModel
    self.focusState = focusState
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      question
      Spacer()
        .frame(height: 20)
      answer
      Spacer()
        .frame(height: 12)
      guide
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
    .padding(.vertical, 24)
    .background(Color.grayscaleWhite)
    .contentShape(Rectangle())
    .onTapGesture {
      focusState.wrappedValue = nil
    }
  }
  
  private var question: some View {
    VStack( alignment: .leading, spacing: 6) {
      category
      title
    }
    .contentShape(Rectangle())
    .onTapGesture {
      focusState.wrappedValue = nil
    }
  }
  
  private var category: some View {
    Text(viewModel.model.category)
      .pretendard(.body_M_M)
      .foregroundStyle(Color.primaryDefault)
  }
  
  private var title: some View {
    Text(viewModel.model.title)
      .pretendard(.heading_M_SB)
      .foregroundStyle(Color.grayscaleDark1)
  }
  
  private var answer: some View {
    VStack(spacing: 16) {
      TextEditor(text: Binding(
        get: { viewModel.localAnswer },
        set: { viewModel.handleAction(.didUpdateAnswer($0)) }
      ))
      .frame(maxWidth: .infinity, minHeight: 96, maxHeight: .infinity)
      .fixedSize(horizontal: false, vertical: true)
      .pretendard(.body_M_M)
      .autocorrectionDisabled()
      .textInputAutocapitalization(.none)
      .scrollContentBackground(.hidden)
      .foregroundStyle(Color.grayscaleBlack)
      .background(alignment: .topLeading) {
        if viewModel.localAnswer.isEmpty && focusState.wrappedValue != .valueTalkEditor(viewModel.model.id) {
          Text(viewModel.model.placeholder)
            .pretendard(.body_M_M)
            .foregroundStyle(Color.grayscaleDark3)
            .padding(.top, 4) // 폰트 내 lineHeight로 인해서 상단이 패딩이 더 커보이는 것 보졍
        }
      }
      .focused(focusState, equals: .valueTalkEditor(viewModel.model.id))
      
      TextCountIndicator(
        count: .constant(viewModel.localAnswer.count),
        minCount: Constants.minAnswerCount,
        maxCount: Constants.maxAnswerCount
      )
      .opacity(!viewModel.localAnswer.isEmpty || focusState.wrappedValue == .valueTalkEditor(viewModel.model.id) ? 1 : 0)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 10) // 폰트 내 lineHeight로 인해서 상단이 패딩이 더 커보이는 것 보졍
    .background(
      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(Color.grayscaleLight3)
    )
  }
  
  private var guide: some View {
    HStack(alignment: .center, spacing: 8) {
      Text("도움말")
        .pretendard(.body_S_R)
        .foregroundStyle(Color.subDefault)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.subLight)
        )
      Text(viewModel.currentGuideText)
        .pretendard(.body_S_R)
        .foregroundStyle(Color.grayscaleDark2)
        .animation(.bouncy(duration: 1), value: viewModel.currentGuideText)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      focusState.wrappedValue = nil
    }
  }
}
