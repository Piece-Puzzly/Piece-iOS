//
//  ProfileRejectedView.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import DesignSystem
import PCAmplitude

struct ProfileRejectedView: View {
  @Environment(Router.self) private var router: Router
  
  private let viewModel: ProfileRejectedViewModel
  
  init(viewModel: ProfileRejectedViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .trackScreen(trackable: DefaultProgress.matchMainProfileRejectPopup)
  }
}
