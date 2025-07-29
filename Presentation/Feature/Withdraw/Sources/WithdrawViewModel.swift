//
// WithdrawViewModel.swift
// Withdraw
//
// Created by 김도형 on 2025/02/13.
//

import Foundation
import UseCases
import DesignSystem

@Observable
final class WithdrawViewModel {
  enum Action {
    case bindingWithdraw(WithdrawType?)
    case bindingEditorText(String?)
    case tapRowItem(BottomSheetTextItem)
  }
  
  private(set) var currentWithdraw: WithdrawType?
  private(set) var editorText: String?
  var coupleMadeRouteItems: [BottomSheetTextItem] = WithdrawCoupleMadeRoute.allCases.map { BottomSheetTextItem(text: $0.rawValue) }
  var isLocationBottomSheetButtonEnable: Bool {
    coupleMadeRouteItems.contains(where: { $0.state == .selected })
  }
  var isReasonSheetPresented: Bool = false {
    didSet {
      guard !isReasonSheetPresented else { return }
      currentWithdraw = nil
    }
  }
  
  var withdrawReason: String {
    switch currentWithdraw {
    case .인연을_만났어요:
      return coupleMadeRouteItems.first(where: { $0.state == .selected })?.text ?? ""
    case .기타:
      return editorText ?? ""
    default:
      return currentWithdraw?.rawValue ?? ""
    }
  }
  
  var isValid: Bool {
    guard currentWithdraw != nil else { return false }
    guard currentWithdraw != .기타 else {
      return editorText?.count ?? 0 > 0
    }
    return true
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .bindingWithdraw(let withdraw):
      currentWithdraw = withdraw
      
      switch withdraw {
      case .인연을_만났어요:
        isReasonSheetPresented = true
      default:
        break
      }
    
    case .bindingEditorText(let text):
      guard (text?.count ?? 0) <= 100 else { return }
      editorText = text
      
    case .tapRowItem(let item):
      coupleMadeRouteItems.selectItem(withId: item.id)
    }
  }
}
