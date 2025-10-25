//
//  MatchingPendingCardView.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import DesignSystem

struct MatchingPendingCardView: View {
  @Environment(Router.self) private var router: Router
  
  private let viewModel: MatchingHomeViewModel
  
  init(viewModel: MatchingHomeViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(alignment: .center, spacing: 8) {
        Group {
          Text("진중한 만남")
            .foregroundStyle(Color.primaryDefault) +
          Text("을 이어가기 위해\n프로필을 살펴보고 있어요.")
            .foregroundStyle(Color.grayscaleBlack)
        }
        .pretendard(.heading_M_SB)
        
        Text("작성 후 24시간 이내에 심사가 진행돼요.\n푸쉬 알림을 켜면 결과를 빠르게 확인할 수 있어요.")
          .pretendard(.body_S_M)
          .foregroundStyle(Color.grayscaleDark3)
      }
      .multilineTextAlignment(.center)
      
      Spacer()
      
      DesignSystemAsset.Images.imgScreening.swiftUIImage
      
      Spacer()
      
      RoundedButton(
        type: .solid,
        buttonText: "내 프로필 확인하기",
        width: .maxWidth,
        action: { router.push(to: .previewProfileBasic) }
      )
      .padding(.bottom, 20)
      
    }
    .padding(.horizontal, 20)
    .padding(.top, 50)
    .background(
      Rectangle()
        .fill(Color.grayscaleWhite)
        .cornerRadius(16)
    )
  }
}
