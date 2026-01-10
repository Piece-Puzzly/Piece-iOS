//
//  ProfileViewFactory.swift
//  Profile
//
//  Created by summercat on 1/30/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct ProfileViewFactory {
  @ViewBuilder
  public static func createProfileView(
    getProfileUseCase: GetProfileBasicUseCase,
    getUnreadNotificationCountUseCase: GetUnreadNotificationCountUseCase
  ) -> some View {
    ProfileView(
      getProfileUseCase: getProfileUseCase,
      getUnreadNotificationCountUseCase: getUnreadNotificationCountUseCase
    )
      .trackScreen(trackable: DefaultProgress.profileBasic)
  }
}
