//
//  HomeViewFactory.swift
//  Home
//
//  Created by summercat on 1/30/25.
//

import SwiftUI
import UseCases
import Entities

public struct HomeViewFactory {
  @ViewBuilder
  public static func createHomeView(
    // initialTab
    selectedTab: HomeViewTab,
    // profile
    getProfileUseCase: GetProfileBasicUseCase,
    // matchMain
    getUserInfoUseCase: GetUserInfoUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase,
    // settings
    getSettingsInfoUseCase: GetSettingsInfoUseCase,
    fetchTermsUseCase: FetchTermsUseCase,
    checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase,
    requestNotificationPermissionUseCase: RequestNotificationPermissionUseCase,
    changeNotificationRegisterStatusUseCase: ChangeNotificationRegisterStatusUseCase,
    checkContactsPermissionUseCase: CheckContactsPermissionUseCase,
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase,
    fetchContactsUseCase: FetchContactsUseCase,
    blockContactsUseCase: BlockContactsUseCase,
    getContactsSyncTimeUseCase: GetContactsSyncTimeUseCase,
    putSettingsNotificationUseCase: PutSettingsNotificationUseCase,
    putSettingsBlockAcquaintanceUseCase: PutSettingsBlockAcquaintanceUseCase,
    patchLogoutUseCase: PatchLogoutUseCase
  ) -> some View {
    HomeView(
      // initialTab
      selectedTab: selectedTab,
      // profile
      getProfileUseCase: getProfileUseCase,
      // matchMain
      getUserInfoUseCase: getUserInfoUseCase,
      getPuzzleCountUseCase: getPuzzleCountUseCase,
      acceptMatchUseCase: acceptMatchUseCase,
      getMatchesInfoUseCase: getMatchesInfoUseCase,
      getUserRejectUseCase: getUserRejectUseCase,
      patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase,
      // settings
      getSettingsInfoUseCase: getSettingsInfoUseCase,
      fetchTermsUseCase: fetchTermsUseCase,
      checkNotificationPermissionUseCase: checkNotificationPermissionUseCase,
      requestNotificationPermissionUseCase: requestNotificationPermissionUseCase,
      changeNotificationRegisterStatusUseCase: changeNotificationRegisterStatusUseCase,
      checkContactsPermissionUseCase: checkContactsPermissionUseCase,
      requestContactsPermissionUseCase: requestContactsPermissionUseCase,
      fetchContactsUseCase: fetchContactsUseCase,
      blockContactsUseCase: blockContactsUseCase,
      getContactsSyncTimeUseCase: getContactsSyncTimeUseCase,
      putSettingsNotificationUseCase: putSettingsNotificationUseCase,
      putSettingsBlockAcquaintanceUseCase: putSettingsBlockAcquaintanceUseCase,
      patchLogoutUseCase: patchLogoutUseCase
    )
  }
}
