//
//  ProfileEndpoint.swift
//  PCNetwork
//
//  Created by summercat on 2/9/25.
// 

import Alamofire
import DTO
import Foundation
import LocalStorage

public enum ProfileEndpoint: TargetType {
  case postProfile(PostProfileRequestDTO)
  case putProfile(PutProfileRequestDTO)
  case postCheckNickname(String)
  case postUploadImage(Data)
  case getProfileBasic
  case updateProfileBasic(ProfileBasicRequestDTO)
  case getValueTalks
  case updateValueTalks(ProfileValueTalksRequestDTO)
  case getValuePicks
  case updateValuePicks(ProfileValuePicksRequestDTO)
  case updateValueTalkSummary(profileTalkId: Int, dto: ProfileValueTalkSummaryRequestDTO)
  
  public var method: HTTPMethod {
    switch self {
    case .postProfile: .post
    case .putProfile: .put
    case .postCheckNickname: .post
    case .postUploadImage: .post
    case .getProfileBasic: .get
    case .updateProfileBasic: .put
    case .getValueTalks: .get
    case .updateValueTalks: .put
    case .getValuePicks: .get
    case .updateValuePicks: .put
    case .updateValueTalkSummary: .patch
    }
  }
  
  public var path: String {
    switch self {
    case .postProfile: "api/profiles"
    case .putProfile: "api/profiles"
    case .postCheckNickname: "api/profiles/check-nickname"
    case .postUploadImage: "api/profiles/images"
    case .getProfileBasic, .updateProfileBasic: "api/profiles/basic"
    case .getValueTalks: "api/profiles/valueTalks"
    case .updateValueTalks: "api/profiles/valueTalks"
    case .getValuePicks: "api/profiles/valuePicks"
    case .updateValuePicks: "api/profiles/valuePicks"
    case let .updateValueTalkSummary(profileTalkId, _): "api/profiles/valueTalks/\(profileTalkId)/summary"
    }
  }
  
  public var headers: [String : String] {
    switch self {
    case .postProfile:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? ""),
        NetworkHeader.contentType: NetworkHeader.applicationJson,
      ]
    case .putProfile:
      [
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? ""),
        NetworkHeader.contentType: NetworkHeader.applicationJson,
      ]
    case .postCheckNickname:
      [NetworkHeader.accept : NetworkHeader.all]
    case .postUploadImage:
      [NetworkHeader.contentType : NetworkHeader.multipartFormData]
      
    case .getProfileBasic:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .updateProfileBasic:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .getValueTalks:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .updateValueTalks:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .getValuePicks:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .updateValuePicks:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    case .updateValueTalkSummary:
      [
        NetworkHeader.contentType: NetworkHeader.applicationJson,
        NetworkHeader.authorization: NetworkHeader.bearer(PCKeychainManager.shared.read(.accessToken) ?? "")
      ]
    }
  }
  
  public var requestType: RequestType {
    switch self {
    case let .postProfile(dto): .body(dto)
    case let .putProfile(dto): .body(dto)
    case let .postCheckNickname(string): .query([URLQueryItem(name: "nickname", value: string)])
    case let .postUploadImage(data): .multipart(data)
    case .getProfileBasic: .plain
    case let .updateProfileBasic(dto): .body(dto)
    case .getValueTalks: .plain
    case let .updateValueTalks(dto): .body(dto)
    case .getValuePicks: .plain
    case let .updateValuePicks(dto): .body(dto)
    case let .updateValueTalkSummary(_, dto): .body(dto)
    }
  }
}
