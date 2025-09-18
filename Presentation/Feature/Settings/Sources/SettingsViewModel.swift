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
import PCAmplitude

@Observable
final class SettingsViewModel {
  enum Action {
    case onAppear
    case pushNotificationToggled(Bool)
    case blockContactsToggled(Bool)
    case synchronizeContactsButtonTapped
    case termsItemTapped(id: Int)
    case logoutItemTapped
    case confirmLogoutButton
    case withdrawButtonTapped
    case clearDestination
    case openSettings
  }
  
  var sections = [SettingSection]()
  var showLogoutAlert: Bool = false
  var showNotificationAlert: Bool = false
  var showAcquaintanceBlockAlert: Bool = false
  
  // MARK: - 서버 권한 상태 (Server State)
  private var serverNotificationEnabled = false
  private var serverAcquaintanceBlockEnabled = false
  
  // MARK: - 디바이스 권한 상태 (Device Permission State)
  private var deviceNotificationPermissionGranted = false
  private var deviceContactsPermissionGranted = false
  
  /// 푸쉬 알림 = 서버에서 푸쉬알림 [true] && 디바이스 알림 권한 [true]
  var isNotificationEnabled: Bool {
    return serverNotificationEnabled && deviceNotificationPermissionGranted
  }

  /// 아는 사람 차단 = 서버에서 아는사람차단 [true] && 디바이스 연락처 권한 [true]
  var isAcquaintanceBlockEnabled: Bool {
    return serverAcquaintanceBlockEnabled && deviceContactsPermissionGranted
  }
  
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
      PCAmplitude.trackScreenView(DefaultProgress.logoutPopup.rawValue)
      
    case .confirmLogoutButton:
      tapComfirmLogout()
      
      break
    case .withdrawButtonTapped:
      destination = .withdraw
      
