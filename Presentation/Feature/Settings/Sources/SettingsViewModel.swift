//
// SettingsViewModel.swift
// Settings
//
// Created by summercat on 2025/02/12.
//

import Entities
import Foundation
import LocalStorage
import PCFoundationExtension
import SwiftUI
import UseCases
import Router

@Observable
final class SettingsViewModel {
  enum Action {
    case onAppear
    case matchingNotificationToggled(Bool)
    case pushNotificationToggled(Bool)
    case blockContactsToggled(Bool)
    case synchronizeContactsButtonTapped
    case termsItemTapped(id: Int)
    case logoutItemTapped
    case confirmLogoutButton
    case withdrawButtonTapped
    case clearDestination
  }
  
  var sections = [SettingSection]()
  var showLogoutAlert: Bool = false
  var isMatchingNotificationOn = false
  var isPushNotificationEnabled = false
  var isBlockContactsEnabled: Bool = false
  var isSyncingContact: Bool = false
  private var updatedDate: Date? {
    get { PCUserDefaultsService.shared.getLatestSyncDate() }
    set { PCUserDefaultsService.shared.setLatestSyncDate(newValue ?? Date()) }
  }
  var updatedDateString: String {
    DateFormatter.utcDateTimeString(from: updatedDate)
  }
  var termsItems = [SettingsTermsItem]()
  var version = ""
  var loginInformationImage: Image?
  var loginEmail = "example@kakao.com" // TODO: - 이거 어디서 받아옴?
  let inquiriesUri = "https://kd0n5.channel.io/home"
  let noticeUri = "https://brassy-client-c0a.notion.site/16a2f1c4b96680e79a0be5e5cea6ea8a"
  
  private let userDefaults = PCUserDefaultsService.shared
  private let getSettingsInfoUseCase: GetSettingsInfoUseCase
  private let fetchTermsUseCase: FetchTermsUseCase
  private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
  private let requestNotificationPermissionUseCase: RequestNotificationPermissionUseCase
  private let changeNotificationRegisterStatusUseCase: ChangeNotificationRegisterStatusUseCase
  private let checkContactsPermissionUseCase: CheckContactsPermissionUseCase
  private let requestContactsPermissionUseCase: RequestContactsPermissionUseCase
  private let fetchContactsUseCase: FetchContactsUseCase
  private let blockContactsUseCase: BlockContactsUseCase
  private let getContactsSyncTimeUseCase: GetContactsSyncTimeUseCase
  private let putSettingsNotificationUseCase: PutSettingsNotificationUseCase
  private let putSettingsMatchNotificationUseCase: PutSettingsMatchNotificationUseCase
  private let putSettingsBlockAcquaintanceUseCase: PutSettingsBlockAcquaintanceUseCase
  private let patchLogoutUseCase: PatchLogoutUseCase
  private(set) var tappedTermItem: SettingsTermsItem?
  private(set) var destination: Route?
  
  init(
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
    putSettingsMatchNotificationUseCase: PutSettingsMatchNotificationUseCase,
    putSettingsBlockAcquaintanceUseCase: PutSettingsBlockAcquaintanceUseCase,
    patchLogoutUseCase: PatchLogoutUseCase
  ) {
    self.getSettingsInfoUseCase = getSettingsInfoUseCase
    self.fetchTermsUseCase = fetchTermsUseCase
    self.checkContactsPermissionUseCase = checkContactsPermissionUseCase
    self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
    self.requestNotificationPermissionUseCase = requestNotificationPermissionUseCase
    self.changeNotificationRegisterStatusUseCase = changeNotificationRegisterStatusUseCase
    self.requestContactsPermissionUseCase = requestContactsPermissionUseCase
    self.fetchContactsUseCase = fetchContactsUseCase
    self.blockContactsUseCase = blockContactsUseCase
    self.getContactsSyncTimeUseCase = getContactsSyncTimeUseCase
    self.putSettingsNotificationUseCase = putSettingsNotificationUseCase
    self.putSettingsMatchNotificationUseCase = putSettingsMatchNotificationUseCase
    self.putSettingsBlockAcquaintanceUseCase = putSettingsBlockAcquaintanceUseCase
    self.patchLogoutUseCase = patchLogoutUseCase
    addObserver()
  }
  
