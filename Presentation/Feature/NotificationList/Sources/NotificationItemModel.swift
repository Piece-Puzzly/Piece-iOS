//
//  NotificationItemModel.swift
//  NotificationList
//
//  Created by summercat on 2/26/25.
//

import DesignSystem
import Entities
import Foundation
import SwiftUI

struct NotificationItemModel: Identifiable {
  let id: Int
  let type: NotificationType
  let title: String
  let body: String
  let dateTime: String
  let isRead: Bool
  
  var icon: Image {
    switch type {
    case .profileApproved: DesignSystemAsset.Icons.profileSolid24.swiftUIImage
    case .profileRejected: DesignSystemAsset.Icons.profileSolid24.swiftUIImage
    case .profileImageApproved: DesignSystemAsset.Icons.profileSolid24.swiftUIImage
    case .profileImageRejected: DesignSystemAsset.Icons.profileSolid24.swiftUIImage
    case .matchNew: DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage
    case .matchAccepted: DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage
    case .matchCompleted: DesignSystemAsset.Icons.heartPuzzle24.swiftUIImage
    }
  }
  
  var backgroundColor: Color {
    switch type {
    case .profileApproved: .primaryDefault
    case .profileRejected: .subDefault
    case .profileImageApproved: .primaryDefault
    case .profileImageRejected: .subDefault
    case .matchNew: .primaryDefault
    case .matchAccepted: .primaryDefault
    case .matchCompleted: .primaryDefault
    }
  }
}
