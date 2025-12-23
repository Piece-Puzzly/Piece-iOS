//
//  MatchType.swift
//  Entities
//
//  Created by 홍승완 on 11/16/25.
//

import SwiftUI

public enum MatchType: String {
  /// 기본 매칭
  case BASIC
  
  /// 맛보기 매칭
  case TRIAL
  
  /// 유료 매칭
  case PREMIUM
  
  /// 타의적 매칭
  case AUTO
  
  public init(_ status: String) {
    self = MatchType(rawValue: status) ?? .BASIC
  }
}