  deinit {
    removeObserver()
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      onAppear()
      sections = [
        .init(id: .notification),
        .init(id: .system),
        .init(id: .ask),
        .init(id: .information),
        .init(id: .etc),
      ]
      
    case let .matchingNotificationToggled(isEnabled):
      Task {
        await matchingNotificationToggled(isEnabled: isEnabled)
      }
      
    case let .pushNotificationToggled(isEnabled):
      Task {
        await pushNotificationToggled(isEnabled: isEnabled)
      }
      
    case let .blockContactsToggled(isEnabled):
      Task {
        await blockContactsToggled(isEnabled: isEnabled)
      }
      
    case .synchronizeContactsButtonTapped:
      synchronizeContacts()
      
    case let .termsItemTapped(id):
      tappedTermItem = termsItems.first(where: { $0.id == id })
      
    case .logoutItemTapped:
      showLogoutAlert = true
      
    case .confirmLogoutButton:
      tapComfirmLogout()
      
      break
    case .withdrawButtonTapped:
      destination = .withdraw
      
    case .clearDestination:
      destination = nil
    }
  }
  
  private func addObserver() {
    // NotificationCenter를 통해 앱이 포그라운드로 돌아오는 이벤트를 감지
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(willEnterForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  private func removeObserver() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc private func willEnterForeground() {
    Task {
      await checkPushNoficationPermission()
      await checkContactsPermission()
    }
  }
  
  private func onAppear() {
    fetchAppVersion()
    Task {
      await getSettingsInfo()
      await fetchTerms()
      await checkPushNoficationPermission()
      await checkContactsPermission()
    }
  }
  
  private func getSettingsInfo() async {
    do {
      let settingsInfo = try await getSettingsInfoUseCase.execute()
      isMatchingNotificationOn = settingsInfo.isMatchNotificationEnabled
      isBlockContactsEnabled = settingsInfo.isAcquaintanceBlockEnabled
    } catch {
      print(error)
    }
  }
  
  private func fetchTerms() async {
    do {
      let terms = try await fetchTermsUseCase.execute()
      withAnimation {
        termsItems = terms.responses.map {
          SettingsTermsItem(id: $0.termId, title: $0.title, content: $0.content)
        }
      }
    } catch {
      print(error)
    }
  }
  
  private func fetchAppVersion() {
    version = AppVersion.appVersion()
  }
  
  private func checkPushNoficationPermission() async {
    do {
      let authorizationStatus = await checkNotificationPermissionUseCase.execute()
      var isPushNotificationEnabled = false
      switch authorizationStatus {
      case .notDetermined, .denied:
        isPushNotificationEnabled = false
      case .authorized, .provisional:
        isPushNotificationEnabled = true
      case .ephemeral:
        isPushNotificationEnabled = false
      @unknown default:
        isPushNotificationEnabled = false
      }
      self.isPushNotificationEnabled = isPushNotificationEnabled
    }
  }
  
  private func checkContactsPermission() async {
    let contactsAuthorizationStatus = checkContactsPermissionUseCase.execute()
    var isBlockContactsEnabled = false
    switch contactsAuthorizationStatus {
    case .notDetermined, .restricted, .denied:
      isBlockContactsEnabled = false
    case .authorized, .limited:
      isBlockContactsEnabled = true
    @unknown default:
      isBlockContactsEnabled = false
    }
    self.isBlockContactsEnabled = isBlockContactsEnabled
  }
  
  private func matchingNotificationToggled(isEnabled: Bool) async {
    do {
      _ = try await putSettingsMatchNotificationUseCase.execute(isEnabled: isEnabled)
    } catch {
      print(error)
    }
    isMatchingNotificationOn = isEnabled
  }
  
  private func pushNotificationToggled(isEnabled: Bool) async {
    var isPushNotificationEnabled = self.isPushNotificationEnabled
    if isEnabled {
      do {
      let authorizationStatus = await checkNotificationPermissionUseCase.execute()
        switch authorizationStatus {
        case .denied:
          if let url = URL(string: UIApplication.openSettingsURLString) {
            await MainActor.run {
              UIApplication.shared.open(url)
            }
          }
        case .notDetermined, .ephemeral:
          isPushNotificationEnabled = try await requestNotificationPermissionUseCase.execute()
        case .authorized, .provisional:
          break
        @unknown default:
          isPushNotificationEnabled = false
        }
      } catch {
        print(error)
        isPushNotificationEnabled = false
      }
    }
    await changeNotificationRegisterStatusUseCase.execute(isEnabled: isPushNotificationEnabled)
    self.isPushNotificationEnabled = isPushNotificationEnabled

    do {
      _ = try await putSettingsNotificationUseCase.execute(isEnabled: isPushNotificationEnabled)
    } catch {
      print(error)
    }
    
    // 푸시알림을 끈 경우 매칭 알림도 같이 Off 처리
    if isPushNotificationEnabled == false {
      await matchingNotificationToggled(isEnabled: isPushNotificationEnabled)
    }
  }
  
  private func blockContactsToggled(isEnabled: Bool) async {
    if isEnabled {
        do {
          let authorizationStatus = checkContactsPermissionUseCase.execute()
          switch authorizationStatus {
          case .notDetermined:
            isBlockContactsEnabled = try await requestContactsPermissionUseCase.execute()
          case .restricted, .denied:
            if let url = URL(string: UIApplication.openSettingsURLString) {
              await MainActor.run {
                UIApplication.shared.open(url)
              }
            }
          case .authorized, .limited:
            isBlockContactsEnabled = true
          @unknown default:
            isBlockContactsEnabled = try await requestContactsPermissionUseCase.execute()
          }
        } catch {
          print(error)
          self.isBlockContactsEnabled = false
        }
    } else {
      isBlockContactsEnabled = false
    }
    
    do {
      _ = try await putSettingsBlockAcquaintanceUseCase.execute(isEnabled: isEnabled)
    } catch {
      print(error)
    }
  }
  
  private func synchronizeContacts() {
    if isBlockContactsEnabled {
      Task {
        do {
          isSyncingContact = true
          let userContacts = try await fetchContactsUseCase.execute()
          _ = try await blockContactsUseCase.execute(phoneNumbers: userContacts)
          let response = try await getContactsSyncTimeUseCase.execute()
          let updatedDate = response.syncTime
          self.updatedDate = updatedDate
          isSyncingContact = false
        } catch {
          isSyncingContact = false
          print(error)
        }
      }
    }
  }
  
  private func tapComfirmLogout() {
    // logout api 호출
    Task {
      do {
        _ = try await patchLogoutUseCase.execute()
      } catch {
        print(error)
      }
    }
    showLogoutAlert = false
    
    PCKeychainManager.shared.deleteAll()
    PCUserDefaultsService.shared.initialize()
    // 로그아웃 시 splash로 이동
    destination = .splash
  }
}
