//
//  PCCameraPicker.swift
//  PCImagePicker
//
//  Created by 홍승완 on 7/5/25.
//

import SwiftUI
import Mantis

/// 카메라 기능을 제공하는 SwiftUI 뷰
///
/// 카메라 촬영부터 이미지 크롭까지의 전체 플로우를 관리하며, 상태에 따라 적절한 뷰를 표시합니다.
///
/// ## 사용 예시
/// ```swift
/// PCCameraPicker(
///   onImageSelected: { image in
///     // 촬영 및 크롭 완료된 이미지 처리
///   },
///   onCanceled: {
///     // 취소 처리
///   }
/// )
/// ```
///
/// ## 상태 플로우
/// 1. **Loading**: 카메라 초기화 중 로딩 화면
/// 2. **Camera**: 카메라 촬영 화면
/// 3. **Cropper**: 이미지 크롭(=사진 편집) 화면
/// 4. **Complete/Cancel**: 완료 또는 취소
///
/// - Note: 카메라 권한이 필요합니다.
/// - Warning: 시뮬레이터에서는 카메라 기능이 작동하지 않습니다.
public struct PCCameraPicker: View {
  @Environment(\.dismiss) private var dismiss
  @State private var stateManager: CameraStateManager
  
  let onImageSelected: (UIImage?) -> Void
  let onCanceled: (() -> Void)?
  
  /// - Parameters:
  ///   - onImageSelected: 이미지 촬영 및 크롭 완료 시 호출되는 콜백
  ///   - onCanceled: 카메라 취소 시 호출되는 콜백 (기본값: nil)
  public init(
    onImageSelected: @escaping (UIImage?) -> Void,
    onCanceled: (() -> Void)? = nil
  ) {
    self.onImageSelected = onImageSelected
    self.onCanceled = onCanceled
    self.stateManager = CameraStateManager(state: .loading)
  }
  
  public var body: some View {
    ZStack {
      BackgroundView()
      
      switch stateManager.state {
      case .loading:
        LoadingView()
      case .camera:
        CameraContentView(onCancel: onCanceled)
      case .cropper:
        CropperContentView(onImageCaptured: onImageSelected, onCancel: onCanceled)
      case .complete, .cancel:
        EmptyView()
      }
    }
    .environment(stateManager)
    .onChange(of: stateManager.state, handleStateChange)
  }
  
  private func handleStateChange(_ oldState: CameraState, _ newState: CameraState) {
    switch newState {
    case .complete(let image): handleComplete(with: image)
    case .cancel: handleCancel()
    default: break
    }
  }
  
  private func handleComplete(with image: UIImage?) {
    onImageSelected(image)
    dismiss()
  }
  
  private func handleCancel() {
    onCanceled?()
    dismiss()
  }
}

fileprivate struct BackgroundView: View {
  var body: some View {
    Color.black
      .ignoresSafeArea()
  }
}

fileprivate struct LoadingView: View {
  var body: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle(tint: .white))
  }
}

fileprivate struct CameraContentView: View {
  @Environment(CameraStateManager.self) private var stateManager
  
  let onCancel: (() -> Void)?
  
  var body: some View {
    CameraView(
      onImageCaptured: { stateManager.setCropper(with: $0) },
      onCanceled: { stateManager.setCancel() }
    )
  }
}

fileprivate struct CropperContentView: View {
  @Environment(CameraStateManager.self) private var stateManager
  
  let onImageCaptured: (UIImage?) -> Void
  let onCancel: (() -> Void)?
  
  var body: some View {
    ImageCropperWrapperContainer(
      image: .constant(stateManager.imageToCrop),
      onCompleted: { stateManager.setCompleted(with: $0) },
      onCanceled: { stateManager.setCancel() }
    )
  }
}
