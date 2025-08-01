//
// EditValueTalkView.swift
// EditValueTalk
//
// Created by summercat on 2025/02/13.
//

import DesignSystem
import Router
import SwiftUI
import UseCases

struct EditValueTalkView: View {
  enum Field: Hashable {
    case answerEditor(Int)
    case summaryEditor(Int)
  }
  
  @State var viewModel: EditValueTalkViewModel
  @FocusState private var focusField: Field?
  @Environment(Router.self) var router
  
  init(
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase,
    updateProfileValueTalksUseCase: UpdateProfileValueTalksUseCase,
    connectSseUseCase: ConnectSseUseCase,
    disconnectSseUseCase: DisconnectSseUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        getProfileValueTalksUseCase: getProfileValueTalksUseCase,
        updateProfileValueTalksUseCase: updateProfileValueTalksUseCase,
        connectSseUseCase: connectSseUseCase,
        disconnectSseUseCase: disconnectSseUseCase
      )
    )
  }

  var body: some View {
    ZStack {
      Color.clear // 배경 영역 - 탭 시 포커스 해제
        .contentShape(Rectangle())
        .onTapGesture {
          focusField = nil
        }
      
      VStack(spacing: 0) {
        NavigationBar(
          title: viewModel.isEditing ? "가치관 Talk 수정": "가치관 Talk",
          leftButtonTap: { viewModel.handleAction(.didTapBackButton) },
          rightButton: navigationBarRightButton
        )
        
        ScrollViewReader { proxy in
          ScrollView {
            valueTalks
            Spacer()
              .frame(height: 60)
          }
          .onChange(of: focusField) { _, newValue in
            if case let .answerEditor(id) = newValue {
                withAnimation {
                  proxy.scrollTo(id, anchor: .top)
              }
            }
          }
          .scrollIndicators(.hidden)
        }
      }
      .frame(maxHeight: .infinity)
    }
    .background(Color.grayscaleWhite)
    .toolbar(.hidden)
    .pcAlert(isPresented: $viewModel.showValueTalkExitAlert) {
      valueTalkExitAlert
    }
    .onChange(of: viewModel.shouldPopBack) { _, shouldPopBack in
      if shouldPopBack { router.pop() }
    }
    .onChange(of: viewModel.isEditing) { _, isEditing in
      if !isEditing { focusField = nil }
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .onDisappear {
      viewModel.handleAction(.onDisappear)
    }
  }
  
  private var navigationBarRightButton: some View {
    Button {
      viewModel.handleAction(.didTapSaveButton)
      focusField = nil
    } label: {
      Text(viewModel.isEditing ? "저장": "수정")
        .pretendard(.body_M_M)
        .foregroundStyle(
          viewModel.isEditing
          ? (viewModel.isAllAnswerValid ? Color.primaryDefault : Color.grayscaleDark3)
          : Color.primaryDefault)
        .contentShape(Rectangle())
    }
  }
  
  private var valueTalks: some View {
    ForEach(
      Array(viewModel.cardViewModels.enumerated()),
      id: \.1.model.id
    ) { index, cardViewModel in
      EditValueTalkCard(
        viewModel: cardViewModel,
        focusState: $focusField,
        index: cardViewModel.model.id,
        isEditing: viewModel.isEditing
      )
      .id(cardViewModel.model.id)
      
      if index < viewModel.cardViewModels.count - 1 {
        Divider(weight: .thick)
      }
    }
  }
  
  private var valueTalkExitAlert: AlertView<Text> {
    AlertView(
      icon: DesignSystemAsset.Icons.notice40.swiftUIImage,
      title: { Text("작성한 내용이 사라져요!") },
      message: "지금 뒤로 가면 프로필이 저장되지 않아요.\n계속 이어서 작성해 보세요.",
      firstButtonText: "작성 중단하기",
      secondButtonText: "이어서 작성하기",
      firstButtonAction: { viewModel.handleAction(.didTapCancelEditing) },
      secondButtonAction: { viewModel.handleAction(.didTapCloseAlert) }
    )
  }
}
