//
//  NotificationItem.swift
//  NotificationList
//
//  Created by summercat on 2/26/25.
//

import DesignSystem
import SwiftUI

struct NotificationItem: View {
  let model: NotificationItemModel
  let onTap: ((NotificationItemModel) -> Void)?
  
  init(
    model: NotificationItemModel,
    onTap: ((NotificationItemModel) -> Void)? = nil
  ) {
    self.model = model
    self.onTap = onTap
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 20) {
      icon
      
      VStack(alignment: .leading, spacing: 4) {
        title
        bodyText
        dateTime
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 16)
    .background(model.isRead ? Color.grayscaleWhite : Color.primaryLight)
    .onTapGesture {
      if !model.isRead {
        onTap?(model)
      }
    }
  }
  
  private var icon: some View {
    ZStack {
      Circle()
        .fill(model.backgroundColor)
        .frame(width: 32, height: 32)
      model.icon
        .frame(width: 14, height: 14)
    }
  }
  
  private var title: some View {
    Text(model.title)
      .pretendard(.body_S_SB)
      .foregroundStyle(.grayscaleBlack)
  }
  
  private var bodyText: some View {
    Text(model.body)
      .multilineTextAlignment(.leading)
      .pretendard(.body_S_R)
      .foregroundStyle(.alphaBlack40)
  }
  
  private var dateTime: some View {
    Text(model.dateTime)
      .pretendard(.body_S_R)
      .foregroundStyle(.alphaBlack40)
  }
}

#Preview {
  VStack {
    NotificationItem(model: model0)
    NotificationItem(model: model1)
    NotificationItem(model: model2)
  }
}
