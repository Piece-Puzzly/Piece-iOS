//
//  SpinnerModifier.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/30/25.
//

import SwiftUI

public struct SpinnerModifier: ViewModifier {
  let isLoading: Bool
  
  public func body(content: Content) -> some View {
    content
      .overlay {
        if isLoading {
          Color.grayscaleBlack.opacity(0.3)
            .ignoresSafeArea()
          
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .primaryDefault))
            .scaleEffect(2.0)
        }
      }
  }
}

public extension View {
  func spinning(of isLoading: Bool) -> some View {
    modifier(SpinnerModifier(isLoading: isLoading))
  }
}
