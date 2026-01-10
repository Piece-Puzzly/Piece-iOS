//
// NotificationListView.swift
// NotificationList
//
// Created by summercat on 2025/02/26.
//

import DesignSystem
import Router
import SwiftUI
import UseCases
import Entities

struct NotificationListView: View {
  @State var viewModel: NotificationListViewModel
  @Environment(Router.self) private var router
  
  init(
    getNotificationsUseCase: GetNotificationsUseCase,
    readNotificationUseCase: ReadNotificationUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        getNotificationsUseCase: getNotificationsUseCase,
        readNotificationUseCase: readNotificationUseCase
      )
    )
  }

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "알림",
        leftButtonTap: {
          router.pop()
        }
      )
      Divider(weight: .normal)
      content
    }
    .toolbar(.hidden)
    .background(.grayscaleWhite)
    .onDisappear {
      viewModel.handleAction(.onDisappear)
    }
  }
  
  @ViewBuilder
  private var content: some View {
    if viewModel.notifications.isEmpty {
      noData
    } else {
      ScrollView {
        notifications
      }
    }
  }
  
  private var noData: some View {
    VStack(spacing: 0) {
      DesignSystemAsset.Images.imgNotice.swiftUIImage
        .resizable()
        .frame(width: 240, height: 240)
      Text("받은 알림이 없어요")
        .pretendard(.heading_S_M)
        .foregroundStyle(.grayscaleDark2)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }
  
  private var notifications: some View {
    LazyVStack(spacing: 0) {
      ForEach(
        Array(zip(viewModel.notifications.indices, viewModel.notifications)),
        id: \.1.id
      ) { index, notification in
        NotificationItem(
          model: notification,
          onTap: { item in handleNotificationTap(for: item) }
        )
        .onAppear {
          if index == viewModel.notifications.count - 1 {
            viewModel.handleAction(.loadNotifications)
          }
        }
        
        if index < viewModel.notifications.count - 1 {
          Divider(weight: .normal)
        }
      }
    }
  }
}

extension NotificationListView {
  private func handleNotificationTap(for item: NotificationItemModel) {
    viewModel.handleAction(.didTapNotificationItem(item)) /// 읽음 처리
    navigateToDestination(for: item) /// 라우팅
  }
  
  private func navigateToDestination(for item: NotificationItemModel) {
    // MARK: - 딥링크와 달리 현재 route가 home이 아니기 때문에 setRoute가 씹힐 수 없음. 따로 리프레시 호출하지 않아도 ok
    switch item.type {
    case .profileApproved:
      // 프로필 심사 승인
      router.setRoute(.home) {
        postSwitchHomeTab(.home) // 현재 selectedTab이 profile일 수 있기 때문에
      }
    case .profileRejected:
      // 프로필 심사 거절
      router.setRoute(.home) {
        postSwitchHomeTab(.home)
      }
    case .profileImageApproved:
      // 프로필 이미지 승인 -> 기본 정보 수정(프로필 편집)
      router.setRoute(.home) {
        postSwitchHomeTab(.profile)
        router.push(to: .editProfile)
      }
    case .profileImageRejected:
      // 프로필 이미지 거부 -> 기본 정보 수정(프로필 편집)
      router.setRoute(.home) {
        postSwitchHomeTab(.profile)
        router.push(to: .editProfile)
      }
    case .matchNew:
      // 새로운 매칭 -> 홈으로
      router.setRoute(.home) {
        postSwitchHomeTab(.home)
      }
    case .matchAccepted:
      // 매칭 수락 -> 홈으로
      router.setRoute(.home) {
        postSwitchHomeTab(.home)
      }
    case .matchCompleted:
      // 매칭 성공 -> 홈으로
      router.setRoute(.home) {
        postSwitchHomeTab(.home)
      }
    }
  }
  
  private func postSwitchHomeTab(_ tab: HomeViewTab) {
    NotificationCenter.default.post(
      name: .switchHomeTab,
      object: nil,
      userInfo: ["homeViewTab": tab.rawValue]
    )
  }
}

//#Preview {
//  let viewModel = NotificationListViewModel(
//    notifications: notifications
//  )
//  
//  NotificationListView(viewModel: viewModel)
//    .environment(Router())
//}
