//
//  IdentifiableAlertModifier.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/28/25.
//

import SwiftUI

public struct IdentifiableAlertModifier<Item: Identifiable, Title: View, Message: View>: ViewModifier {
  @Binding var item: Item?
  
  let alert: (Item) -> AlertView<Title, Message>
  
  public func body(content: Content) -> some View {
    let isPresented = Binding(
      get: { item != nil },
      set: { if !$0 { item = nil } }
    )
    
    content
      .fullScreenCover(isPresented: isPresented) {
        if let item = item {
          alert(item)
        }
      }
      .transaction { transaction in
        transaction.disablesAnimations = true
      }
  }
}

public extension View {
  func pcAlert<Item: Identifiable, Title: View, Message: View>(
    item: Binding<Item?>,
    alert: @escaping (Item) -> AlertView<Title, Message>
  ) -> some View {
    return modifier(IdentifiableAlertModifier(item: item, alert: alert))
  }
}
