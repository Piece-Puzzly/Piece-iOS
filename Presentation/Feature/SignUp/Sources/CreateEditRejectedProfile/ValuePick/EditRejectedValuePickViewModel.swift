//
//  EditRejectedValuePickViewModel.swift
//  SignUp
//
//  Created by 홍승완 on 8/24/25.
//

import Combine
import Entities
import Observation

@Observable
final class EditRejectedValuePickViewModel {
  enum Action {
    case didTapBottomButton
    case updateValuePick(ValuePickModel)
  }
  
  let editRejectedProfileCreator: EditRejectedProfileCreator
  var showToast: Bool = false
  var valuePicks: [ValuePickModel] = []
  private(set) var isNextButtonEnabled: Bool = false
  
  init(
    editRejectedProfileCreator: EditRejectedProfileCreator,
    initialValuePicks: [ValuePickModel]
  ) {
    self.editRejectedProfileCreator = editRejectedProfileCreator
    
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
        editRejectedProfileCreator.updateValuePicks(valuePicks)
        editRejectedProfileCreator.isValuePicksValid(true)
      } else {
        showToast = true
        editRejectedProfileCreator.isValuePicksValid(false)
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
