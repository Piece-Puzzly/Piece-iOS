//
//  SettingsNotificationSettingSectionView.swift
//  Settings
//
//  Created by summercat on 2/12/25.
//

import SwiftUI

struct SettingsNotificationSettingSectionView: View {
  let title: String
  @Binding var isMatchingNotificationOn: Bool
  @Binding var isPushNotificationOn: Bool

  var body: some View {
    VStack(spacing: 8) {
      SettingsSectionHeaderTitleView(title: title)
      VStack(spacing: 0) {
        SettingsToggleView(title: "매칭 알림", isOn: $isMatchingNotificationOn)
        SettingsToggleView(title: "푸쉬 알림", isOn: $isPushNotificationOn)
      }
    }
  }
}
