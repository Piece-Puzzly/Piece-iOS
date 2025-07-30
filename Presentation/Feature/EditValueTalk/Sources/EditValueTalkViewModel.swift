//
// EditValueTalkViewModel.swift
// EditValueTalk
//
// Created by summercat on 2025/02/13.
//

import Entities
import Observation
import UseCases

@MainActor
@Observable
final class EditValueTalkViewModel {
  enum Action {
    case onAppear
    case updateValueTalk(ProfileValueTalkModel)
    case didTapSaveButton
    case onDisappear
    case popBack
    case didTapBackButton
    case didTapCloseAlert
  }
  
  var valueTalks: [ProfileValueTalkModel] = []
  var cardViewModels: [EditValueTalkCardViewModel] = []
  var isEditing: Bool = false
  var isEdited: Bool {
    initialValueTalks.map { $0.answer } != valueTalks.map { $0.answer }
  }
  var isAllAnswerValid: Bool {
    cardViewModels.allSatisfy { $0.isAnswerValid }
  }
  var showValueTalkExitAlert: Bool = false
  var shouldPopBack: Bool = false
  
  private(set) var initialValueTalks: [ProfileValueTalkModel] = []
  private let getProfileValueTalksUseCase: GetProfileValueTalksUseCase
  private let updateProfileValueTalksUseCase: UpdateProfileValueTalksUseCase
  private let connectSseUseCase: ConnectSseUseCase
  private let disconnectSseUseCase: DisconnectSseUseCase
  
  private var sseTask: Task<Void, Never>?
  
  init(
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase,
    updateProfileValueTalksUseCase: UpdateProfileValueTalksUseCase,
    connectSseUseCase: ConnectSseUseCase,
    disconnectSseUseCase: DisconnectSseUseCase
  ) {
    self.getProfileValueTalksUseCase = getProfileValueTalksUseCase
    self.updateProfileValueTalksUseCase = updateProfileValueTalksUseCase
    self.connectSseUseCase = connectSseUseCase
    self.disconnectSseUseCase = disconnectSseUseCase
    
    Task {
      await fetchValueTalks()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        await connectSse()
      }
      
    case let .updateValueTalk(model):
      handleValueTalkUpdate(model)
      
    case .didTapSaveButton:
      Task {
        await didTapSaveButton()
      }
      
    case .onDisappear:
      Task {
        await disconnectSse()
      }
      
    case .popBack:
      handlePopBack()
      
    case .didTapCloseAlert:
      hideAlert()
      
    case .didTapBackButton:
      isEditing ? showExitAlert() : setPopBack()
    }
  }
  
  private func didTapSaveButton() async {
    if isEditing {
      for cardViewModel in cardViewModels {
        if let index = valueTalks.firstIndex(where: { $0.id == cardViewModel.model.id }) {
          valueTalks[index] = cardViewModel.model
        }
      }
      if isAllAnswerValid {
        await updateProfileValueTalks()
      }
    } else {
      isEditing = true
    }
  }
  
  private func fetchValueTalks() async {
    do {
      let valueTalks = try await getProfileValueTalksUseCase.execute()
      initialValueTalks = valueTalks
      self.valueTalks = valueTalks
      cardViewModels = valueTalks.enumerated().map { index, valueTalk in
        EditValueTalkCardViewModel(
          model: valueTalk,
          index: index,
          isEditingAnswer: false,
          onModelUpdate: { [weak self] updatedModel in
            self?.handleValueTalkUpdate(updatedModel)
          }
        )
      }
      print(valueTalks)
    } catch {
      print(error)
    }
  }
  
  private func handleValueTalkUpdate(_ model: ProfileValueTalkModel) {
    if let index = valueTalks.firstIndex(where: { $0.id == model.id }) {
      valueTalks[index] = model
      cardViewModels[index].model = model
    }
  }
  
  private func updateProfileValueTalks() async {
    do {
      print("update called")
      print(valueTalks)
      let updatedValueTalks = try await updateProfileValueTalksUseCase.execute(valueTalks: valueTalks)
      print("updated")
      print(updatedValueTalks)
      initialValueTalks = updatedValueTalks
      isEditing = false
    } catch {
      print(error)
    }
  }
  
  // MARK: - AI 요약 관련
  
  private func connectSse() async {
    sseTask = Task {
      do {
        for try await createdSummary in connectSseUseCase.execute() {
          handleSummaryUpdate(createdSummary)
        }
      } catch {
        print(error)
      }
    }
  }
  
  
  private func disconnectSse() async {
    do {
      _ = try await disconnectSseUseCase.execute()
      sseTask?.cancel()
      
    } catch {
      print(error)
    }
  }
  
  private func handleSummaryUpdate(_ summary: AISummaryModel) {
    if let index = valueTalks.firstIndex(where: { $0.id == summary.profileValueTalkId }) {
      valueTalks[index].summary = summary.summary
      cardViewModels[index].updateSummary(summary.summary)
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

// MARK: EditValueTalk ExitAlert func
private extension EditValueTalkViewModel {
  func showExitAlert() {
    showValueTalkExitAlert = true
  }
  
  func hideAlert() {
    showValueTalkExitAlert = false
  }
  
  func setPopBack() {
    shouldPopBack = true
  }
}
