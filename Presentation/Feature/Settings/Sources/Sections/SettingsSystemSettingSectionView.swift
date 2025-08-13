//
//  SettingsSystemSettingSectionView.swift
//  Settings
//
//  Created by summercat on 2/12/25.
//

import DesignSystem
import SwiftUI

struct SettingsSystemSettingSectionView: View {
  let title: String
  @Binding var isBlockingFriends: Bool
  @Binding var date: String
  @Binding var isSyncingContact: Bool
  let didTapRefreshButton: () -> Void

  var body: some View {
    VStack(spacing: 8) {
      SettingsSectionHeaderTitleView(title: title)
      VStack(spacing: 0) {
        SettingsToggleView(title: "아는 사람 차단", isOn: $isBlockingFriends)
        if isBlockingFriends {
          SettingsSynchronizeContactView(
            title: "연락처 동기화",
            date: $date,
            isSyncingContact: $isSyncingContact,
            didTapRefreshButton: didTapRefreshButton
          )
        }
      }
    }
  }
}
