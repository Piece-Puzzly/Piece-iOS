//
//  MatchStatus.swift
//  Entities
//
//  Created by eunseou on 4/5/25.
//

import SwiftUI

public enum MatchStatus: String {
  case BEFORE_OPEN = "UNCHECKED" // TODO: 임시->서버에서 값 잘못 넣음
  case WAITING = "CHECKED"
  case REFUSED
  case RESPONDED = "ACCEPTED"
  case GREEN_LIGHT
  case MATCHED
  
  public init(_ status: String) {
    self = MatchStatus(rawValue: status) ?? .BEFORE_OPEN
  }
}
