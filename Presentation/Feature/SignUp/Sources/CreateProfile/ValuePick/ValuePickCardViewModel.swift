//
//  ValuePickCardViewModel.swift
//  SignUp
//
//  Created by summercat on 2/10/25.
//

import Entities
import Observation

@Observable
final class ValuePickCardViewModel {
  enum Action {
    case didTapAnswer(id: Int)
  }
  
  let onModelUpdate: (ValuePickModel) -> Void
  var model: ValuePickModel
  
  init(
    model: ValuePickModel,
    onModelUpdate: @escaping (ValuePickModel) -> Void
  ) {
    self.model = model
    self.onModelUpdate = onModelUpdate
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .didTapAnswer(let id):
      model.selectedAnswer = id
      onModelUpdate(model)
    }
  }
}
