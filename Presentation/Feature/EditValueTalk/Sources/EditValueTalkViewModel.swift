//
// EditValueTalkViewModel.swift
// EditValueTalk
//
// Created by summercat on 2025/02/13.
//

import Entities
import Observation
import UseCases
import SwiftUI
import DesignSystem
import PCNetworkMonitor

@MainActor
@Observable
final class EditValueTalkViewModel {
  enum Action {
    case onNetworkStatusChanged(PCNetworkMonitor.NetworkEvent)
    case onAppear
    case updateValueTalk(ProfileValueTalkModel)
    case updateAISummaryFromSSE(AISummaryModel)
    case updateAISummaryManually(ProfileValueTalkModel)
    case didTapSaveButton
    case onDisappear
    case didTapCancelEditing
    case didTapBackButton
    case didTapCloseAlert
  }
  
  var valueTalks: [ProfileValueTalkModel] = []
  var cardViewModels: [EditValueTalkCardViewModel] = []
  var toastMessage: ToastMessage? = nil
  var isEditing: Bool = false
  var isEdited: Bool {
    initialValueTalks.map { $0.answer } != valueTalks.map { $0.answer }
  }
  var isAllAnswerValid: Bool {
    isEdited && cardViewModels.allSatisfy { $0.isAnswerValid }
  }
  var showValueTalkExitAlert: Bool = false
  var shouldPopBack: Bool = false
  
  private(set) var initialValueTalks: [ProfileValueTalkModel] = []
  private let getProfileValueTalksUseCase: GetProfileValueTalksUseCase
  private let updateProfileValueTalksUseCase: UpdateProfileValueTalksUseCase
  private let updateProfileValueTalkSummaryUseCase: UpdateProfileValueTalkSummaryUseCase
  private let connectSseUseCase: ConnectSseUseCase
  private let disconnectSseUseCase: DisconnectSseUseCase
  
  private var sseTask: Task<Void, Never>?
  
  init(
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase,
    updateProfileValueTalksUseCase: UpdateProfileValueTalksUseCase,
    updateProfileValueTalkSummaryUseCase: UpdateProfileValueTalkSummaryUseCase,
    connectSseUseCase: ConnectSseUseCase,
    disconnectSseUseCase: DisconnectSseUseCase
  ) {
    self.getProfileValueTalksUseCase = getProfileValueTalksUseCase
    self.updateProfileValueTalksUseCase = updateProfileValueTalksUseCase
    self.updateProfileValueTalkSummaryUseCase = updateProfileValueTalkSummaryUseCase
    self.connectSseUseCase = connectSseUseCase
    self.disconnectSseUseCase = disconnectSseUseCase
    
    Task {
      await fetchValueTalks()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .onNetworkStatusChanged(let event):
      Task {
        await handleNetworkEvent(to: event)
      }
      
    case .onAppear:
      Task {
        await connectSse()
      }
      
    case let .updateValueTalk(model):
      handleValueTalkUpdate(model)
      
    case let .updateAISummaryFromSSE(summary):
      handleUpdateAISummaryFromSSE(summary)
      
    case let .updateAISummaryManually(model):
      handleUpdateAISummaryManually(model)
      
    case .didTapSaveButton:
      Task {
        await didTapSaveButton()
      }
      
    case .onDisappear:
      Task {
        await disconnectSse()
      }
      
    case .didTapCancelEditing:
      handleDidTapCancelEditing()
      
    case .didTapCloseAlert:
      hideAlert()
      
    case .didTapBackButton:
      handleDidTapBackButton()
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
      } else if isEdited {
        setToastMessage(for: .minLengthError)
      }
    } else {
      isEditing = true
    }
  }
  
  private func fetchValueTalks() async {
    do {
      let valueTalks = try await getProfileValueTalksUseCase.execute()
      initialValueTalks = valueTalks
      setupValueTalks(for: valueTalks)
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
  
  // MARK: 저장 시 AI 요약 스켈레톤 UI도 함께 처리해야합니다.
  private func updateProfileValueTalks() async {
    do {
      cardViewModels.forEach { $0.startGeneratingAISummary() }
      let updatedValueTalks = try await updateProfileValueTalksUseCase.execute(valueTalks: valueTalks)
      initialValueTalks = updatedValueTalks
      handleDidTapBackButton()
    } catch {
      print(error)
    }
  }
  
  // MARK: - Network Status Change
  private func handleNetworkEvent(to eventStatus: PCNetworkMonitor.NetworkEvent) async {
    switch eventStatus {
    case .connected:
      await disconnectSse()
      await connectSse()
    
    case .disconnected:
      await disconnectSse()
      
    case .interfaceChanged(_, _):
      await disconnectSse()
      await connectSse()
    }
  }
  
  // MARK: - AI 요약 관련
  
  private func connectSse() async {
    sseTask = Task {
      do {
        for try await createdSummary in connectSseUseCase.execute() {
          handleAction(.updateAISummaryFromSSE(createdSummary))
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
  
  private func handleUpdateAISummaryFromSSE(_ summary: AISummaryModel) {
    if let index = valueTalks.firstIndex(where: { $0.id == summary.profileValueTalkId }) {
      valueTalks[index].summary = summary.summary
      cardViewModels[index].updateSummary(summary.summary)
    }
  }
  
  private func handleUpdateAISummaryManually(_ model: ProfileValueTalkModel) {
    // AI 요약만 업데이트하는 API 콜
    Task {
      _ = try await updateProfileValueTalkSummaryUseCase.execute(
        profileTalkId: model.id,
        summary: model.summary
      )
    }
    
    // initial 및 기타 모델들을 모두 업데이트 해주어야 함
    if let index = valueTalks.firstIndex(where: { $0.id == model.id }) {
      initialValueTalks[index] = model
      valueTalks[index] = model
      cardViewModels[index].model = model
    }
  }
  
  private func setupValueTalks(for valueTalks: [ProfileValueTalkModel]) {
    self.valueTalks = valueTalks
    cardViewModels = valueTalks.enumerated().map { index, valueTalk in
      EditValueTalkCardViewModel(
        model: valueTalk,
        index: index,
        isEditingAnswer: false,
        onModelUpdate: { [weak self] updatedModel in
          self?.handleAction(.updateValueTalk(updatedModel))
        },
        onSummaryUpdate: { [weak self] updatedModel in
          self?.handleAction(.updateAISummaryManually(updatedModel))
        }
      )
    }
  }
  
  private func handleDidTapCancelEditing() {
    Task {
      hideAlert()
      try? await Task.sleep(for: .milliseconds(100))
      cancelEditingMode()
    }
  }
  
  private func cancelEditingMode() {
    isEditing = false
    setupValueTalks(for: initialValueTalks)
  }
}

// MARK: EditValueTalk ExitAlert func
private extension EditValueTalkViewModel {
  func handleDidTapBackButton() {
    !isEditing
    ? setPopBack()
    : isEdited ? showAlert() : { isEditing = false }()
  }
  
  func showAlert() {
    showValueTalkExitAlert = true
  }
  
  func hideAlert() {
    showValueTalkExitAlert = false
  }
  
  func setPopBack() {
    shouldPopBack = true
  }
}

// MARK: - ToastMessage
extension EditValueTalkViewModel {
  enum ToastMessage {
    case minLengthError
    
    var text: String {
      switch self {
      case .minLengthError:
        return "모든 항목을 작성해 주세요"
      }
    }
    
    var icon: Image? {
      switch self {
      case .minLengthError:
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