    case .clearDestination:
      destination = nil
    case .openSettings:
      openSettings()
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
      await checkNotificationPermission()
      await checkContactsPermission()
      await changeNotificationRegisterStatusUseCase.execute(
        isEnabled: deviceNotificationPermissionGranted && serverNotificationEnabled
      )
    }
  }
  
  private func onAppear() {
    fetchAppVersion()                       /// App 버전 정보 확인 - (ex. v1.0.1)
    Task {
      await fetchSettingsInfo()               /// (서버에서 받아온) "알림 섹션" - (["매칭 알림(Deprecated)", "푸쉬 알림", "아는 사람 차단"]) Bool 값
      await fetchTerms()                    /// (서버에서 받아온) "안내 섹션" - (["서비스 이용약관", " 개인정보 처리방침"])
      await checkNotificationPermission()   /// (디바이스의) ["매칭 알림(Deprecated)", "푸쉬 알림"] (알림)권한 관련 비즈니스 로직
      await checkContactsPermission()       /// (디바이스의)  ["아는 사람 차단"] (연락처)권한 관련 비즈니스 로직
      await changeNotificationRegisterStatusUseCase.execute(
        isEnabled: deviceNotificationPermissionGranted && serverNotificationEnabled
      )
    }
  }
  
  private func fetchSettingsInfo() async {
    do {
      let settingsInfo = try await getSettingsInfoUseCase.execute()
      serverNotificationEnabled = settingsInfo.isNotificationEnabled
      serverAcquaintanceBlockEnabled = settingsInfo.isAcquaintanceBlockEnabled
      print(">>> DEBUG: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
      print(">>> DEBUG: 🔧 Settings Info Loaded:")
      print(">>> DEBUG: ┌ 푸시 알림: \(serverNotificationEnabled ? "✅" : "❌")")
      print(">>> DEBUG: └ 아는 사람 차단: \(serverAcquaintanceBlockEnabled ? "✅" : "❌")")
      print(">>> DEBUG: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
      
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
  
  // MARK: - 디바이스 내 알림 권한 가져오기
  private func checkNotificationPermission() async {
    do {
      let authorizationStatus = await checkNotificationPermissionUseCase.execute()
      switch authorizationStatus {
      case .notDetermined, .denied:
        deviceNotificationPermissionGranted = false
      case .authorized, .provisional:
        deviceNotificationPermissionGranted = true
      case .ephemeral:
        deviceNotificationPermissionGranted = false
      @unknown default:
        deviceNotificationPermissionGranted = false
      }
    }
  }
  
  // MARK: - 디바이스 내 연락처 권한 가져오기
  private func checkContactsPermission() async {
    let contactsAuthorizationStatus = checkContactsPermissionUseCase.execute()
    switch contactsAuthorizationStatus {
    case .notDetermined, .restricted, .denied:
      deviceContactsPermissionGranted = false
    case .authorized, .limited:
      deviceContactsPermissionGranted = true
    @unknown default:
      deviceContactsPermissionGranted = false
    }
  }

  private func pushNotificationToggled(isEnabled: Bool) async {
    if isEnabled {
      do {
      let authorizationStatus = await checkNotificationPermissionUseCase.execute()
        switch authorizationStatus {
        case .denied:
          self.showNotificationAlert = true
        case .notDetermined, .ephemeral:
          self.deviceNotificationPermissionGranted = try await requestNotificationPermissionUseCase.execute()
        case .authorized, .provisional:
          self.deviceNotificationPermissionGranted = true
        @unknown default:
          self.deviceNotificationPermissionGranted = false
        }
      } catch {
        print(error)
        self.deviceNotificationPermissionGranted = false
      }
    }
    
    do {
      _ = try await putSettingsNotificationUseCase.execute(isEnabled: isEnabled)
    } catch {
      print(error)
    }
    
    Task {
      await fetchSettingsInfo()
      await changeNotificationRegisterStatusUseCase.execute(
        isEnabled: deviceNotificationPermissionGranted && isEnabled
      )
    }
  }
  
  private func blockContactsToggled(isEnabled: Bool) async {
    if isEnabled {
      do {
        let authorizationStatus = checkContactsPermissionUseCase.execute()
        switch authorizationStatus {
        case .notDetermined:
          self.deviceContactsPermissionGranted = try await requestContactsPermissionUseCase.execute()
        case .restricted, .denied:
          self.showAcquaintanceBlockAlert = true
        case .authorized, .limited:
          self.deviceContactsPermissionGranted = true
        @unknown default:
          self.deviceContactsPermissionGranted = try await requestContactsPermissionUseCase.execute()
        }
      } catch {
        print(error)
        self.deviceContactsPermissionGranted = false
      }
    }
    
    do {
      _ = try await putSettingsBlockAcquaintanceUseCase.execute(isEnabled: isEnabled)
    } catch {
      print(error)
    }
    
    Task {
      await fetchSettingsInfo()
    }
  }
  
  private func openSettings() {
    Task {
      if let url = URL(string: UIApplication.openSettingsURLString) {
        await MainActor.run {
          UIApplication.shared.open(url)
        }
      }
    }
  }
  
  private func synchronizeContacts() {
    if isAcquaintanceBlockEnabled {
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
    
    print("✅ Logout started")
    // fcm 토큰 제외 모두 지우기 (앱을 종료하지 않고 바로 다시 로그인하는 경우 fcm 토큰을 서버에 등록해야함)
    clearUserDataPreservingFCMToken()
    
    // 로그아웃 시 splash로 이동
    destination = .splash
    print("✅ Logout completed - moved to splash")
  }
  
  private func clearUserDataPreservingFCMToken() {
    let fcmToken = PCKeychainManager.shared.read(.fcmToken)
    PCKeychainManager.shared.deleteAll()
    PCUserDefaultsService.shared.initialize()
    
    if let fcmToken {
      PCKeychainManager.shared.save(.fcmToken, value: fcmToken)
      print("✅ User data cleared with FCM token preserved")
    } else {
      print("✅ User data cleared")
    }
  }
}
