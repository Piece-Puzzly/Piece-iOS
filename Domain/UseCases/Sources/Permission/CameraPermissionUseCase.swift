//
//  CameraPermissionUseCase.swift
//  UseCase
//
//  Created by eunseou on 1/21/25.
//

import Foundation
import AVFoundation

public protocol CameraPermissionUseCase {
  func execute() async -> Bool
  func checkStatus() -> AVAuthorizationStatus
}

public final class CameraPermissionUseCaseImpl: CameraPermissionUseCase {
  private let captureDevice: AVCaptureDevice.Type
  
  public init(captureDevice: AVCaptureDevice.Type = AVCaptureDevice.self) {
    self.captureDevice = captureDevice
  }
  
  public func execute() async -> Bool {
    let status = captureDevice.authorizationStatus(for: .video)
    
    switch status {
    case .authorized:
      return true
    case .denied, .restricted:
      return false
    case .notDetermined:
      return await captureDevice.requestAccess(for: .video)
    @unknown default:
      return false
    }
  }
  
  public func checkStatus() -> AVAuthorizationStatus {
    return captureDevice.authorizationStatus(for: .video)
  }
}
