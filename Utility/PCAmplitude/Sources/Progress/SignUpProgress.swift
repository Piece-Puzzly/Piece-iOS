//
//  SignUpProgress.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation

public enum SignUpProgress: String, ProgressTrackable {
  case terms = "signup_terms"
  case permission = "signup_permission"
  case avoidance = "signup_avoidance"
  case complete = "signup_complete"
  
  public var order: Int {
    switch self {
    case .terms: return 0
    case .permission: return 1
    case .avoidance: return 2
    case .complete: return 3
    }
  }
}

