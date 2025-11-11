//
//  StoreNavigationBar.swift
//  Store
//
//  Created by 홍승완 on 11/4/25.
//

import Router
import SwiftUI
import DesignSystem

struct StoreNavigationBar: View {
  @Environment(Router.self) private var router: Router
  
  private let viewModel: StoreMainViewModel
  
  init(viewModel: StoreMainViewModel) {
    self.viewModel = viewModel
  }
  
  // TODO: - viewModel에서 puzzle 개수 바인딩
  var body: some View {
    HomeNavigationBar(
      foregroundColor: .grayscaleBlack,
      leftButton: { PCPuzzleCount(count: 22, style: .light) },
      leftButtonTap: {
        router.pop()
      }
    )
  }
}
