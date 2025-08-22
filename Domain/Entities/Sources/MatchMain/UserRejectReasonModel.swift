//
//  UserRejectReasonModel.swift
//  Entities
//
//  Created by eunseou on 2/24/25.
//

import SwiftUI

public struct UserRejectReasonModel {
  public let reasonImage: Bool
  public let reasonValues: Bool
  
  public init(
    reasonImage: Bool,
    reasonValues: Bool
  ) {
    self.reasonImage = reasonImage
    self.reasonValues = reasonValues
  }
}
