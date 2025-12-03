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
  
  func getMatchesProfileBasic() async throws -> MatchProfileBasicModel {
    let endpoint = MatchesEndpoint.profileBasic
    let responseDTO: MatchProfileBasicResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getMatchValueTalks() async throws -> MatchValueTalkModel {
    let endpoint = MatchesEndpoint.valueTalks
    let responseDTO: MatchValueTalksResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getMatchValuePicks() async throws -> MatchValuePickModel {
    let endpoint = MatchesEndpoint.valuePicks
    let responseDTO: MatchValuePicksResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func acceptMatch() async throws -> VoidModel {
    let endpoint = MatchesEndpoint.accept
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  

  func getMatchInfo() async throws -> MatchInfosModel {
    let endpoint = MatchesEndpoint.matchesInfos
    let responseDTO: MatchInfosResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }

  func refuseMatch() async throws -> VoidModel {
    let endpoint = MatchesEndpoint.refuse
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func blockUser(matchId: Int) async throws -> VoidModel {
    let endpoint = MatchesEndpoint.block(matchId: matchId)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getMatchImage() async throws -> MatchImageModel {
    let endpoint = MatchesEndpoint.image
    let responseDTO: MatchImageResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getMatchContacts() async throws -> MatchContactsModel {
    let endpoint = MatchesEndpoint.contacts
    let responseDTO: MatchContactsResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func getUserRejectReason() async throws -> UserRejectReasonModel {
    let endpoint = UserEndpoint.userReject
    let responseDTO: UserRejectReasonResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  func patchCheckMatchPiece() async throws -> VoidModel {
    let endpoint = MatchesEndpoint.checkMatchPiece
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
}
