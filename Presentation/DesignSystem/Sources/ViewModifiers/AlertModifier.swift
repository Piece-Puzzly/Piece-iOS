//
//  AlertModifier.swift
//  DesignSystem
//
//  Created by summercat on 1/30/25.
//

import SwiftUI

public struct AlertModifier<Title: View, Message: View>: ViewModifier {
  @Binding var isPresented: Bool
  
  let alert: AlertView<Title, Message>
  
  public func body(content: Content) -> some View {
    content
      .overlay {
        if isPresented { alert }
      }
  }
}

public extension View {
  func pcAlert<Title: View, Message: View>(
    isPresented: Binding<Bool>,
    alert: @escaping () -> AlertView<Title, Message>
  ) -> some View {
    return modifier(AlertModifier(isPresented: isPresented, alert: alert()))
  }
}
