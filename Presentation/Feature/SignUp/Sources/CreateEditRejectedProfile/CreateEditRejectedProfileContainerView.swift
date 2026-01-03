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
  
  init(
    getProfileBasicUseCase: GetProfileBasicUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase,
    cameraPermissionUseCase: CameraPermissionUseCase,
    photoPermissionUseCase: PhotoPermissionUseCase,
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase,
    getProfileValuePicksUseCase: GetProfileValuePicksUseCase
  ) {
    _viewModel = .init(
      .init(
        getProfileBasicUseCase: getProfileBasicUseCase,
        checkNicknameUseCase: checkNicknameUseCase,
        uploadProfileImageUseCase: uploadProfileImageUseCase,
        cameraPermissionUseCase: cameraPermissionUseCase,
        photoPermissionUseCase: photoPermissionUseCase,
        getProfileValueTalksUseCase: getProfileValueTalksUseCase,
        getProfileValuePicksUseCase: getProfileValuePicksUseCase
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
      }
      .animation(.easeInOut, value: viewModel.currentStep)
    }
    .toolbar(.hidden)
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
    EditRejectedBasicInfoView(
      editRejectedProfileCreator: viewModel.editRejectedProfileCreator,
      getProfileBasicUseCase: viewModel.getProfileBasicUseCase,
      checkNicknameUseCase: viewModel.checkNicknameUseCase,
      uploadProfileImageUseCase: viewModel.uploadProfileImageUseCase,
      cameraPermissionUseCase: viewModel.cameraPermissionUseCase,
      photoPermissionUseCase: viewModel.photoPermissionUseCase,
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
