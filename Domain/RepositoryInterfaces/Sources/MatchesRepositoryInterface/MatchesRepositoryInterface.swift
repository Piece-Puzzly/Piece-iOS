//
//  MatchesRepositoryInterface.swift
//  RepositoryInterfaces
//
//  Created by summercat on 2/11/25.
//

import Entities

public protocol MatchesRepositoryInterface {
  func getMatchInfos() async throws -> [MatchInfosModel]
  func getMatchesProfileBasic() async throws -> MatchProfileBasicModel
  func getMatchValueTalks() async throws -> MatchValueTalkModel
  func getMatchValuePicks() async throws -> MatchValuePickModel
  func acceptMatch() async throws -> VoidModel
  func refuseMatch() async throws -> VoidModel
  func blockUser(matchId: Int) async throws -> VoidModel
  func getMatchImage() async throws -> MatchImageModel
  func getMatchContacts() async throws -> MatchContactsModel
  func getUserRejectReason() async throws -> UserRejectReasonModel
  func patchCheckMatchPiece() async throws -> VoidModel
  func postCreateNewMatch() async throws -> CreateNewMatchModel
}
