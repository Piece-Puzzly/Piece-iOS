//
//  NotificationRepository.swift
//  Repository
//
//  Created by summercat on 3/15/25.
//

import DTO
import PCNetwork
import Entities
import RepositoryInterfaces

public final class NotificationRepository: NotificationRepositoryInterface {
  private let networkService: NetworkService
  private let pageSize = 10
  private var cursor: Int? = nil
  private var isEnd = false
  
  public init (networkService: NetworkService) {
    self.networkService = networkService
  }
  
  public func getNotifications() async throws -> (notifications: [Entities.NotificationModel], isEnd: Bool) {
    if isEnd {
      return ([], isEnd)
    }
    
    let endpoint = NotificationsEndpoint.notifications(cursor: cursor)
    let responseDTO: [NotificationResponseDTO] = try await networkService.request(endpoint: endpoint)
    if responseDTO.count == pageSize {
      if let lastId = responseDTO.last?.notificationId {
        cursor = lastId
      }
      return (notifications: responseDTO.compactMap { $0.toDomain() }, isEnd: isEnd)
    } else {
      isEnd = true
      return (notifications: responseDTO.compactMap { $0.toDomain() }, isEnd: isEnd)
    }
  }
  
  public func readNotification(id: Int) async throws -> VoidModel {
    let endpoint = NotificationsEndpoint.readNotification(id: id)
    let responseDTO: VoidResponseDTO = try await networkService.request(endpoint: endpoint)
    return responseDTO.toDomain()
  }
  
  public func getUnreadCount() async throws -> Int {
    let endpoint = NotificationsEndpoint.unreadCount
    let responseDTO: Int = try await networkService.request(endpoint: endpoint)
    return responseDTO
  }
}
