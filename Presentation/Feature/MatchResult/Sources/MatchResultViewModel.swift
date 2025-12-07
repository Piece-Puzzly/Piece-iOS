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
  
  let nickname: String
  var contacts: [ContactButtonModel] = []
  private(set) var selectedContact: ContactButtonModel?
  private(set) var imageUri: String = ""
  private(set) var matchingAnimationOpacity: Double = 1
  private(set) var photoOpacity: Double = 0
  
  private(set) var matchId: Int
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let getMatchContactsUseCase: GetMatchContactsUseCase
  
  init(
    matchId: Int,
    nickname: String,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    getMatchContactsUseCase: GetMatchContactsUseCase
  ) {
    self.matchId = matchId
    self.nickname = nickname
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
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
      await getMatchPhoto()
    }
  }
  
  private func getMatchPhoto() async {
    do {
      let imageUri = try await getMatchPhotoUseCase.execute(matchId: matchId)
      self.imageUri = imageUri
    } catch {
      print(error)
    }
  }
  
  private func getMatchContacts() async {
    do {
      let contacts = try await getMatchContactsUseCase.execute(matchId: matchId).contacts
      self.contacts = contacts.map { ContactButtonModel(contact: $0) }
      selectedContact = self.contacts.first
    } catch {
      print(error)
    }
  }
}
