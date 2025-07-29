//
// ReportUserViewModel.swift
// ReportUser
//
// Created by summercat on 2025/02/16.
//

import LocalStorage
import Observation
import UseCases

@Observable
final class ReportUserViewModel {
  enum Action {
    case didSelectReportReason(ReportReason?)
    case didUpdateReportReason(String)
    case didTapReportButton
    case didTapNextButton
  }
  
  let nickname: String
  let reportReasons = ReportReason.allCases
  let placeholder = "자유롭게 작성해 주세요"
  var reportReason: String = ""
  var showBlockAlert: Bool = false
  var showBlockResultAlert: Bool = false
  var showReportReasonEditor: Bool = false

  private(set) var selectedReportReason: ReportReason?
  private(set) var isBottomButtonEnabled: Bool = false
  
  private let reportUserUseCase: ReportUserUseCase
  
  init(nickname: String, reportUserUseCase: ReportUserUseCase) {
    self.nickname = nickname
    self.reportUserUseCase = reportUserUseCase
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case let .didSelectReportReason(reason):
      selectedReportReason = reason
      showReportReasonEditor = reason == .other
      updateBottomButtonEnabled()
      
    case .didTapNextButton:
      showBlockAlert = true
      
    case let .didUpdateReportReason(reason):
      let limitedText = reason.count <= 100 ? reason : String(reason.prefix(100))
      reportReason = limitedText
      updateBottomButtonEnabled()
      
    case .didTapReportButton:
      showBlockAlert = false
      Task { await reportUser() }
    }
  }
  
  private func reportUser() async {
    do {
      let reason = selectedReportReason == .other ? reportReason : selectedReportReason?.rawValue ?? ""
      if let id = PCUserDefaultsService.shared.getMatchedUserId() {
        _ = try await reportUserUseCase.execute(id: id, reason: reason)
        showBlockResultAlert = true
      }
    } catch {
      print(error)
    }
  }
  
  private func updateBottomButtonEnabled() {
    if let selected = selectedReportReason {
      if selected == .other {
        isBottomButtonEnabled = !reportReason.isEmpty
      } else {
        isBottomButtonEnabled = true
      }
    } else {
      isBottomButtonEnabled = false
    }
  }
}
