//
// EditValuePickView.swift
// EditValuePick
//
// Created by summercat on 2025/02/12.
//

import DesignSystem
import Router
import SwiftUI
import UseCases

struct EditValuePickView: View {
  @State var viewModel: EditValuePickViewModel
  @Environment(Router.self) var router: Router
  
  init(
    getProfileValuePicksUseCase: GetProfileValuePicksUseCase,
    updateProfileValuePicksUseCase: UpdateProfileValuePicksUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        getProfileValuePicksUseCase: getProfileValuePicksUseCase,
        updateProfileValuePicksUseCase: updateProfileValuePicksUseCase
      )
    )
  }

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "가치관 Pick",
        leftButtonTap: { viewModel.handleAction(.tapBackButton) },
        rightButton: navigationBarRightButton
      )
      
      ScrollView {
        valuePicks
      }
      .scrollIndicators(.hidden)
    }
    .frame(maxHeight: .infinity)
    .background(Color.grayscaleWhite)
    .toolbar(.hidden)
    .pcAlert(isPresented: $viewModel.showValuePickExitAlert) {
      valuePickExitAlert
    }
    .onChange(of: viewModel.shouldPopBack) { _, shouldPopBack in
      if shouldPopBack { router.pop() }
    }
  }
  
  private var navigationBarRightButton: some View {
    Button {
      viewModel.handleAction(.didTapSaveButton)
    } label: {
      Text(viewModel.isEditing ? "저장": "수정")
        .pretendard(.body_M_M)
        .foregroundStyle(navigationBarRightButtonStyle)
        .contentShape(Rectangle())
    }
  }
  
  private var valuePicks: some View {
    ForEach(
      Array(zip(viewModel.valuePicks.indices, viewModel.valuePicks)),
      id: \.1
    ) { index, valuePick in
      EditValuePickCard(
        valuePick: valuePick,
        isEditing: viewModel.isEditing
      ) { model in
        viewModel.handleAction(.updateValuePick(model))
      }
      if index < viewModel.valuePicks.count - 1 {
        Divider(weight: .thick)
      }
    }
  }
  
  private var valuePickExitAlert: AlertView<Text> {
    AlertView(
      icon: DesignSystemAsset.Icons.notice40.swiftUIImage,
      title: { Text("작성 중인 프로필이 사라져요!") },
      message: "지금 뒤로 가면 프로필이 저장되지 않습니다.\n계속 이어서 작성해 보세요.",
      firstButtonText: "작성 중단하기",
      secondButtonText: "이어서 작성하기",
      firstButtonAction: { viewModel.handleAction(.popBack) },
      secondButtonAction: { viewModel.handleAction(.tapCloseAlert) }
    )
  }
  
  private var navigationBarRightButtonStyle: Color {
    viewModel.isEditing
    ? (viewModel.isEdited ? Color.primaryDefault : Color.grayscaleDark3)
    : Color.primaryDefault
  }
}
