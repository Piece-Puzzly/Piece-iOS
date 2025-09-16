//
//  View+PCAmplitude.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/11/25.
//

import SwiftUI

public struct PCTrackScreenView<T: ProgressTrackable>: ViewModifier {
  private let id: AnyHashable
  private let trackable: T
  private let manager: any AmplitudeProgressManagable
  
  public init(key: AnyHashable? = nil, trackable: T) {
    if let key {
      self.id = key
    } else {
      self.id = AnyHashable(trackable.rawValue)
    }
    self.trackable = trackable
    self.manager = Self.getManager(for: trackable)
  }
  
  public func body(content: Content) -> some View {
    content
      .task(id: id) {
        if manager.shouldTrack(trackable.rawValue) {
          PCAmplitude.trackScreenView(trackable.rawValue)
          manager.updateProgress(trackable.rawValue)
        }
      }
  }
  
  private static func getManager(for trackable: T) -> any AmplitudeProgressManagable {
    switch trackable {
    case is OnboardingProgress:
      return OnboardingProgressManager.shared
      
    case is SignUpProgress:
      return SignUpProgressManager.shared
      
    case is CreateProfileProgress:
      return CreateProfileProgressManager.shared
      
    default:
      return DefaultProgressManager.shared
    }
  }
}

public extension View {
  func trackScreen<T: ProgressTrackable>(key: AnyHashable? = nil, trackable: T) -> some View {
    modifier(PCTrackScreenView(key: key, trackable: trackable))
  }
}
