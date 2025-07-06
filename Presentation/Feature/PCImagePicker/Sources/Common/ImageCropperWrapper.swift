//
//  ImageCropperWrapper.swift
//  ImagePicker
//
//  Created by 홍승완 on 7/5/25.
//

import SwiftUI
import DesignSystem
import Mantis

/// 이미지 크롭 기능을 SwiftUI에서 사용할 수 있도록 래핑한 컨테이너 뷰
///
/// Mantis 라이브러리를 사용하여 이미지 크롭 기능을 제공하며, 네비게이션 바와 함께 구성됩니다.
///
/// ## 사용 예시
/// ```swift
/// ImageCropperWrapperContainer(
///   image: $selectedImage,
///   onCompleted: { croppedImage in
///     // 크롭 완료 처리
///   },
///   onCanceled: {
///     // 크롭 취소 처리
///   }
/// )
/// ```
///
/// - Note: 이미지는 1:1 비율로 정사각형 크롭이 적용됩니다.
/// - Warning: 이미지가 nil인 경우 빈 크롭 화면이 표시됩니다.
struct ImageCropperWrapperContainer: View {
  @Environment(PCImagePickerStore.self) private var store
  @Binding var image: UIImage?
  
  let onCompleted: (UIImage) -> Void
  let onCanceled: (() -> Void)
  
  /// 초기화
  /// - Parameters:
  ///   - image: 크롭할 이미지 바인딩
  ///   - onCompleted: 크롭 완료 시 호출되는 콜백
  ///   - onCanceled: 크롭 취소 시 호출되는 콜백
  init(
    image: Binding<UIImage?>,
    onCompleted: @escaping (UIImage) -> Void,
    onCanceled: @escaping (() -> Void)
  ) {
    self._image = image
    self.onCompleted = onCompleted
    self.onCanceled = onCanceled
  }
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "사진 편집",
        titleColor: navigationTitleColor,
        leftButtonTap: nil,
        rightButton: EmptyView()
      )
      
      ImageCropperWrapper(
        image: $image,
        onCompleted: onCompleted,
        onCanceled: onCanceled
      )
    }
    .toolbar(.hidden, for: .navigationBar)
  }
  
  private var navigationTitleColor: Color {
    switch store.sourceType {
    case .camera:
      return .white
    case .photoLibrary:
      return .grayscaleBlack
    }
  }
}

fileprivate struct ImageCropperWrapper {
  private let image: UIImage?
  
  let onCompleted: (UIImage) -> Void
  let onCanceled: (() -> Void)
  
  init(
    image: Binding<UIImage?>,
    onCompleted: @escaping (UIImage) -> Void,
    onCanceled: @escaping (() -> Void)
  ) {
    self.image = image.wrappedValue
    self.onCompleted = onCompleted
    self.onCanceled = onCanceled
  }
}

extension ImageCropperWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> CropViewController {
    guard let image else { return CropViewController() }
    
    var config = Mantis.Config()
    config.cropViewConfig.cropShapeType = .roundedRect(radiusToShortSide: 1/6, maskOnly: true)
    config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1.0)
    
    let cropViewController = Mantis.cropViewController(image: image, config: config)
    cropViewController.delegate = context.coordinator
    
    return cropViewController
  }
  
  func updateUIViewController(_ uiViewController: CropViewController, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(onCompleted, onCanceled)
  }
}

extension ImageCropperWrapper {
  class Coordinator: NSObject, CropViewControllerDelegate {
    let onCompleted: (UIImage) -> Void
    let onCanceled: (() -> Void)
    
    init(
      _ onCompleted: @escaping (UIImage) -> Void,
      _ onCanceled: @escaping (() -> Void)
    ) {
      self.onCompleted = onCompleted
      self.onCanceled = onCanceled
    }
    
    // MARK: 사진 편집 완료 시 호출
    func cropViewControllerDidCrop(
      _ cropViewController: Mantis.CropViewController,
      cropped: UIImage,
      transformation: Mantis.Transformation,
      cropInfo: Mantis.CropInfo
    ) {
      onCompleted(cropped)
    }
    
    // MARK: 사진 편집 취소 시 호출
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
      onCanceled()
    }
  }
}
