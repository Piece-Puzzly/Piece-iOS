//
//  CreateProfileContainerView.swift
//  SignUp
//
//  Created by summercat on 2/8/25.
//

import DesignSystem
import Router
import SwiftUI
import UseCases
import PCAmplitude

struct CreateProfileContainerView: View {
  @Namespace private var createBasicInfo
  @Namespace private var valueTalk
  @Namespace private var valuePick
  @State var viewModel: CreateProfileContainerViewModel
  @Environment(Router.self) private var router: Router
  
  init(
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase,
    cameraPermissionUseCase: CameraPermissionUseCase,
    getValueTalksUseCase: GetValueTalksUseCase,
    getValuePicksUseCase: GetValuePicksUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        checkNicknameUseCase: checkNicknameUseCase,
        uploadProfileImageUseCase: uploadProfileImageUseCase,
        cameraPermissionUseCase: cameraPermissionUseCase,
        getValueTalksUseCase: getValueTalksUseCase,
        getValuePicksUseCase: getValuePicksUseCase
      )
    )
  }
  
  var body: some View {
    VStack(spacing: 0) {
      navigationBar
      
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
          .trackDuration(action: .valueTalkDuration)
      }
      .animation(.easeInOut, value: viewModel.currentStep)
    }
    .toolbar(.hidden)
    .trackScreen(trackable: viewModel.trackedScreen)
    .onChange(of: viewModel.destination) { _, destination in
      guard let destination else { return }
      router.setRoute(destination)
    }
  }
  
  private var navigationBar: some View {
    NavigationBar(
      title: { pageIndicator },
      leftButtonTap: viewModel.currentStep == .basicInfo
        ? nil
        : { viewModel.handleAction(.didTapBackButton) }
    )
  }
  
  private var pageIndicator: some View {
    let step = viewModel.currentStep == .basicInfo
    ? PCPageIndicator.IndicatorStep.first
    : viewModel.currentStep == .valuePick ? .second : .third
    
    return PCPageIndicator(
      step: step,
      width: UIScreen.main.bounds.width - 154 // 좌우 패딩, 버튼 뺀 네비게이션 titleView 영역
    )
    .animation(.easeInOut(duration: 0.35), value: viewModel.currentStep)
  }
  
  private var basicInfoView: some View {
    CreateBasicInfoView(
      profileCreator: viewModel.profileCreator,
      checkNicknameUseCase: viewModel.checkNicknameUseCase,
      uploadProfileImageUseCase: viewModel.uploadProfileImageUseCase,
      cameraPermissionUseCase: viewModel.cameraPermissionUseCase,
      didTapBottomButton: { viewModel.handleAction(.didTapBottomButton) }
    )
    .id(createBasicInfo)
  }
  
  private var valueTalkView: some View {
    Group {
      if let valueTalkViewModel = viewModel.valueTalkViewModel {
        ValueTalkView(
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
        ValuePickView(
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
