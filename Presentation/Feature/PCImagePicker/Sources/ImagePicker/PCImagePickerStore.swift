//
//  PCImagePickerStore.swift
//  PCImagePicker
//
//  Created by 홍승완 on 7/6/25.
//

import SwiftUI

public enum ImagePickerSourceType: Identifiable {
  public var id: Self { self }
  
  case camera
  case photoLibrary
}

enum PCImagePickerState: Equatable {
  case loading
  case camera
  case photoLibrary
  case cropper
  case complete(UIImage?)
  case cancel
  
  static func == (lhs: PCImagePickerState, rhs: PCImagePickerState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading), (.camera, .camera), (.photoLibrary, .photoLibrary), (.cropper, .cropper), (.cancel, .cancel):
      return true
    case (.complete(let lhsImage), .complete(let rhsImage)):
      return lhsImage == rhsImage
    default:
      return false
    }
  }
}

@Observable
class PCImagePickerStore {
  let sourceType: ImagePickerSourceType
  var state: PCImagePickerState
  var imageToCrop: UIImage?
  
  init(sourceType: ImagePickerSourceType) {
    self.sourceType = sourceType
    self.state = .loading
    
    initializeSource()
  }
  
  // MARK: 소스 초기화 준비
  private func initializeSource() {
    Task {
      // MARK: (카메라/앨범)으로 화면 전환 시 UI 버벅임 이슈로 Task.sleep 100ms 도입
      try? await Task.sleep(for: .milliseconds(100))
      
      switch sourceType {
      case .camera:
        state = .camera
      case .photoLibrary:
        state = .photoLibrary
      }
    }
  }
  
  // MARK: 사진 편집 with Mantis
  func setCropper(with image: UIImage) {
    imageToCrop = image
    state = .cropper
  }
  
  // MARK: 사진 편집 완료
  func setCompleted(with image: UIImage) {
    state = .complete(image)
  }
  
  // MARK: 사진 촬영 취소 or 사진 편집 취소
  func setCancel() {
    state = .cancel
  }
}
