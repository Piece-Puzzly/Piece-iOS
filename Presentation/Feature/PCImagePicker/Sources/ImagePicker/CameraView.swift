//
//  CameraView.swift
//  ImagePicker
//
//  Created by 홍승완 on 7/5/25.
//

import SwiftUI

/// UIImagePickerController를 SwiftUI에서 사용하기 위한 카메라 래퍼 뷰
///
/// 카메라 기능을 제공하며, 사진 촬영 완료 및 취소 시 콜백을 통해 결과를 전달합니다.
///
/// ## 사용 예시
/// ```swift
/// CameraView(
///   onImageCaptured: { image in
///     // 촬영된 이미지 처리
///   },
///   onCanceled: {
///     // 취소 처리
///   }
/// )
/// ```
///
/// - Note: 이 뷰는 카메라 권한이 필요합니다.
/// - Warning: 시뮬레이터에서는 카메라 기능이 작동하지 않습니다.
struct CameraView: UIViewControllerRepresentable {
  let onImageCaptured: (UIImage) -> Void
  let onCanceled: (() -> Void)
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(onImageCaptured, onCanceled)
  }
}

extension CameraView {
  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let onImageCaptured: (UIImage) -> Void
    let onCanceled: (() -> Void)
    
    init(
      _ onImageCaptured: @escaping (UIImage) -> Void,
      _ onCanceled: @escaping (() -> Void)
    ) {
      self.onImageCaptured = onImageCaptured
      self.onCanceled = onCanceled
    }
    
    // MARK: 사진 촬영 완료 시 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[.originalImage] as? UIImage {
        onImageCaptured(image)
      }
    }
    
    // MARK: 취소 시 호출
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      onCanceled()
    }
  }
}
