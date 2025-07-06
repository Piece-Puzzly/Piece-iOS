//
//  CameraView.swift
//  ImagePicker
//
//  Created by 홍승완 on 7/5/25.
//

import SwiftUI

/// UIImagePickerController를 SwiftUI에서 사용하기 위한 사진 라이브러리 래퍼 뷰
///
/// 사진 라이브러리에서 이미지를 선택할 수 있으며, 이미지 선택 완료 및 취소 시 콜백을 통해 결과를 전달합니다.
///
/// ## 사용 예시
/// ```swift
/// PhotoLibraryView(
///   onImageSelected: { image in
///     // 선택된 이미지 처리
///   },
///   onCanceled: {
///     // 취소 처리
///   }
/// )
/// ```
///
/// - Note: 이 뷰는 사진 라이브러리 권한이 필요합니다.
/// - Warning: 사진 라이브러리에 접근할 수 없는 경우 선택이 불가능합니다.
struct PhotoLibraryView: UIViewControllerRepresentable {
  let onImageSelected: (UIImage) -> Void
  let onCanceled: (() -> Void)
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(onImageSelected, onCanceled)
  }
}

extension PhotoLibraryView {
  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let onImageSelected: (UIImage) -> Void
    let onCanceled: (() -> Void)
    
    init(
      _ onImageSelected: @escaping (UIImage) -> Void,
      _ onCanceled: @escaping (() -> Void)
    ) {
      self.onImageSelected = onImageSelected
      self.onCanceled = onCanceled
    }
    
    // MARK: 사진 선택 완료 시 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[.originalImage] as? UIImage {
        onImageSelected(image)
      }
    }
    
    // MARK: 취소 시 호출
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      onCanceled()
    }
  }
}
