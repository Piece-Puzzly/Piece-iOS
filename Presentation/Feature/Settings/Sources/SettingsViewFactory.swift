//
//  SettingsViewFactory.swift
//  Settings
//
//  Created by summercat on 2/12/25.
//

import SwiftUI
import UseCases

public struct SettingsViewFactory {
  public static func createSettingsView(
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
    SettingsView(
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
  
  public static func createSettingsWebView(title: String, uri: String) -> some View {
    SettingsWebView(title: title, uri: uri)
  }
}
