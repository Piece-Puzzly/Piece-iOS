//
//  EditValueTalkCard.swift
//  EditValueTalk
//
//  Created by summercat on 2/9/25.
//

import DesignSystem
import Entities
import SwiftUI
import PCFoundationExtension

struct EditValueTalkCard: View {
  private enum Constants {
    static let minAnswerCount: Int = 30
    static let maxAnswerCount: Int = 300
    static let valueTalkMinHeight: Double = 96.0
  }
  
  @Bindable private var viewModel: EditValueTalkCardViewModel
  private var focusState: FocusState<EditValueTalkView.Field?>.Binding
  let id: Int
  let isEditing: Bool
  
  init(
    viewModel: EditValueTalkCardViewModel,
    focusState: FocusState<EditValueTalkView.Field?>.Binding,
    index: Int,
    isEditing: Bool
  ) {
    self.viewModel = viewModel
    self.focusState = focusState
    self.id = index
    self.isEditing = isEditing
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      question
        .contentShape(Rectangle())
        .onTapGesture {
          // 질문 영역 탭 시 포커스 해제
          focusState.wrappedValue = nil
        }
      Spacer()
        .frame(height: 20)
      answer
      if isEditing {
        Spacer()
          .frame(height: 12)
        guide
          .contentShape(Rectangle())
          .onTapGesture {
            // 도움말 영역 탭 시 포커스 해제
            focusState.wrappedValue = nil
          }
      } else {
        Spacer()
          .frame(height: 20)
        summary
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
    .padding(.vertical, 24)
    .background(Color.grayscaleWhite)
    .contentShape(Rectangle())
    .onTapGesture {
      // 카드 전체 영역 탭 시 포커스 해제 (자식 뷰에서 이벤트가 처리되지 않은 경우에만)
      focusState.wrappedValue = nil
    }
  }
  
  private var question: some View {
    VStack( alignment: .leading, spacing: 6) {
      category
      title
    }
  }
  
  private var category: some View {
    Text(viewModel.model.category)
      .pretendard(.body_S_SB)
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
        get: { viewModel.model.answer },
        set: { viewModel.handleAction(.didUpdateAnswer($0)) }
      ))
      .frame(maxWidth: .infinity, minHeight: Constants.valueTalkMinHeight, maxHeight: .infinity)
      .fixedSize(horizontal: false, vertical: true)
      .pretendard(.body_M_M)
      .autocorrectionDisabled()
      .textInputAutocapitalization(.none)
      .scrollContentBackground(.hidden)
      .foregroundStyle(Color.grayscaleBlack)
      .background(alignment: .topLeading) {
        if viewModel.model.answer.isEmpty && focusState.wrappedValue != .answerEditor(id) {
          Text(viewModel.model.placeholder)
            .pretendard(.body_M_M)
            .foregroundStyle(Color.grayscaleDark3)
            .padding(.top, 4)
        }
      }
      .focused(focusState, equals: .answerEditor(id))
      .allowsHitTesting(isEditing) // 편집 모드에서만 탭 가능하도록
      .onTapGesture {
        if isEditing {
          focusState.wrappedValue = .answerEditor(id)
        }
      }
      
      if isEditing {
        TextCountIndicator(
          count: .constant(viewModel.model.answer.count),
          minCount: Constants.minAnswerCount,
          maxCount: Constants.maxAnswerCount
        )
        .opacity(!viewModel.model.answer.isEmpty || focusState.wrappedValue == .answerEditor(viewModel.model.id) ? 1 : 0)
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(
      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(Color.grayscaleLight3)
    )
    .contentShape(Rectangle())
    .onTapGesture {
      // TextEditor 주변 패딩 탭 시 처리
      if isEditing && focusState.wrappedValue != .answerEditor(id) {
        focusState.wrappedValue = .answerEditor(id)
      } else {
        focusState.wrappedValue = nil
      }
    }
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
  }
  
  private var summary: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(alignment: .center, spacing: 4) {
        Text("AI 요약")
          .pretendard(.body_S_SB)
          .foregroundStyle(Color.primaryDefault)
        DesignSystemAsset.Icons.info20.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(
            viewModel.showTooltip
            ? Color.primaryDefault
            : Color.grayscaleDark3
          )
      }
      .frame(width: 65, height: 20)
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation(.easeInOut(duration: 0.3)) {
          viewModel.handleAction(.didTapTooltipButton)
        }
        
        focusState.wrappedValue = nil
      }
      .overlay(alignment: .bottomLeading) {
        DesignSystemAsset.Images.tooltipAiSummary.swiftUIImage
          .opacity(viewModel.showTooltip ? 1 : 0)
          .offset(x: 65, y: 6)
      }
      
      HStack(alignment: .bottom, spacing: 4) {
        if case .generatingAISummary = viewModel.editingState {
          Text("작성해주신 내용을 AI가 요약하고 있어요")
            .pretendard(.body_M_M)
            .foregroundStyle(.grayscaleDark2)
          PCLottieView(.refresh)
          Spacer()
        } else {
          let summaryBinding = Binding<String>(
            get: { viewModel.localSummary },
            set: { viewModel.handleAction(.didUpdateSummary($0)) }
          )
          TextField(
            "",
            text: summaryBinding,
            axis: .vertical
          )
          .maxLength(text: summaryBinding, 50)
          .disabled(viewModel.editingState != .editingSummary)
          .pretendard(.body_M_M)
          .autocorrectionDisabled()
          .textInputAutocapitalization(.none)
          .foregroundStyle(viewModel.editingState == .generatingAISummary ? Color.grayscaleDark2 : Color.grayscaleBlack)
          .focused(focusState, equals: .summaryEditor(id))
          .allowsHitTesting(viewModel.editingState == .editingSummary)
          .onTapGesture {
            if viewModel.editingState == .editingSummary {
              focusState.wrappedValue = .summaryEditor(id)
            } else {
              focusState.wrappedValue = nil
            }
          }
          
          summaryButton
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .foregroundStyle(Color.primaryLight)
      )
      .contentShape(Rectangle())
      .onTapGesture {
        // 요약 영역 배경 탭 시
        if viewModel.editingState == .editingSummary && focusState.wrappedValue != .summaryEditor(id) {
          focusState.wrappedValue = .summaryEditor(id)
        } else {
          focusState.wrappedValue = nil
        }
      }
      
      if case .editingSummary = viewModel.editingState {
        TextCountIndicator(count: .constant(viewModel.localSummary.count), maxCount: 50)
          .frame(maxWidth: .infinity, alignment: .trailing)
          .contentShape(Rectangle())
          .onTapGesture {
            focusState.wrappedValue = nil
          }
      }
    }
  }
  
  @ViewBuilder
  private var summaryButton: some View {
    Button {
      focusState.wrappedValue = nil // 버튼 탭 시 포커스 해제
      viewModel.handleAction(.didTapSummaryButton)
    } label: {
      switch viewModel.editingState {
      case .viewing:
        DesignSystemAsset.Icons.pencilFill24.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(Color.primaryDefault)
        
      case .editingAnswer:
        EmptyView()
        
      case .editingSummary:
        DesignSystemAsset.Icons.check24.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(Color.primaryDefault)
        
      case .generatingAISummary:
        EmptyView()
      }
    }
    .disabled(viewModel.editingState == .generatingAISummary)
  }
}
