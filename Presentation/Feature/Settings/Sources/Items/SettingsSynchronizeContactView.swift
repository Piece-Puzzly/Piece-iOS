//
//  SettingsSynchronizeContactView.swift
//  Settings
//
//  Created by summercat on 2/12/25.
//

import DesignSystem
import Lottie
import SwiftUI

struct SettingsSynchronizeContactView: View {
  let title: String
  @Binding var date: String
  @Binding var isSyncingContact: Bool
  let didTapRefreshButton: () -> Void

  @State private var showLottie = false
  
  var body: some View {
    HStack {
      VStack(spacing: 8) {
        HStack(spacing: 0) {
          Text(title)
            .pretendard(.heading_S_SB)
          Spacer()
        }
        VStack(spacing: 4) {
          HStack(spacing: 0) {
            Text("내 연락처 목록을 즉시 업데이트합니다.\n연락처에 새로 추가된 지인을 차단할 수 있어요.")
              .pretendard(.caption_M_M)
              .foregroundStyle(Color.grayscaleDark3)
            Spacer()
          }
          HStack(alignment: .center, spacing: 2) {
            DesignSystemAsset.Icons.variant2.swiftUIImage
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundStyle(Color.grayscaleDark3)
            Text("마지막 새로 고침")
              .pretendard(.caption_M_M)
              .foregroundStyle(Color.grayscaleDark3)
            Text(date)
              .pretendard(.caption_M_M)
              .foregroundStyle(Color.grayscaleDark1)
            Spacer()
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        showLottie = true
        didTapRefreshButton()
      } label: {
        if showLottie {
          PCLottieView(
            .refresh,
            loopMode: isSyncingContact ? .loop : .playOnce,
            width: 24,
            height: 24
          ) { completed in // animationDidFinish
            // 애니메이션 사이클이 완료되면 이미지로 전환
            // isSyncingContact로 분기하면 로티 애니메이션이 중간에 끊기기 때문에 위 방식으로 구현함
            if !isSyncingContact && completed {
              showLottie = false
            }
          }
        } else {
          DesignSystemAsset.Icons.refresh24.swiftUIImage
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(Color.grayscaleDark2)
        }
      }
      .onChange(of: isSyncingContact) { _, newValue in
        if newValue {
          // 동기화 시작 시 즉시 로티 표시
          showLottie = true
        }
        // 동기화 완료 시에는 PCLottieView의 animationDidFinish에서 처리
      }
    }
    .padding(.vertical, 16)
  }
}
