//
// SettingsView.swift
// Settings
//
// Created by summercat on 2025/02/12.
//

import DesignSystem
import Router
import SwiftUI
import UseCases

struct SettingsView: View {
  @State var viewModel: SettingsViewModel
  @Environment(Router.self) var router
  
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
    _viewModel = .init(
      wrappedValue: .init(
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
        putSettingsMatchNotificationUseCase: putSettingsMatchNotificationUseCase,
        putSettingsBlockAcquaintanceUseCase: putSettingsBlockAcquaintanceUseCase,
        patchLogoutUseCase: patchLogoutUseCase
      )
    )
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HomeNavigationBar(
        title: "Settings",
        foregroundColor: .grayscaleBlack
      )
      Divider(weight: .normal, isVertical: false)
      ScrollView(showsIndicators: false) {
        VStack(spacing: 16) {
          ForEach(
            Array(zip(viewModel.sections.indices, viewModel.sections)),
            id: \.1.id
          ) { index, section in
            makeSections(section)
            if index != viewModel.sections.count - 1 {
              Divider(weight: .normal, isVertical: false)
            }
          }
          
          PCTextButton(content: "탈퇴하기")
            .onTapGesture {
              viewModel.handleAction(.withdrawButtonTapped)
            }
          
          Spacer()
        }
        .padding(.vertical, 20)
      }
      .contentMargins(.horizontal, 20)
      .padding(.bottom, 89) // 탭바 높이 만큼 패딩
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .alert(
      "알림 권한이 필요합니다",
      isPresented: $viewModel.showMatchNotificationAlert
    ) {
      Button("설정") {
        viewModel.handleAction(.openSettings)
      }
      Button("취소") {
        viewModel.handleAction(.matchingNotificationToggled(false))
      }
    } message: {
      Text("\"매칭 알림\" 기능을 사용하려면\n[설정]-[피스]-[알림]을 허용해주세요.")
    }
    .alert(
      "알림 권한이 필요합니다",
      isPresented: $viewModel.showNotificationAlert
    ) {
      Button("설정") {
        viewModel.handleAction(.openSettings)
      }
      Button("취소") {
        viewModel.handleAction(.pushNotificationToggled(false))
      }
    } message: {
      Text("\"푸쉬 알림\" 기능을 사용하려면\n[설정]-[피스]-[알림]을 허용해주세요.")
    }
    .alert(
      "연락처 접근 권한이 필요합니다",
      isPresented: $viewModel.showAcquaintanceBlockAlert
    ) {
      Button("설정") {
        viewModel.handleAction(.openSettings)
      }
      Button("취소") {
        viewModel.handleAction(.blockContactsToggled(false))
      }
    } message: {
      Text("\"아는 사람 차단\" 기능을 사용하려면\n[설정]-[피스]-[연락처 접근]을 허용해주세요.")
    }
    .pcAlert(isPresented: $viewModel.showLogoutAlert) {
      AlertView(
        title: {
          Text("로그아웃")
        },
        message: "로그아웃하시겠습니까?",
        firstButtonText: "취소",
        secondButtonText: "확인",
        firstButtonAction: { viewModel.showLogoutAlert = false },
        secondButtonAction: { viewModel.handleAction(.confirmLogoutButton) }
      )
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .onChange(of: viewModel.destination) { _, destination in
      guard let destination else { return }
      router.push(to: destination)
      viewModel.handleAction(.clearDestination)
    }
  }
  
  @ViewBuilder
  private func makeSections(_ section: SettingSection) -> some View {
    switch section.id {
    case .notification:
      SettingsNotificationSettingSectionView(
        title: section.title,
        isMatchingNotificationOn: Binding(
          get: { viewModel.isMatchNotificationEnable },
          set: { isEnable in viewModel.handleAction(.matchingNotificationToggled(isEnable)) }
        ),
        isPushNotificationOn: Binding(
          get: { viewModel.isNotificationEnabled },
          set: { isEnable in viewModel.handleAction(.pushNotificationToggled(isEnable)) }
        )
      )
    case .system:
      SettingsSystemSettingSectionView(
        title: section.title,
        isBlockingFriends: Binding(
          get: { viewModel.isAcquaintanceBlockEnabled },
          set: { isEnable in viewModel.handleAction(.blockContactsToggled(isEnable))}
        ),
        date: .init(projectedValue: .constant(viewModel.updatedDateString)),
        isSyncingContact: $viewModel.isSyncingContact,
        didTapRefreshButton: { viewModel.handleAction(.synchronizeContactsButtonTapped) }
      )
    case .ask:
      SettingsAskSectionView(
        title: section.title,
        askTitle: "문의하기",
        didTapAskView: {
          router.push(to: .settingsWebView(title: "문의하기", uri: viewModel.inquiriesUri))
        }
      )
    case .information:
      SettingsInformationSectionView(
        title: "안내",
        termsItems: $viewModel.termsItems,
        version: viewModel.version,
        didTapNoticeItem: {
          router.push(to: .settingsWebView(title: "공지사항", uri: viewModel.noticeUri))
        },
        didTapTermsItem: {
          viewModel.handleAction(.termsItemTapped(id: $0))
          if let tappedTermItem = viewModel.tappedTermItem {
            router.push(to: .settingsWebView(
              title: tappedTermItem.title,
              uri: tappedTermItem.content
            ))
          }
        }
      )
    case .etc:
      SettingsEtcSectionview(
        title: "기타",
        logoutTitle: "로그아웃",
        didTapLogoutItem: {
          viewModel.handleAction(.logoutItemTapped)
        }
      )
    }
  }
}
