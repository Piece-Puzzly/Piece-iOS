//
// EditValuePickViewModel.swift
// EditValuePick
//
// Created by summercat on 2025/02/12.
//

import Entities
import Observation
import UseCases
import SwiftUI
import DesignSystem

@MainActor
@Observable
final class EditValuePickViewModel {
  enum Action {
    case updateValuePick(ProfileValuePickModel)
    case didTapSaveButton
    case popBack
    case didTapBackButton
    case didTapCloseAlert
  }
  
  var valuePicks: [ProfileValuePickModel] = []
  var toastMessage: ToastMessage? = nil
  var isEditing: Bool = false
  var isEdited: Bool {
    initialValuePicks != valuePicks
  }
  var showValuePickExitAlert: Bool = false
  var shouldPopBack: Bool = false
  
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
      
    case .popBack:
      handlePopBack()
      
    case .didTapCloseAlert:
      hideAlert()
      
    case .didTapBackButton:
      isEditing ? showExitAlert() : setPopBack()
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
      setToastMessage(for: .profileUpdated)
    } catch {
      setToastMessage(for: .profileUpdateFailure)
      print(error)
    }
  }
  
  private func handlePopBack() {
    Task {
      hideAlert()
      try? await Task.sleep(for: .milliseconds(100))
      setPopBack()
    }
  }
}

// MARK: EditValuePick ExitAlert func
private extension EditValuePickViewModel {
  func showExitAlert() {
    showValuePickExitAlert = true
  }
  
  func hideAlert() {
    showValuePickExitAlert = false
  }
  
  func setPopBack() {
    shouldPopBack = true
  }
}

// MARK: - ToastMessage
extension EditValuePickViewModel {
  enum ToastMessage {
    case profileUpdated
    case profileUpdateFailure
    
    var text: String {
      switch self {
      case .profileUpdated:
        return "프로필이 수정되었어요"
      case .profileUpdateFailure:
        return "네트워크 연결이 불안정해요"
      }
    }
    
    var icon: Image? {
      switch self {
      case .profileUpdated:
        return nil
      case .profileUpdateFailure:
        return DesignSystemAsset.Icons.notice20.swiftUIImage
      }
    }
  }
  
  var showToastBinding: Binding<Bool> {
    return Binding<Bool>(
      get: { self.toastMessage != nil },
      set: { isVisible in
        if !isVisible { self.toastMessage = nil }
      }
    )
  }
  
  private func setToastMessage(for message: ToastMessage?) {
    self.toastMessage = message
  }
}
