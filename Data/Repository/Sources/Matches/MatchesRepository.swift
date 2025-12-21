//
//  MatchesRepository.swift
//  Repository
//
//  Created by summercat on 2/11/25.
//

import DTO
import Entities
import Foundation
import PCNetwork
import RepositoryInterfaces

final class MatchesRepository: MatchesRepositoryInterface {
  
  private let networkService: NetworkService
  
  public init (networkService: NetworkService) {
    self.networkService = networkService
  }
  
  func getMatchInfos() async throws -> [MatchInfosModel] {
    let endpoint = MatchesEndpoint.matchesInfos
    let responseDTO: [MatchInfosResponseDTO] = try await networkService.request(endpoint: endpoint)
    return responseDTO.map { $0.toDomain() }
  }
  
  func getMatchesProfileBasic(matchId: Int) async throws -> MatchProfileBasicModel {
    let endpoint = MatchesEndpoint.profile(matchId: matchId)
    let responseDTO: MatchProfileBasicResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getMatchValueTalks(matchId: Int) async throws -> MatchValueTalkModel {
    let endpoint = MatchesEndpoint.valueTalks(matchId: matchId)
    let responseDTO: MatchValueTalksResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getMatchValuePicks(matchId: Int) async throws -> MatchValuePickModel {
    let endpoint = MatchesEndpoint.valuePicks(matchId: matchId)
    let responseDTO: MatchValuePicksResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func acceptMatch(matchId: Int) async throws -> VoidModel {
    let endpoint = MatchesEndpoint.accept(matchId: matchId)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }

  func getMatchInfo() async throws -> MatchInfosModel {
    let endpoint = MatchesEndpoint.matchesInfos
    let responseDTO: MatchInfosResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }

  func refuseMatch(matchId: Int) async throws -> VoidModel {
    let endpoint = MatchesEndpoint.refuse(matchId: matchId)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func blockUser(matchId: Int) async throws -> VoidModel {
    let endpoint = MatchesEndpoint.block(matchId: matchId)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getMatchImage(matchId: Int) async throws -> MatchImageModel {
    let endpoint = MatchesEndpoint.image(matchId: matchId)
    let responseDTO: MatchImageResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getMatchContacts(matchId: Int) async throws -> MatchContactsModel {
    let endpoint = MatchesEndpoint.contacts(matchId: matchId)
    let responseDTO: MatchContactsResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func postMatchImage(matchId: Int) async throws -> VoidModel {
    let endpoint = MatchesEndpoint.buyImage(matchId: matchId)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func postMatchContacts(matchId: Int) async throws -> VoidModel {
    let endpoint = MatchesEndpoint.buyContacts(matchId: matchId)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getUserRejectReason() async throws -> UserRejectReasonModel {
    let endpoint = UserEndpoint.userReject
    let responseDTO: UserRejectReasonResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func patchCheckMatchPiece(matchId: Int) async throws -> VoidModel {
    let endpoint = MatchesEndpoint.checkMatchPiece(matchId: matchId)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func postCreateNewMatch() async throws -> CreateNewMatchModel {
    let endpoint = MatchesEndpoint.createNewMatch
    let responseDTO: CreateNewMatchResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }

  func getCanFreeMatchToday() async throws -> CanFreeMatchModel {
    let endpoint = MatchesEndpoint.canFreeMatchToday
    let responseDTO: CanFreeMatchResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
}
