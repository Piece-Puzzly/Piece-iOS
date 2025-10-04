//
//  NotificationType.swift
//  Entities
//
//  Created by summercat on 2/27/25.
//

public enum NotificationType {
  case profileApproved
  case profileRejected
  case profileImageApproved
  case profileImageRejected
  case matchNew
  case matchAccepted
  case matchCompleted
}

public extension NotificationType {
  static func from(raw: String) -> NotificationType? {
    switch raw {
    case "PROFILE_APPROVED": return .profileApproved
    case "PROFILE_REJECTED": return .profileRejected
    case "PROFILE_IMAGE_APPROVED": return .profileImageApproved
    case "PROFILE_IMAGE_REJECTED": return .profileImageRejected
    case "MATCH_NEW": return .matchNew
    case "MATCH_ACCEPTED": return .matchAccepted
    case "MATCH_COMPLETED": return .matchCompleted
    default: return nil
    }
  }
}
