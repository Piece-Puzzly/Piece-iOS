//
//  fetchContactsUseCase.swift
//  UseCases
//
//  Created by eunseou on 2/16/25.
//

import SwiftUI
import Contacts

public protocol FetchContactsUseCase {
  func execute() async throws -> [String]
}

public final class FetchContactsUseCaseImpl: FetchContactsUseCase {
  
  private let contactStore: CNContactStore
  
  public init(contactStore: CNContactStore = CNContactStore()) {
    self.contactStore = contactStore
  }
  
  public func execute() async throws -> [String] {
    var authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    
    if authorizationStatus == .notDetermined {
      let granted = try await contactStore.requestAccess(for: .contacts)
      authorizationStatus = granted ? .authorized : .denied
    }
    
    if #available(iOS 18.0, *) {
      guard authorizationStatus == .authorized || authorizationStatus == .limited else {
        return []
      }
    } else {
      guard authorizationStatus == .authorized else {
        return []
      }
    }
    
    var phoneNumbers: [String] = []
    let keysToFetch = [CNContactPhoneNumbersKey as CNKeyDescriptor]
    let request = CNContactFetchRequest(keysToFetch: keysToFetch)
    
    try contactStore.enumerateContacts(with: request) { contact, _ in
      let numbers = contact.phoneNumbers.map {
        $0.value.stringValue
      }
      phoneNumbers.append(contentsOf: numbers)
    }
    
    return phoneNumbers
  }
}
