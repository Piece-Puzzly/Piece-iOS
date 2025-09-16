//
//  CreateProfileProgress.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/16/25.
//

import Foundation

public enum CreateProfileProgress: String, ProgressTrackable {
  case basicInfo = "basic_info_main"
  case valuePick = "value_talk_input"
  case valueTalk = "value_pick_input"
  case aiLoding = "profile_ai_loading"
  case complete = "profile_complete"

  public var order: Int {
    switch self {
    case .basicInfo: return 0
    case .valuePick: return 1
    case .valueTalk: return 2
    case .aiLoding: return 3
    case .complete: return 4
    }
  }
}
