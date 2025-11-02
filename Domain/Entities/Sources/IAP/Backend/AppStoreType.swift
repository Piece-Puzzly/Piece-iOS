//
//  AppStoreType.swift
//  Entities
//
//  Created by 홍승완 on 11/2/25.
//

import Foundation

public enum AppStoreType: String, Encodable {
  case playStore = "PLAY_STORE"
  case appStore = "APP_STORE"
}

public extension AppStoreType {
  var description: String {
    switch self {
    case .playStore: "구글"
    case .appStore: "애플"
    }
  }
}
