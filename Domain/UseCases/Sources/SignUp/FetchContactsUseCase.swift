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
    var allPhoneNumbers: [String] = []
    let keysToFetch = [CNContactPhoneNumbersKey as CNKeyDescriptor]
    let request = CNContactFetchRequest(keysToFetch: keysToFetch)
    
    try contactStore.enumerateContacts(with: request) { contact, _ in
      let contactPhoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
      allPhoneNumbers.append(contentsOf: contactPhoneNumbers)
    }
    
    return allPhoneNumbers
  }
}
