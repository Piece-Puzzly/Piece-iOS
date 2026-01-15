//
// WithdrawView.swift
// Withdraw
//
// Created by 김도형 on 2025/02/13.
//

import SwiftUI
import DesignSystem
import Router

struct WithdrawView: View {
  @Environment(Router.self)
  private var router: Router
  
  @State var viewModel: WithdrawViewModel
  
  @FocusState
  private var focusState: Bool
  @Namespace
  private var textEditorId
  
  init(viewModel: WithdrawViewModel) {
    self.viewModel = viewModel
    UITextView.appearance().textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
      
      ScrollViewReader { proxy in
        ScrollView {
          scrollContent
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, focusState ? 100 : 0)
            .onChange(of: focusState) { _, newValue in
              guard newValue else { return }
              Task {
                try? await Task.sleep(for: .milliseconds(50))
                withAnimation {
                  proxy.scrollTo(textEditorId, anchor: .top)
                }
              }
            }
        }
        .scrollIndicators(.hidden)
      }
      
      RoundedButton(
        type: viewModel.isValid ? .solid : .disabled,
        buttonText: "다음",
        width: .maxWidth,
        action: { router.push(to: .withdrawConfirm(reason: viewModel.withdrawReason)) }
      )
      .padding(.horizontal, 20)
      .padding(.vertical, 12)
    }
    .toolbar(.hidden)
    .onTapGesture {
        focusState = false
    }
    .sheet(isPresented: $viewModel.isReasonSheetPresented) {
      PCBottomSheet<BottomSheetTextItem>(
        isButtonEnabled: Binding(projectedValue: .constant(viewModel.isLocationBottomSheetButtonEnable)),
        items: $viewModel.coupleMadeRouteItems,
        titleText: "헤어짐은 아쉽지만, 축하드려요!",
        subtitleText: "인연을 어디에서 만났는지 알려주세요.",
        buttonText: "다음",
        buttonAction: {
          router.push(to: .withdrawConfirm(reason: viewModel.withdrawReason))
          viewModel.isReasonSheetPresented = false
        },
        onTapRowItem: { viewModel.handleAction(.tapRowItem($0)) }
      )
      .presentationDetents([.height(347)])
    }
  }
}

private extension WithdrawView {
  var scrollContent: some View {
    VStack(alignment: .leading, spacing: 40) {
      title
      
      radioList
    }
  }
  
  var title: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("지금 탈퇴하면\n새로운 인연을 만날 수 없어요")
        .pretendard(.heading_L_SB)
        .foregroundStyle(.grayscaleBlack)
      
      Text("탈퇴하는 이유를 알려주세요.\n반영하여 더 나은 사용자 경험을 제공할게요!")
        .pretendard(.body_S_M)
        .foregroundStyle(.grayscaleDark3)
    }
  }
  
  var radioList: some View {
    VStack(spacing: 0) {
      ForEach(WithdrawType.allCases, id: \.self) { type in
        radioListCell(type: type)
      }
      
      if viewModel.currentWithdraw == .기타 {
        textEditor
      }
    }
  }
  
  func radioListCell(type: WithdrawType) -> some View {
    HStack(spacing: 12) {
      PCRadio(isSelected: Binding(
        get: { viewModel.currentWithdraw == type },
        set: { viewModel.handleAction(.bindingWithdraw($0 ? type : nil)) }
      ))
      
      Text(type.rawValue)
        .foregroundStyle(.grayscaleBlack)
        .pretendard(.body_M_R)
        .padding(.vertical, 14)
      
      Spacer()
    }
  }
  
  @ViewBuilder
  var textEditor: some View {
    VStack(spacing: 16) {
      TextEditor(text: Binding(
        get: { viewModel.editorText ?? "" },
        set: { viewModel.handleAction(.bindingEditorText($0)) }
      ))
      .focused($focusState)
      .autocorrectionDisabled()
      .textInputAutocapitalization(.never)
      .scrollContentBackground(.hidden)
      .foregroundStyle(.grayscaleBlack)
      .background(alignment: .topLeading) {
        if viewModel.editorText?.isEmpty ?? true {
          Text("자유롭게 작성해주세요")
            .foregroundStyle(.grayscaleDark3)
            .padding(.leading, 4)
        }
      }
      .pretendard(.body_M_M)
      
      textCount
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(.grayscaleLight3)
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    .clipped()
    .frame(minHeight: 160)
    .id(textEditorId)
  }
  
  var textCount: some View {
    let count = viewModel.editorText?.count ?? 0
    var text = AttributedString("\(count)")
    text.setAttributes(AttributeContainer([
      .foregroundColor: UIColor(.primaryDefault)
    ]))
    
    return HStack {
      Spacer()
      
      Text(text + "/100")
        .pretendard(.body_S_M)
        .foregroundStyle(.grayscaleDark3)
        .contentTransition(.numericText())
    }
    .opacity(count == 0 ? 0 : 1)
  }
}
