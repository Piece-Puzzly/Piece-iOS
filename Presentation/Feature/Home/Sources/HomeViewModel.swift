//
// HomeViewModel.swift
// Home
//
// Created by summercat on 2025/01/30.
//

import DesignSystem
import LocalStorage
import Observation
import UseCases
import Entities

@MainActor
@Observable
final class HomeViewModel {
  enum Action { }
  
  init(
    // initialTab
    selectedTab: HomeViewTab,
    // profile
    getProfileUseCase: GetProfileBasicUseCase,
    // matchmain
    getUserInfoUseCase: GetUserInfoUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase,
    createNewMatchUseCase: CreateNewMatchUseCase,
    checkCanFreeMatchUseCase: CheckCanFreeMatchUseCase,
    postMatchContactsUseCase: PostMatchContactsUseCase,
    getUnreadNotificationCountUseCase: GetUnreadNotificationCountUseCase,
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
  ) {
    // initialTab
    self.selectedTab = selectedTab
    // profile
    self.getProfileUseCase = getProfileUseCase
    // matchmain
    self.getUserInfoUseCase = getUserInfoUseCase
    self.getPuzzleCountUseCase = getPuzzleCountUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.getMatchesInfoUseCase = getMatchesInfoUseCase
    self.getUserRejectUseCase = getUserRejectUseCase
    self.patchMatchesCheckPieceUseCase = patchMatchesCheckPieceUseCase
    self.createNewMatchUseCase = createNewMatchUseCase
    self.checkCanFreeMatchUseCase = checkCanFreeMatchUseCase
    self.postMatchContactsUseCase = postMatchContactsUseCase
    self.getUnreadNotificationCountUseCase = getUnreadNotificationCountUseCase
    // settings
    self.getSettingsInfoUseCase = getSettingsInfoUseCase
    self.fetchTermsUseCase = fetchTermsUseCase
    self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
    self.requestNotificationPermissionUseCase = requestNotificationPermissionUseCase
    self.changeNotificationRegisterStatusUseCase = changeNotificationRegisterStatusUseCase
    self.checkContactsPermissionUseCase = checkContactsPermissionUseCase
    self.requestContactsPermissionUseCase = requestContactsPermissionUseCase
    self.fetchContactsUseCase = fetchContactsUseCase
    self.blockContactsUseCase = blockContactsUseCase
    self.getContactsSyncTimeUseCase = getContactsSyncTimeUseCase
    self.putSettingsNotificationUseCase = putSettingsNotificationUseCase
    self.putSettingsBlockAcquaintanceUseCase = putSettingsBlockAcquaintanceUseCase
    self.patchLogoutUseCase = patchLogoutUseCase
  }
  
  // profile
  let getProfileUseCase: GetProfileBasicUseCase
  // matchmain
  let getUserInfoUseCase: GetUserInfoUseCase
  let getPuzzleCountUseCase: GetPuzzleCountUseCase
  let acceptMatchUseCase: AcceptMatchUseCase
  let getMatchesInfoUseCase: GetMatchesInfoUseCase
  let getUserRejectUseCase: GetUserRejectUseCase
  let patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  let createNewMatchUseCase: CreateNewMatchUseCase
  let checkCanFreeMatchUseCase: CheckCanFreeMatchUseCase
  let postMatchContactsUseCase: PostMatchContactsUseCase
  let getUnreadNotificationCountUseCase: GetUnreadNotificationCountUseCase
  // settings
  let getSettingsInfoUseCase: GetSettingsInfoUseCase
  let fetchTermsUseCase: FetchTermsUseCase
  let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
  let requestNotificationPermissionUseCase: RequestNotificationPermissionUseCase
  let changeNotificationRegisterStatusUseCase: ChangeNotificationRegisterStatusUseCase
  let checkContactsPermissionUseCase: CheckContactsPermissionUseCase
  let requestContactsPermissionUseCase: RequestContactsPermissionUseCase
  let fetchContactsUseCase: FetchContactsUseCase
  let blockContactsUseCase: BlockContactsUseCase
  let getContactsSyncTimeUseCase: GetContactsSyncTimeUseCase
  let putSettingsNotificationUseCase: PutSettingsNotificationUseCase
  let putSettingsBlockAcquaintanceUseCase: PutSettingsBlockAcquaintanceUseCase
  let patchLogoutUseCase: PatchLogoutUseCase
  
  // MARK: - State
  var selectedTab: HomeViewTab
  var isProfileTabDisabled: Bool {
    PCUserDefaultsService.shared.getUserRole() != .USER
  }
}
