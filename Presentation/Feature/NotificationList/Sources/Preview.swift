//
//  Preview.swift
//  NotificationList
//
//  Created by summercat on 2/27/25.
//

import Foundation

let model0 = NotificationItemModel(
  id: 0,
  type: .matchAccepted,
  title: "매칭이 성사되었습니다",
  body: "매칭이 성사되었습니다. 상대방과 대화를 시작해보세요.",
  dateTime: Date().description,
  isRead: false
)
let model1 = NotificationItemModel(
  id: 1,
  type: .profileRejected,
  title: "프로필이 거절되었습니다",
  body: "프로필이 거절되었습니다. 다시 한번 확인해보세요.\n프로필이 거절되었습니다. 다시 한번 확인해보세요.",
  dateTime: Date().description,
  isRead: true
)

let model2 = NotificationItemModel(
  id: 2,
  type: .matchCompleted,
  title: "매칭이 성사되었습니다",
  body: "매칭이 성사되었습니다. 상대방과 대화를 시작해보세요.",
  dateTime: Date().description,
  isRead: true
)

let notifications = [
  model0,
  model1,
  model2,
]
