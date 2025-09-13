//
//  View+PCAmplitude.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/11/25.
//

import SwiftUI

public struct PCTrackScreenView: ViewModifier {
  private let id: AnyHashable
  private let screenName: String

  public init(key: AnyHashable? = nil, screenName: String) {
    if let key {
      self.id = key
    } else {
      self.id = AnyHashable(screenName)
    }
    self.screenName = screenName
  }
  
  public func body(content: Content) -> some View {
    content
      .task(id: id) {
        PCAmplitude.screenView(screenName)
      }
  }
}
public struct PCTrackScreenViewEnum<T: PCAmplitudeTrackable>: ViewModifier {
  private let trackable: T
  
  public init(_ trackable: T) {
    self.trackable = trackable
  }
  
  public func body(content: Content) -> some View {
    content
      .task(id: trackable) {
        PCAmplitude.screenView(trackable)
      }
  }
}

public extension View {
  func trackScreen(key: AnyHashable? = nil, screenName: String) -> some View {
    modifier(PCTrackScreenView(key: key, screenName: screenName))
  }
  
  func trackScreen<T: PCAmplitudeTrackable>(_ trackable: T) -> some View {
    modifier(PCTrackScreenViewEnum(trackable))
  }
}
