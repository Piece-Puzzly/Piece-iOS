//
//  SettingsEndpoint.swift
//  PCNetwork
//
//  Created by summercat on 2/19/25.
//

import Alamofire
import DTO
import LocalStorage

public enum SettingsEndpoint: TargetType {
  case settingsInfo
  case notification(SettingsNotificationRequestDTO)
  case blockAcquaintance(SettingsBlockAcquaintanceRequestDTO)
  case fetchBlockContactsSyncTime
  case patchLogout
  
  public var headers: [String : String] {
    switch self {
    case .settingsInfo:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    case .notification:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .blockAcquaintance:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .fetchBlockContactsSyncTime:
      [NetworkHeader.accept: NetworkHeader.all]
    case .patchLogout:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .settingsInfo: .get
    case .notification: .put
    case .blockAcquaintance: .put
    case .fetchBlockContactsSyncTime: .get
    case .patchLogout: .patch
    }
  }
  
  public var path: String {
    switch self {
    case .settingsInfo: "api/settings/infos"
    case .notification: "api/settings/notification"
    case .blockAcquaintance: "api/settings/block/acquaintance"
    case .fetchBlockContactsSyncTime: "api/settings/blocks/contacts/sync-time"
    case .patchLogout: "api/logout"
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case .settingsInfo: .plain
    case let .notification(dto): .body(dto)
    case let .blockAcquaintance(dto): .body(dto)
    case .fetchBlockContactsSyncTime: .plain
    case .patchLogout: .plain
    }
  }
}
