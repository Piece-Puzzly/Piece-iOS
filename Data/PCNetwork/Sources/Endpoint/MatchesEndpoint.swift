//
//  MatchesEndpoint.swift
//  PCNetwork
//
//  Created by summercat on 2/11/25.
//

import Alamofire
import DTO
import Foundation
import LocalStorage

public enum MatchesEndpoint: TargetType {
  case profile(matchId: Int)
  case valueTalks(matchId: Int)
  case valuePicks(matchId: Int)
  case accept(matchId: Int)
  case matchesInfos
  case refuse(matchId: Int)
  case block(matchId: Int)
  case contacts(matchId: Int)
  case image(matchId: Int)
  case checkMatchPiece(matchId: Int)
  case createNewMatch
  case canFreeMatchToday

  public var method: HTTPMethod {
    switch self {
    case .profile: .get
    case .valueTalks: .get
    case .valuePicks: .get
    case .accept: .post
    case .matchesInfos: .get
    case .refuse: .put
    case .block: .post
    case .contacts: .get
    case .image: .get
    case .checkMatchPiece: .patch
    case .createNewMatch: .post
    case .canFreeMatchToday: .get
    }
  }
  
  public var path: String {
    switch self {
    case let .profile(matchId): "api/matches/\(matchId)/profiles"
    case let .valueTalks(matchId): "api/matches/\(matchId)/values/talks"
    case let .valuePicks(matchId): "api/matches/\(matchId)/values/picks"
    case let .accept(matchId): "api/matches/\(matchId)/accept"
    case .matchesInfos: "api/matches/infos"
    case let .refuse(matchId): "api/matches/\(matchId)/refuse"
    case let .block(matchId): "api/matches/\(matchId)/blocks"
    case let .contacts(matchId): "api/matches/\(matchId)/contacts"
    case let .image(matchId): "api/matches/\(matchId)/images"
    case let .checkMatchPiece(matchId): "api/matches/\(matchId)/pieces/check"
    case .createNewMatch: "api/matches/instants/new"
    case .canFreeMatchToday: "api/matches/instants/free/today"
    }
  }
  
  public var headers: [String : String] {
    switch self {
    case .profile:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    
    case .valueTalks:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    
    case .valuePicks:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    
    case .accept:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    
    case .matchesInfos:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    
    case .refuse:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
      
    case .block:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
      
    case .contacts:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
      
    case .image:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    
    case .checkMatchPiece:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    
    case .createNewMatch:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]

    case .canFreeMatchToday:
      [NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")]
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case .profile: .plain
    case .valueTalks: .plain
    case .valuePicks: .plain
    case .accept: .plain
    case .matchesInfos: .plain
    case .refuse: .plain
    case .block: .plain
    case .contacts: .plain
    case .image: .plain
    case .checkMatchPiece: .plain
    case .createNewMatch: .plain
    case .canFreeMatchToday: .plain
    }
  }
}
