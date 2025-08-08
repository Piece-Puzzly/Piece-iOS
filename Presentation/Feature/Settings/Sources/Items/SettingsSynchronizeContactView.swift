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
        didTapRefreshButton()
      } label: {
        if isSyncingContact {
          PCLottieView(
            .refresh,
            loopMode: .loop,
            width: 24,
            height: 24
          )
        } else {
          DesignSystemAsset.Icons.refresh24.swiftUIImage
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(Color.grayscaleDark2)
        }
      }
    }
    .padding(.vertical, 16)
  }
}
