//
//  CreateEditRejectedProfileContainerView.swift
//  SignUp
//
//  Created by 홍승완 on 8/24/25.
//

import DesignSystem
import Router
import SwiftUI
import UseCases

struct CreateEditRejectedProfileContainerView: View {
  @Namespace private var createBasicInfo
  @Namespace private var valueTalk
  @Namespace private var valuePick
  @Bindable var viewModel: CreateEditRejectedProfileContainerViewModel
  @Environment(Router.self) private var router: Router
  @Environment(\.dismiss) private var dismiss // TODO: - dismiss 동작 확인
  
  private let screenWidth = UIScreen.main.bounds.width
  
  init(
    getProfileBasicUseCase: GetProfileBasicUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase,
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase,
    getProfileValuePicksUseCase: GetProfileValuePicksUseCase
  ) {
    _viewModel = .init(
      .init(
        getProfileBasicUseCase: getProfileBasicUseCase,
        checkNicknameUseCase: checkNicknameUseCase,
        uploadProfileImageUseCase: uploadProfileImageUseCase,
        getProfileValueTalksUseCase: getProfileValueTalksUseCase,
        getProfileValuePicksUseCase: getProfileValuePicksUseCase
      )
    )
  }
  
  var body: some View {
    VStack(spacing: 0) {
      switch viewModel.currentStep {
      case .basicInfo:
        Spacer()
          .frame(height: 60)
      case .valueTalk:
        NavigationBar(
          title: "",
          leftButtonTap: { viewModel.handleAction(.didTapBackButton) }
        )
      case .valuePick:
        NavigationBar(
          title: "",
          leftButtonTap: { viewModel.handleAction(.didTapBackButton) }
        )
      }
      
      pageIndicator
      ZStack {
        basicInfoView
          .transition(.move(edge: .leading))
          .opacity(viewModel.currentStep == .basicInfo ? 1 : 0)
          .disabled(viewModel.currentStep != .basicInfo)
        
        valuePickView
          .transition(.move(edge: .trailing))
          .opacity(viewModel.currentStep == .valuePick ? 1 : 0)
          .disabled(viewModel.currentStep != .valuePick)
        
        valueTalkView
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
          .opacity(viewModel.currentStep == .valueTalk ? 1 : 0)
          .disabled(viewModel.currentStep != .valueTalk)
      }
      .animation(.easeInOut, value: viewModel.currentStep)
    }
    .toolbar(.hidden)
    .onChange(of: viewModel.destination) { _, destination in
      guard let destination else { return }
      router.setRoute(destination)
    }
  }
  
  private var pageIndicator: some View {
    let step = viewModel.currentStep == .basicInfo
    ? PCPageIndicator.IndicatorStep.first
    : viewModel.currentStep == .valuePick ? .second : .third
    
    return PCPageIndicator(
      step: step,
      width: screenWidth
    )
  }
  
  private var basicInfoView: some View {
    EditRejectedBasicInfoView(
      editRejectedProfileCreator: viewModel.editRejectedProfileCreator,
      getProfileBasicUseCase: viewModel.getProfileBasicUseCase,
      checkNicknameUseCase: viewModel.checkNicknameUseCase,
      uploadProfileImageUseCase: viewModel.uploadProfileImageUseCase,
      didTapBottomButton: { viewModel.handleAction(.didTapBottomButton) }
    )
    .id(createBasicInfo)
  }
  
  private var valueTalkView: some View {
    Group {
      if let valueTalkViewModel = viewModel.valueTalkViewModel {
        EditRejectedValueTalkView(
          viewModel: valueTalkViewModel,
          didTapBottomButton: {
            viewModel.handleAction(.didTapBottomButton)
          }
        )
        .id(valueTalk)
      } else {
        EmptyView()
      }
    }
  }
  
  private var valuePickView: some View {
    Group {
      if let valuePickViewModel = viewModel.valuePickViewModel {
        EditRejectedValuePickView(
          viewModel: valuePickViewModel,
          didTapBottomButton: {
            viewModel.handleAction(.didTapBottomButton)
          }
        )
        .id(valuePick)
      } else {
        EmptyView()
      }
    }
  }
}
