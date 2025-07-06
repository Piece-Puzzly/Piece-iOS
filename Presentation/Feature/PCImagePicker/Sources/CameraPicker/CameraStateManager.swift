//
//  CameraStateManager.swift
//  PCImagePicker
//
//  Created by 홍승완 on 7/6/25.
//

import SwiftUI
import Mantis

enum CameraState: Equatable {
  case loading
  case camera
  case cropper
  case complete(UIImage?)
  case cancel
  
  static func == (lhs: CameraState, rhs: CameraState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading), (.camera, .camera), (.cropper, .cropper), (.cancel, .cancel):
      return true
    case (.complete(let lhsImage), .complete(let rhsImage)):
      return lhsImage == rhsImage
    default:
      return false
    }
  }
}

@Observable
class CameraStateManager {
  var state: CameraState
  var imageToCrop: UIImage?
  
  init(state: CameraState, imageToCrop: UIImage? = nil) {
    self.state = state
    self.imageToCrop = imageToCrop
    
    setCameraReady()
  }
  
  // MARK: 카메라 준비 완료
  private func setCameraReady() {
    Task {
      try? await Task.sleep(for: .milliseconds(100))
      state = .camera
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
