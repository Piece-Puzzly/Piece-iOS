//
//  CreateEditRejectedProfileContainerViewModel.swift
//  SignUp
//
//  Created by 홍승완 on 8/24/25.
//

import Entities
import Observation
import Router
import SwiftUI
import UseCases

@Observable
final class CreateEditRejectedProfileContainerViewModel {
  enum CreateEditRejectedProfileStep: Hashable {
    case basicInfo
    case valuePick
    case valueTalk
  }

  enum Action {
    case didTapBackButton
    case didTapBottomButton
  }
  
  var currentStep: CreateEditRejectedProfileStep = .basicInfo
  var valuePickViewModel: EditRejectedValuePickViewModel?
  var valueTalkViewModel: EditRejectedValueTalkViewModel?

  let editRejectedProfileCreator = EditRejectedProfileCreator()
  
  let getProfileBasicUseCase: GetProfileBasicUseCase
  let checkNicknameUseCase: CheckNicknameUseCase
  let uploadProfileImageUseCase: UploadProfileImageUseCase
  let getProfileValuePicksUseCase: GetProfileValuePicksUseCase
  let getProfileValueTalksUseCase: GetProfileValueTalksUseCase

  private(set) var error: Error?
  private(set) var destination: Route?
  
  init(
    getProfileBasicUseCase: GetProfileBasicUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase,
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase,
    getProfileValuePicksUseCase: GetProfileValuePicksUseCase
  ) {
    self.getProfileBasicUseCase = getProfileBasicUseCase
    self.checkNicknameUseCase = checkNicknameUseCase
    self.uploadProfileImageUseCase = uploadProfileImageUseCase
    self.getProfileValuePicksUseCase = getProfileValuePicksUseCase
    self.getProfileValueTalksUseCase = getProfileValueTalksUseCase
    
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
      let fetchedProfileValuePicks: [ValuePickModel] = try await getProfileValuePicksUseCase.execute().map { $0.toValuePickModel() }
      let fetchedValueTalks: [ValueTalkModel] = try await getProfileValueTalksUseCase.execute().map { $0.toValueTalkModel() }
      
      editRejectedProfileCreator.updateValuePicks(fetchedProfileValuePicks)
      editRejectedProfileCreator.updateValueTalks(fetchedValueTalks)

      self.valuePickViewModel = EditRejectedValuePickViewModel(
        editRejectedProfileCreator: editRejectedProfileCreator,
        initialValuePicks: fetchedProfileValuePicks
      )
      self.valueTalkViewModel = EditRejectedValueTalkViewModel(
        editRejectedProfileCreator: editRejectedProfileCreator,
        initialValueTalks: fetchedValueTalks
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
       editRejectedProfileCreator.isProfileValid() {
      createProfile()
    }
  }
    
  private func createProfile() {
    let profile = editRejectedProfileCreator.createEditRejectedProfile()
    destination = .editRejectedWaitingAISummary(profile: profile)
  }
}
