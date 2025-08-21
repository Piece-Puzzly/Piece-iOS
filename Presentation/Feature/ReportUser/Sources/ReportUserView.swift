//
// ReportUserView.swift
// ReportUser
//
// Created by summercat on 2025/02/16.
//

import DesignSystem
import Router
import SwiftUI
import UseCases

struct ReportUserView: View {
  @State private var viewModel: ReportUserViewModel
  @State private var keyboardHeight: CGFloat = 0
  @FocusState private var isEditingReportReason: Bool
  @Environment(Router.self) private var router
  @Namespace private var textEditorId
  
  private let keyboardWillShowNotificationPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
  private let keyboardWillHideNotificationPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
  
  init(nickname: String, reportUserUseCase: ReportUserUseCase) {
    _viewModel = .init(
      wrappedValue: .init(nickname: nickname, reportUserUseCase: reportUserUseCase)
    )
  }

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "신고하기",
        leftButtonTap: { router.pop() }
      )
      
      ScrollViewReader { proxy in
        ScrollView {
          titleArea
          Spacer()
            .frame(height: 40)
          reportReasons
          reportReasonEditor
          Spacer()
            .frame(height: keyboardHeight)
        }
        .scrollIndicators(.hidden)
        .onReceive(keyboardWillShowNotificationPublisher) { notification in
          handleKeyboardWillShow(notification, proxy: proxy)
        }
        .onReceive(keyboardWillHideNotificationPublisher) { _ in
          handleKeyboardWillHide()
        }
        .padding(.horizontal, 20)
      }
      
      bottomButton
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .toolbar(.hidden)
    .onTapGesture {
      isEditingReportReason = false
    }
    .pcAlert(isPresented: $viewModel.showBlockAlert) {
      AlertView(
        title: {
          Text("\(viewModel.nickname)님을 신고할까요?")
        },
        message: "신고하면 되돌릴 수 없으니,\n신중한 신고 부탁드립니다.",
        firstButtonText: "취소",
        secondButtonText: "신고하기",
        firstButtonAction: { viewModel.showBlockAlert = false },
        secondButtonAction: { viewModel.handleAction(.didTapReportButton) }
      )
    }
    .pcAlert(isPresented: $viewModel.showBlockResultAlert) {
      AlertView(
        title: {
          Text("\(viewModel.nickname)님을 신고했어요")
        },
        message: "신고된 내용은 신속하게 검토하여\n조치하겠습니다.",
        secondButtonText: "홈으로",
        secondButtonAction: {
          viewModel.showBlockResultAlert = false
          router.popToRoot()
        }
      )
    }
  }
  
  private var titleArea: some View {
    VStack(spacing: 12) {
      title
      description
    }
    .padding(.top, 20)
  }
  
  private var title: some View {
    Text("\(viewModel.nickname)님을 신고할까요?")
      .pretendard(.heading_L_SB)
      .foregroundStyle(.grayscaleBlack)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var description: some View {
    Text("신고된 내용은 신속하게 검토하여 조치하겠습니다.")
      .pretendard(.body_S_M)
      .foregroundStyle(.grayscaleDark3)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var reportReasons: some View {
    ForEach(viewModel.reportReasons) { reason in
      if reason == .other {
        reportItem(reason: reason)
          .id(textEditorId)
      } else {
        reportItem(reason: reason)
      }
    }
  }
  
  private func reportItem(reason: ReportReason) -> some View {
    HStack(alignment: .center, spacing: 12) {
      PCRadio(isSelected: .constant(viewModel.selectedReportReason == reason))
        .padding(1)
      
      Text(reason.rawValue)
        .pretendard(.body_M_R)
        .foregroundStyle(.grayscaleBlack)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 14)
    .contentShape(Rectangle())
    .onTapGesture {
      viewModel.handleAction(.didSelectReportReason(reason))
      isEditingReportReason = false
    }
  }

  private var reportReasonEditor: some View {
    VStack(spacing: 0) {
      ZStack(alignment: .topLeading) {
        TextEditor(text: Binding(
          get: { viewModel.reportReason },
          set: { viewModel.handleAction(.didUpdateReportReason($0)) }
        ))
        .frame(maxWidth: .infinity, minHeight: 96)
        .pretendard(.body_M_M)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.none)
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
        .foregroundStyle(Color.grayscaleBlack)
        .focused($isEditingReportReason)
        
        if viewModel.reportReason.isEmpty && !isEditingReportReason {
          Text(viewModel.placeholder)
            .pretendard(.body_M_M)
            .foregroundStyle(Color.grayscaleDark3)
            .padding(.top, 4) // 폰트 내 lineHeight로 인해서 상단이 패딩이 더 커보이는 것 보졍
            .allowsHitTesting(false)
        }
      }
      .fixedSize(horizontal: false, vertical: true)
        
      if !viewModel.reportReason.isEmpty || isEditingReportReason {
          TextCountIndicator(count: .constant(viewModel.reportReason.count), maxCount: 100)
        }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 10) // 폰트 내 lineHeight로 인해서 상단이 패딩이 더 커보이는 것 보졍
    .background(
      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(Color.grayscaleLight3)
    )
    .opacity(viewModel.showReportReasonEditor ? 1 : 0)
  }
  
  private var bottomButton: some View {
    RoundedButton(
      type: viewModel.isBottomButtonEnabled ? .solid : .disabled,
      buttonText: "다음",
      width: .maxWidth
    ) {
      viewModel.handleAction(.didTapNextButton)
    }
  }
}

// MARK: Keyboard Notification Func
extension ReportUserView {
  private func handleKeyboardWillShow(_ notification: Notification, proxy: ScrollViewProxy) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
          let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
    let keyBoardAnimation = Animation.easeInOut(duration: duration)
    self.keyboardHeight = keyboardFrame.height
    withAnimation(keyBoardAnimation) {
      proxy.scrollTo(textEditorId, anchor: .top)
    }
  }
  
  private func handleKeyboardWillHide() {
    withAnimation {
      self.keyboardHeight = 0
    }
  }
}
