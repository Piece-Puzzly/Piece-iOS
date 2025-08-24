//
//  ValuePickViewModel.swift
//  SignUp
//
//  Created by summercat on 2/10/25.
//

import Combine
import Entities
import Observation

@Observable
final class ValuePickViewModel {
  enum Action {
    case didTapBottomButton
    case updateValuePick(ValuePickModel)
  }
  
  let profileCreator: ProfileCreator
  var showToast: Bool = false
  var valuePicks: [ValuePickModel] = []
  private(set) var isNextButtonEnabled: Bool = false
  
  init(
    profileCreator: ProfileCreator,
    initialValuePicks: [ValuePickModel]
  ) {
    self.profileCreator = profileCreator
    
    // 초기 데이터는 항상 전달받은 initialValuePicks 사용
    self.valuePicks = initialValuePicks
  }

  func handleAction(_ action: Action) {
    switch action {
    case .didTapBottomButton:
      let isValid = valuePicks.allSatisfy { $0.selectedAnswer != nil }
      isNextButtonEnabled = isValid
      print("📌 isValid: \(isValid)")
      if isValid {
        profileCreator.updateValuePicks(valuePicks)
        profileCreator.isValuePicksValid(true)
      } else {
        showToast = true
        profileCreator.isValuePicksValid(false)
      }
      
    case let .updateValuePick(model):
      print("📌 ValuePickViewModel - updateValuePick: \(model.id)")
      print("📌 받은 model의 selectedAnswer: \(String(describing: model.selectedAnswer))")
      if let index = valuePicks.firstIndex(where: { $0.id == model.id }) {
        valuePicks[index] = model
      }
    }
  }
}
