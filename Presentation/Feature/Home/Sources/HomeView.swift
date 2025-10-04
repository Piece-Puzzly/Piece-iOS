//
// HomeView.swift
// Home
//
// Created by summercat on 2025/01/30.
//

import DesignSystem
import MatchingMain
import Profile
import Router
import Settings
import SwiftUI
import UseCases
import Entities

struct HomeView: View {
  @State private var viewModel: HomeViewModel
  @State private var showProfileToast: Bool = false
  
  init(
    selectedTab: HomeViewTab,
    getProfileUseCase: GetProfileBasicUseCase,
    getUserInfoUseCase: GetUserInfoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase,
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
    _viewModel = .init(
      wrappedValue: .init(
        selectedTab: selectedTab,
        getProfileUseCase: getProfileUseCase,
        getUserInfoUseCase: getUserInfoUseCase,
        acceptMatchUseCase: acceptMatchUseCase,
        getMatchesInfoUseCase: getMatchesInfoUseCase,
        getUserRejectUseCase: getUserRejectUseCase,
        patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase,
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
    )
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      content
      
      PCToast(
        isVisible: $showProfileToast,
        icon: DesignSystemAsset.Icons.notice20.swiftUIImage,
        text: "아직 프로필을 심사하고 있어요"
      )
      .padding(.bottom, 100)
      
      TabBarView(
        viewModel: viewModel,
        showToast: $showProfileToast
      )
    }
    .toolbar(.hidden)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onReceive(NotificationCenter.default.publisher(for: .switchHomeTab)) { notification in
      if let raw = notification.userInfo?["homeViewTab"] as? String,
         let tab = HomeViewTab(rawValue: raw) {
        viewModel.selectedTab = tab
      }
    }
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.selectedTab {
    case .profile:
      ProfileViewFactory.createProfileView(
        getProfileUseCase: viewModel.getProfileUseCase
      )
    case .home:
      MatchMainViewFactory.createMatchMainView(
        getUserInfoUseCase: viewModel.getUserInfoUseCase,
        acceptMatchUseCase: viewModel.acceptMatchUseCase,
        getMatchesInfoUseCase: viewModel.getMatchesInfoUseCase,
        getUserRejectUseCase: viewModel.getUserRejectUseCase,
        patchMatchesCheckPieceUseCase: viewModel.patchMatchesCheckPieceUseCase
      )
    case .settings:
      SettingsViewFactory.createSettingsView(
        getSettingsInfoUseCase: viewModel.getSettingsInfoUseCase,
        fetchTermsUseCase: viewModel.fetchTermsUseCase,
        checkNotificationPermissionUseCase: viewModel.checkNotificationPermissionUseCase,
        requestNotificationPermissionUseCase: viewModel.requestNotificationPermissionUseCase,
        changeNotificationRegisterStatusUseCase: viewModel.changeNotificationRegisterStatusUseCase,
        checkContactsPermissionUseCase: viewModel.checkContactsPermissionUseCase,
        requestContactsPermissionUseCase: viewModel.requestContactsPermissionUseCase,
        fetchContactsUseCase: viewModel.fetchContactsUseCase,
        blockContactsUseCase: viewModel.blockContactsUseCase,
        getContactsSyncTimeUseCase: viewModel.getContactsSyncTimeUseCase,
        putSettingsNotificationUseCase: viewModel.putSettingsNotificationUseCase,
        putSettingsBlockAcquaintanceUseCase: viewModel.putSettingsBlockAcquaintanceUseCase,
        patchLogoutUseCase: viewModel.patchLogoutUseCase
      )
    }
  }
}
