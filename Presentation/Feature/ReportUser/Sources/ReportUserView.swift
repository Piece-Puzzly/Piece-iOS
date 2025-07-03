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
  @FocusState private var isEditingReportReason: Bool
  @Environment(Router.self) private var router
  @Namespace private var textEditorId
  
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
        }
        .scrollIndicators(.hidden)
        .onChange(of: isEditingReportReason) { _, newValue in
          guard newValue else { return }
          Task {
            try? await Task.sleep(for: .milliseconds(50))
            withAnimation {
              proxy.scrollTo(textEditorId, anchor: .top)
            }
          }
        }
        .padding(.horizontal, 20)
      }
      
      bottomButton
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .toolbar(.hidden)
    .pcAlert(isPresented: $viewModel.showBlockAlert) {
      AlertView(
        title: {
          Text("\(viewModel.nickname)님을\n신고하시겠습니까?")
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
          Text("\(viewModel.nickname)님을 신고했습니다.")
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
    Text("\(viewModel.nickname)님을\n신고하시겠습니까?")
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
      reportItem(reason: reason)
    }
  }
  
  private func reportItem(reason: ReportReason) -> some View {
    HStack(alignment: .center, spacing: 12) {
      PCRadio(isSelected: Binding(
        get: { viewModel.selectedReportReason == reason },
        set: { viewModel.handleAction(.didSelectReportReason($0 ? reason : nil)) }
      ))
      .animation(.easeInOut, value: viewModel.selectedReportReason)
      
      Text(reason.rawValue)
        .pretendard(.body_M_R)
        .foregroundStyle(.grayscaleBlack)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 12)
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
    .id(textEditorId)
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
