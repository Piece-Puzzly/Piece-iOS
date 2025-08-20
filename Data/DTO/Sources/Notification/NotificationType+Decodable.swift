//
//  NotificationType+Decodable.swift
//  DTO
//
//  Created by summercat on 3/15/25.
//

import Entities
import Foundation

extension NotificationType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        switch rawValue {
        case "PROFILE_APPROVED":
            self = .profileApproved
        case "PROFILE_REJECTED":
            self = .profileRejected
        case "PROFILE_IMAGE_APPROVED":
            self = .profileImageApproved
        case "PROFILE_IMAGE_REJECTED":
            self = .profileImageRejected
        case "MATCHING_NEW":
            self = .matchingNew
        case "MATCHING_ACCEPT":
            self = .matchingAccept
        case "MATCHING_SUCCESS":
            self = .matchingSuccess
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid NotificationType: \(rawValue)"
            )
        }
    }
}
