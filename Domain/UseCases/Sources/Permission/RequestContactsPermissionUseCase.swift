//
//  RequestContactsPermissionUseCase.swift
//  UseCases
//
//  Created by summercat on 3/26/25.
//

import Contacts

public protocol RequestContactsPermissionUseCase {
  func execute() async throws -> Bool
}

final class RequestContactsPermissionUseCaseImpl: RequestContactsPermissionUseCase {
  private let contactStore: CNContactStore
  private let checkContactsPermissionUseCase: CheckContactsPermissionUseCase
  
  init(
    contactStore: CNContactStore = CNContactStore(),
    checkContactsPermissionUseCase: CheckContactsPermissionUseCase
  ) {
    self.contactStore = contactStore
    self.checkContactsPermissionUseCase = checkContactsPermissionUseCase
  }
  
  func execute() async throws -> Bool {
    // 현재 연락처 권한 상태를 확인
    let authorizationStatus = checkContactsPermissionUseCase.execute()
    
    switch authorizationStatus {
    // 아직 권한 요청을 한 적이 없는 상태이므로 권한 요청 팝업 및 사용자의 응답 결과를 반환
    case .notDetermined:
      return try await contactStore.requestAccess(for: .contacts)
      
    // 이미 권한이 허용된 상태 (일부 허용 포함)
    case .authorized, .limited:
      return true
      
    // 시스템에 의해 제한되었거나, 사용자가 거부한 상태이므로 설정으로 보내야함
    case .restricted, .denied:
      return false
      
    // 미래에 추가될 수 있는 상태 → 일단 권한 요청을 시도
    @unknown default:
      return try await contactStore.requestAccess(for: .contacts)
    }
  }
}
