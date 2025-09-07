//
//  RequestPhotoUseCase.swift
//  UseCases
//
//  Created by eunseou on 2/1/25.
//

import Foundation
import PhotosUI

public protocol PhotoPermissionUseCase {
  func execute() async -> Bool
  func checkStatus() -> PHAuthorizationStatus
}

public final class PhotoPermissionUseCaseImpl: PhotoPermissionUseCase {
  
  public init() { }
  
  public func execute() async -> Bool {
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    switch status {
    case .notDetermined:
      return await requestAuthorization()
    case .restricted, .denied:
      return false
    case .authorized, .limited:
      return true
    @unknown default:
      return false
    }
  }
  
  public func checkStatus() -> PHAuthorizationStatus {
    return PHPhotoLibrary.authorizationStatus(for: .readWrite)
  }
  
  private func requestAuthorization() async -> Bool {
    return await withCheckedContinuation { continuation in
      PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
        switch status {
        case .notDetermined:
          break
        case .restricted, .denied:
          continuation.resume(returning: false)
        case .authorized, .limited:
          continuation.resume(returning: true)
        @unknown default:
          continuation.resume(returning: false)
        }
      }
    }
  }
}
