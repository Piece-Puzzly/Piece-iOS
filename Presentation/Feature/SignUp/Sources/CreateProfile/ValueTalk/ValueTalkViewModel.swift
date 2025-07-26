//
//  ValueTalkViewModel.swift
//  SignUp
//
//  Created by summercat on 2/8/25.
//

import Entities
import Observation
import SwiftUI
import UseCases

@MainActor
@Observable
final class ValueTalkViewModel {
  enum Action {
    case didTapBottomButton
    case updateAnswer(index: Int, answer: String)
  }
  
  let profileCreator: ProfileCreator
  var valueTalks: [ValueTalkModel] = []
  var cardViewModels: [ValueTalkCardViewModel] = []
  var showToast: Bool = false
  
  init(
    profileCreator: ProfileCreator,
    initialValueTalks: [ValueTalkModel]
  ) {
    self.profileCreator = profileCreator
    
    if profileCreator.valueTalks.isEmpty {
      self.valueTalks = initialValueTalks
    } else {
      self.valueTalks = profileCreator.valueTalks
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
    
    let isValid = valueTalks.allSatisfy( { $0.answer?.isEmpty == false })
    print("📌 isValid: \(isValid)")
    if isValid {
      profileCreator.updateValueTalks(valueTalks)
      profileCreator.isValueTalksValid(isValid)
    } else {
      showToast = true
      profileCreator.isValueTalksValid(isValid)
    }
  }
}
