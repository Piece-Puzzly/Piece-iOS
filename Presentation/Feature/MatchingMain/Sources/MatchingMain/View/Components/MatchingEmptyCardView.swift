//
//  MatchingEmptyCardView.swift
//  MatchingMain
//
//  Created by 홍승완 on 10/25/25.
//

import Router
import SwiftUI
import DesignSystem

struct MatchingEmptyCardView: View {
  @Environment(Router.self) private var router: Router

  var body: some View {
    VStack(spacing: 32) {
      VStack(spacing: 8) {
        Group {
          Text("오늘의 인연").foregroundStyle(Color.primaryDefault) +
          Text("이 곧 도착할 거예요!").foregroundStyle(Color.grayscaleBlack)
        }
        .pretendard(.heading_M_SB)

        Text("내 운명의 상대를 찾을지도 몰라요.\n놓치지 않도록 푸쉬 알림을 켜주세요!")
          .pretendard(.body_S_M)
          .foregroundStyle(Color.grayscaleDark3)
      }
      .multilineTextAlignment(.center)
      
//      Spacer()
      DesignSystemAsset.Images.imgMatching240.swiftUIImage
//      Spacer()
      
      RoundedButton(
        type: .solid,
        buttonText: "내 프로필 확인하기",
        width: .maxWidth,
        action: { router.push(to: .previewProfileBasic) }
      )
    }
    .padding(.horizontal, 20)
    .padding(.top, 50)
    .padding(.bottom, 20)
    .background(
      Rectangle()
        .fill(Color.grayscaleWhite)
        .cornerRadius(12)
    )
  }
}
