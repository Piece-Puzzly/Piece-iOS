//
//  CreateProfileContainerViewModel.swift
//  SignUp
//
//  Created by summercat on 2/8/25.
//

import Entities
import Observation
import Router
import SwiftUI
import UseCases

@Observable
final class CreateProfileContainerViewModel {
  enum CreateProfileStep: Hashable {
    case basicInfo
    case valuePick
    case valueTalk
  }

  enum Action {
    case didTapBackButton
    case didTapBottomButton
  }
  
  var currentStep: CreateProfileStep = .basicInfo
  var valuePickViewModel: ValuePickViewModel?
  var valueTalkViewModel: ValueTalkViewModel?
  
  let profileCreator = ProfileCreator()
  let checkNicknameUseCase: CheckNicknameUseCase
  let uploadProfileImageUseCase: UploadProfileImageUseCase
  let getValueTalksUseCase: GetValueTalksUseCase
  let getValuePicksUseCase: GetValuePicksUseCase
  
  private(set) var valueTalks: [ValueTalkModel] = []
  private(set) var error: Error?
  private(set) var destination: Route?
  
  init(
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase,
    getValueTalksUseCase: GetValueTalksUseCase,
    getValuePicksUseCase: GetValuePicksUseCase
  ) {
    self.checkNicknameUseCase = checkNicknameUseCase
    self.uploadProfileImageUseCase = uploadProfileImageUseCase
    self.getValueTalksUseCase = getValueTalksUseCase
    self.getValuePicksUseCase = getValuePicksUseCase
    
    Task {
      await fetchInitialData()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .didTapBackButton:
      didTapBackButton()
      
    case .didTapBottomButton:
      didTapBottomButton()
    }
  }
  
  @MainActor
  private func fetchInitialData() async {
    do {
      async let talks = getValueTalksUseCase.execute()
      async let picks = getValuePicksUseCase.execute()
      
      let (fetchedTalks, fetchedPicks) = try await (talks, picks)
      self.valueTalks = fetchedTalks
      let valuePicks = fetchedPicks.map {
        ProfileValuePickModel(
          id: $0.id,
          category: $0.category,
          question: $0.question,
          answers: $0.answers,
          selectedAnswer: nil
        )
      }
      self.valuePickViewModel = ValuePickViewModel(
        profileCreator: profileCreator,
        initialValuePicks: valuePicks
      )
      
      self.valueTalkViewModel = ValueTalkViewModel(
        profileCreator: profileCreator,
        initialValueTalks: valueTalks
      )

      error = nil
    } catch {
      self.error = error
      print(error)
    }
  }
  
  private func didTapBackButton() {
    switch currentStep {
    case .basicInfo: break
    case .valuePick: currentStep = .basicInfo
    case .valueTalk: currentStep = .valuePick
    }
  }
  
  private func didTapBottomButton() {
    switch currentStep {
    case .basicInfo: currentStep = .valuePick
    case .valuePick: currentStep = .valueTalk
    case .valueTalk: break
    }
    
    if currentStep == .valueTalk,
       profileCreator.isProfileValid() {
      createProfile()
    }
  }
    
  private func createProfile() {
    let profile = profileCreator.createProfile()
    destination = .waitingAISummary(profile: profile)
  }
}
