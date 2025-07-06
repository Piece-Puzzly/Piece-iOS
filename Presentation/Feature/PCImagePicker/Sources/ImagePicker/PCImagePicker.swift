//
//  PCImagePicker.swift
//  PCImagePicker
//
//  Created by 홍승완 on 7/5/25.
//

import SwiftUI
import Mantis

/// 통합된 이미지 피커 SwiftUI 뷰
///
/// 카메라 촬영과 앨범 선택을 모두 지원하며, 이미지 크롭까지의 전체 플로우를 관리합니다.
///
/// ## 사용 예시
/// ```swift
/// PCImagePicker(
///   sourceType: .camera, // 또는 .photoLibrary
///   onImageSelected: { image in
///     // 이미지 선택 및 크롭 완료 처리
///   },
///   onCanceled: {
///     // 취소 처리
///   }
/// )
/// ```
///
/// ## 상태 플로우
/// 1. **Loading**: 소스 초기화 중 로딩 화면
/// 2. **Camera/PhotoLibrary**: 카메라 촬영 또는 앨범 선택 화면
/// 3. **Cropper**: 이미지 크롭(=사진 편집) 화면
/// 4. **Complete/Cancel**: 완료 또는 취소
///
/// ## 소스 타입별 특징
/// - **Camera**: 검은색 배경, 흰색 UI 요소
/// - **PhotoLibrary**: 흰색 배경, 검은색 UI 요소
///
/// - Note: 카메라와 사진 라이브러리 권한이 필요합니다.
/// - Warning: 시뮬레이터에서는 카메라 기능이 작동하지 않습니다.
public struct PCImagePicker: View {
  @Environment(\.dismiss) private var dismiss
  @State private var store: PCImagePickerStore
  
  let onImageSelected: (UIImage?) -> Void
  let onCanceled: (() -> Void)?
  
  /// - Parameters:
  ///   - sourceType: 이미지 소스 타입 (카메라 또는 앨범)
  ///   - onImageSelected: 이미지 선택 및 크롭 완료 시 호출되는 콜백
  ///   - onCanceled: 취소 시 호출되는 콜백 (기본값: nil)
  public init(
    sourceType: ImagePickerSourceType,
    onImageSelected: @escaping (UIImage?) -> Void,
    onCanceled: (() -> Void)? = nil
  ) {
    self.onImageSelected = onImageSelected
    self.onCanceled = onCanceled
    self.store = PCImagePickerStore(sourceType: sourceType)
  }
  
  public var body: some View {
    ZStack {
      BackgroundView()
      
      switch store.state {
      case .loading:
        LoadingView()
      case .camera:
        CameraContentView()
      case .photoLibrary:
        PhotoLibraryContentView()
      case .cropper:
        CropperContentView()
      case .complete, .cancel:
        EmptyView()
      }
    }
    .environment(store)
    .onChange(of: store.state, handleStateChange)
  }
  
  private func handleStateChange(_ oldState: PCImagePickerState, _ newState: PCImagePickerState) {
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
  @Environment(PCImagePickerStore.self) private var store
  
  var body: some View {
    backgroundColor
      .ignoresSafeArea()
  }
  
  private var backgroundColor: Color {
    switch store.sourceType {
    case .camera: .black
    case .photoLibrary: .white
    }
  }
}

fileprivate struct LoadingView: View {
  @Environment(PCImagePickerStore.self) private var store
  
  var body: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
  }
  
  private var tintColor: Color {
    switch store.sourceType {
    case .camera: .white
    case .photoLibrary: .black
    }
  }
}

fileprivate struct CameraContentView: View {
  @Environment(PCImagePickerStore.self) private var store
  
  var body: some View {
    CameraView(
      onImageCaptured: { store.setCropper(with: $0) },
      onCanceled: { store.setCancel() }
    )
  }
}

fileprivate struct PhotoLibraryContentView: View {
  @Environment(PCImagePickerStore.self) private var store
  
  var body: some View {
    PhotoLibraryView(
      onImageSelected: { store.setCropper(with: $0) },
      onCanceled: { store.setCancel() }
    )
  }
}

fileprivate struct CropperContentView: View {
  @Environment(PCImagePickerStore.self) private var store
  
  var body: some View {
    ImageCropperWrapperContainer(
      image: .constant(store.imageToCrop),
      onCompleted: { store.setCompleted(with: $0) },
      onCanceled: { store.setCancel() }
    )
  }
}
