//
//  EditRejectedValueTalkViewModel.swift
//  SignUp
//
//  Created by 홍승완 on 8/24/25.
//

import Entities
import Observation
import SwiftUI
import UseCases

@MainActor
@Observable
final class EditRejectedValueTalkViewModel {
  private enum Constants {
    static let minAnswerCount: Int = 30
  }
  
  enum Action {
    case didTapBottomButton
    case updateAnswer(index: Int, answer: String)
  }
  
  let editRejectedProfileCreator: EditRejectedProfileCreator
  var valueTalks: [ValueTalkModel] = []
  var cardViewModels: [ValueTalkCardViewModel] = []
  var showToast: Bool = false
  
  init(
    editRejectedProfileCreator: EditRejectedProfileCreator,
    initialValueTalks: [ValueTalkModel]
  ) {
    self.editRejectedProfileCreator = editRejectedProfileCreator
    if editRejectedProfileCreator.valueTalks.isEmpty {
      self.valueTalks = initialValueTalks
    } else {
      self.valueTalks = editRejectedProfileCreator.valueTalks
    }

    self.cardViewModels = self.valueTalks.enumerated().map { index, talk in
      ValueTalkCardViewModel(model: talk, index: index)
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case let .updateAnswer(index, answer):
      valueTalks[index].answer = answer
      
    case .didTapBottomButton:
      didTapBottomButton()
    }
  }
  
  private func didTapBottomButton() {
    for cardViewModel in cardViewModels {
      valueTalks[cardViewModel.index].answer = cardViewModel.localAnswer
    }
    
    let isValid = valueTalks.allSatisfy { valueTalk in
      guard let answer = valueTalk.answer, !answer.isEmpty else { return false }
      return answer.count >= Constants.minAnswerCount
    }
    print("📌 isValid: \(isValid)")
    if isValid {
      editRejectedProfileCreator.updateValueTalks(valueTalks)
      editRejectedProfileCreator.isValueTalksValid(isValid)
    } else {
      showToast = true
      editRejectedProfileCreator.isValueTalksValid(isValid)
    }
  }
}
