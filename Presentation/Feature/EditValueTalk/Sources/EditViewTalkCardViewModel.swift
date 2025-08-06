//
//  EditViewTalkCardViewModel.swift
//  EditValueTalk
//
//  Created by summercat on 2/9/25.
//

import Combine
import Entities
import Foundation

@MainActor
@Observable
final class EditValueTalkCardViewModel: Equatable {
  static func == (lhs: EditValueTalkCardViewModel, rhs: EditValueTalkCardViewModel) -> Bool {
    lhs.model == rhs.model
  }
  
  enum Constants {
    static let minAnswerLength: Int = 30
    static let maxAnswerLength: Int = 300
  }
  
  enum Action {
    case initializeTextEditorLayout
    case didUpdateAnswer(String)
    case didUpdateSummary(String)
    case didTapSummaryButton
    case didTapTooltipButton
  }
  
  enum EditingState {
    case viewing
    case editingAnswer
    case editingSummary
    case generatingAISummary
  }
  
  var model: ProfileValueTalkModel
  let index: Int
  let isEditingAnswer: Bool
  var localSummary: String
  var showTooltip: Bool = false
  var currentGuideText: String {
    model.guides[guideTextIndex]
  }
  var isAnswerValid: Bool {
    model.answer.count >= Constants.minAnswerLength
    && model.answer.count <= Constants.maxAnswerLength
  }
  
  private(set) var editingState: EditingState = .viewing
  private(set) var guideTextIndex: Int = 0
  private(set) var answerText: String = ""
  private var cancellables: [AnyCancellable] = []
  
  let onModelUpdate: (ProfileValueTalkModel) -> Void
  let onSummaryUpdate: (ProfileValueTalkModel) -> Void
  
  init(
    model: ProfileValueTalkModel,
    index: Int,
    isEditingAnswer: Bool,
    onModelUpdate: @escaping (ProfileValueTalkModel) -> Void,
    onSummaryUpdate: @escaping (ProfileValueTalkModel) -> Void
  ) {
    self.model = model
    self.index = index
    self.isEditingAnswer = isEditingAnswer
    self.onModelUpdate = onModelUpdate
    self.onSummaryUpdate = onSummaryUpdate
    self.localSummary = model.summary
    startTimer()
  }
  
  func handleAction(_ action: Action) {
    switch action {
      /// TextEditor 높이 계산을 위한 초기 텍스트 설정 (SwiftUI 렌더링 타이밍 이슈 해결)
    case .initializeTextEditorLayout:
      self.answerText = model.answer
      
    case let .didUpdateAnswer(answer):
      syncAnswerTextModel(answer)
      onModelUpdate(model)
      
    case let .didUpdateSummary(summary):
      localSummary = summary
      
    case .didTapSummaryButton:
      didTapSummaryButton()
      
    case .didTapTooltipButton:
      if !showTooltip {
        startTooltipAutoHide()
      }
    }
  }
  
  func updateSummary(_ summary: String) {
    localSummary = summary
    model.summary = summary
    editingState = .viewing
  }
  
  func syncAnswerTextModel(_ answer: String) {
    let limitedAnswer = String(answer.prefix(Constants.maxAnswerLength))
    model.answer = limitedAnswer
    answerText = limitedAnswer
  }
  
  func startGeneratingAISummary() {
    editingState = .generatingAISummary
  }

  private func increaseGuideTextIndex() {
    guideTextIndex = (guideTextIndex + 1) % model.guides.count
  }
  
  private func didTapSummaryButton() {
    switch editingState {
    case .viewing:
      editingState = .editingSummary
      
    case .editingAnswer:
      break
      
    case .editingSummary:
      model.summary = localSummary
      onSummaryUpdate(model)
      editingState = .viewing
      
    case .generatingAISummary:
      break
    }
  }
  
  private func startTimer() {
    Timer.publish(every: 3, on: .main, in: .common).autoconnect()
      .sink { [weak self] _ in
        self?.increaseGuideTextIndex()
      }
      .store(in: &cancellables)
  }
  
  private func startTooltipAutoHide() {
    showTooltip = true
    
    Task {
      try? await Task.sleep(for: .seconds(5))
      await MainActor.run {
        showTooltip = false
      }
    }
  }
}
