//
//  SettingsWebView.swift
//  Settings
//
//  Created by summercat on 2/12/25.
//

import DesignSystem
import Entities
import PCWebView
import SwiftUI

struct SettingsWebView: View {
  @State var viewModel: SettingsWebViewModel
  @Environment(\.dismiss) private var dismiss
  
  init(title: String, uri: String) {
    _viewModel = .init(wrappedValue: .init(title: title, uri: uri))
  }
  
  var body: some View {
    VStack {
      NavigationBar(
        title: viewModel.title,
        leftButtonTap: { viewModel.handleAction(.tapBackButton) }
      )
      
      PCWebView(uri: viewModel.uri)
    }
    .toolbar(.hidden, for: .navigationBar)
    .onAppear {
      viewModel.setDismissAction { dismiss() }
    }
  }
}

#Preview {
  SettingsWebView(
    title: "약관",
    uri: "https://brassy-client-c0a.notion.site/16a2f1c4b966800f923cd499d8e07a97"
  )
}
