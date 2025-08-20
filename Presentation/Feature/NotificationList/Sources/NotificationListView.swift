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
    switch item.type {
    case .profileApproved:
      // 프로필 승인 -> 홈으로
      router.setRoute(.home)
    case .profileRejected:
      // TODO: - 프로필 거부 -> 프로필 리젝 팝업인데 임시로 홈으로 보내야함
      router.setRoute(.home)
    case .profileImageApproved:
      // 프로필 이미지 승인 -> 기본 정보 수정(프로필 편집)
      router.push(to: .editProfile)
    case .profileImageRejected:
      // 프로필 이미지 거부 -> 기본 정보 수정(프로필 편집)
      router.push(to: .editProfile)
    case .matchNew:
      // 새로운 매칭 -> 홈으로
      router.setRoute(.home)
    case .matchAccepted:
      // 매칭 수락 -> 홈으로
      router.setRoute(.home)
    case .matchCompleted:
      // 매칭 성공 -> 홈으로
      router.setRoute(.home)
    }
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
