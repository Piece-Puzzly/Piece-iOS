//
//  IdentifiableAlertModifier.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/28/25.
//

import SwiftUI

public struct IdentifiableAlertModifier<Item: Identifiable, Alert: View>: ViewModifier {
  @Binding var item: Item?
  let alert: (Item) -> Alert
  
  public func body(content: Content) -> some View {
    let isPresented = Binding(
      get: { item != nil },
      set: { if !$0 { item = nil } }
    )
    
    content
      .overlay {
        if let item {
          alert(item)
        }
      }
  }
}

public extension View {
  func pcAlert<Item: Identifiable, Alert: View>(
    item: Binding<Item?>,
    @ViewBuilder alert: @escaping (Item) -> Alert
  ) -> some View {
    return modifier(IdentifiableAlertModifier(item: item, alert: alert))
  }
}
