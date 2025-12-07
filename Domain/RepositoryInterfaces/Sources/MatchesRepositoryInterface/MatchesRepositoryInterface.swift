//
//  MatchesRepositoryInterface.swift
//  RepositoryInterfaces
//
//  Created by summercat on 2/11/25.
//

import Entities

public protocol MatchesRepositoryInterface {
  func getMatchInfos() async throws -> [MatchInfosModel]
  func getMatchesProfileBasic(matchId: Int) async throws -> MatchProfileBasicModel
  func getMatchValueTalks(matchId: Int) async throws -> MatchValueTalkModel
  func getMatchValuePicks(matchId: Int) async throws -> MatchValuePickModel
  func acceptMatch(matchId: Int) async throws -> VoidModel
  func refuseMatch(matchId: Int) async throws -> VoidModel
  func blockUser(matchId: Int) async throws -> VoidModel
  func getMatchImage(matchId: Int) async throws -> MatchImageModel
  func getMatchContacts(matchId: Int) async throws -> MatchContactsModel
  func getUserRejectReason() async throws -> UserRejectReasonModel
  func patchCheckMatchPiece(matchId: Int) async throws -> VoidModel
  func postCreateNewMatch() async throws -> CreateNewMatchModel
  func getCanFreeMatchToday() async throws -> CanFreeMatchModel
}
