//
// MatchResultViewModel.swift
// MatchResult
//
// Created by summercat on 2025/02/20.
//

import Entities
import Observation
import UseCases
import UIKit

@Observable
final class MatchResultViewModel {
  enum Action {
    case onAppear
    case matchingAnimationDidFinish(Bool)
    case showProfilePhoto
    case didTapContactIcon(ContactButtonModel)
    case didTapCopyButton
  }
  
  var contacts: [ContactButtonModel] = []
  private(set) var selectedContact: ContactButtonModel?
  private(set) var imageUri: String = ""
  private(set) var matchingAnimationOpacity: Double = 1
  private(set) var photoOpacity: Double = 0
  
  private(set) var matchId: Int
  private(set) var nickname: String = ""
  private let getMatchContactsUseCase: GetMatchContactsUseCase
  
  init(
    matchId: Int,
    getMatchContactsUseCase: GetMatchContactsUseCase
  ) {
    self.matchId = matchId
    self.getMatchContactsUseCase = getMatchContactsUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      onAppear()
      
    case let .matchingAnimationDidFinish(didFinish):
      matchingAnimationOpacity = didFinish ? 0 : 1
      
    case .showProfilePhoto:
      photoOpacity = 1
      
    case let .didTapContactIcon(contact):
      selectedContact = contact
      break
      
    case .didTapCopyButton:
      UIPasteboard.general.string = selectedContact?.value
    }
  }
  
  private func onAppear() {
    Task {
      await getMatchContacts()
    }
  }
  
  private func getMatchContacts() async {
    do {
      let result = try await getMatchContactsUseCase.execute(matchId: matchId)
      self.contacts = result.contacts.map { ContactButtonModel(contact: $0) }
      self.imageUri = result.imageUrl
      self.nickname = result.nickname
      selectedContact = self.contacts.first
    } catch {
      print(error)
    }
  }
}
