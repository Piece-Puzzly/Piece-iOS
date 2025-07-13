//
// EditValuePickViewModel.swift
// EditValuePick
//
// Created by summercat on 2025/02/12.
//

import Entities
import Observation
import UseCases

@MainActor
@Observable
final class EditValuePickViewModel {
  enum Action {
    case updateValuePick(ProfileValuePickModel)
    case didTapSaveButton
  }
  
  var valuePicks: [ProfileValuePickModel] = []
  var isEditing: Bool = false
  var isEdited: Bool {
    initialValuePicks != valuePicks
  }
  
  private(set) var initialValuePicks: [ProfileValuePickModel] = []
  private let getProfileValuePicksUseCase: GetProfileValuePicksUseCase
  private let updateProfileValuePicksUseCase: UpdateProfileValuePicksUseCase
  
  init(
    getProfileValuePicksUseCase: GetProfileValuePicksUseCase,
    updateProfileValuePicksUseCase: UpdateProfileValuePicksUseCase
  ) {
    self.getProfileValuePicksUseCase = getProfileValuePicksUseCase
    self.updateProfileValuePicksUseCase = updateProfileValuePicksUseCase
    
    Task {
      await fetchProfileValuePicks()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case let .updateValuePick(model):
      if let index = valuePicks.firstIndex(where: { $0.id == model.id }) {
        valuePicks[index] = model
      }
      
    case .didTapSaveButton:
      didTapSaveButton()
    }
  }
  
  private func didTapSaveButton() {
    if isEditing {
      if isEdited {
        Task {
          await updateProfileValuePicks()
        }
      }
    } else {
      isEditing = true
    }
  }
  
  private func fetchProfileValuePicks() async {
    do {
      let valuePicks = try await getProfileValuePicksUseCase.execute()
      initialValuePicks = valuePicks
      self.valuePicks = valuePicks
      print(valuePicks)
    } catch {
      print(error)
    }
  }
  
  private func updateProfileValuePicks() async {
    do {
      _ = try await updateProfileValuePicksUseCase.execute(valuePicks: valuePicks)
      initialValuePicks = valuePicks
      isEditing = false
    } catch {
      print(error)
    }
  }
}
