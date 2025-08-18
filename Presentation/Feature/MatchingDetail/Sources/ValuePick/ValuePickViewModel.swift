//
//  ValuePickViewModel.swift
//  MatchingDetail
//
//  Created by summercat on 1/13/25.
//

import Entities
import Foundation
import LocalStorage
import Observation
import UseCases

@MainActor
@Observable
final class ValuePickViewModel {
  private enum Constant {
    static let navigationTitle = "가치관 Pick"
    static let nameVisibilityOffset: CGFloat = -100
  }
  
  enum Action {
    case contentOffsetDidChange(CGFloat)
    case didTapMoreButton
    case didSelectTab(ValuePickTab)
    case didTapPhotoButton
    case didTapAcceptButton
    case didTapRefuseButton
    case didAcceptMatch
    case didRefuseMatch
  }
  
  enum MatchActionType {
      case accept
      case refuse
  }
  
  init(
    getMatchValuePickUseCase: GetMatchValuePickUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    refuseMatchUseCase: RefuseMatchUseCase
  ) {
    self.getMatchValuePickUseCase = getMatchValuePickUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    self.refuseMatchUseCase = refuseMatchUseCase
    
    var isAcceptButtonEnabled = false
    if let matchStatus = PCUserDefaultsService.shared.getMatchStatus() {
      switch matchStatus {
      case .BEFORE_OPEN: isAcceptButtonEnabled = true
      case .WAITING: isAcceptButtonEnabled = true
      case .REFUSED: isAcceptButtonEnabled = false
      case .RESPONDED: isAcceptButtonEnabled = false
      case .GREEN_LIGHT: isAcceptButtonEnabled = false
      case .MATCHED: isAcceptButtonEnabled = false
      }
    }
    self.isAcceptButtonEnabled = isAcceptButtonEnabled
    
    Task {
      await fetchMatchValueTalk()
      await fetchMatchPhoto()
    }
  }
  
  let tabs = ValuePickTab.allCases
  let navigationTitle: String = Constant.navigationTitle
  var isPhotoViewPresented: Bool = false
  var isBottomSheetPresented: Bool = false
  var isMatchAcceptAlertPresented: Bool = false
  var isMatchDeclineAlertPresented: Bool = false
  
  private(set) var valuePickModel: MatchValuePickModel?
  private(set) var isLoading = true
  private(set) var error: Error?
  private(set) var contentOffset: CGFloat = 0
  private(set) var isNameViewVisible: Bool = true
  private(set) var selectedTab: ValuePickTab = .all
  private(set) var displayedValuePicks: [MatchValuePickItemModel] = []
  private(set) var sameWithMeCount: Int = 0
  private(set) var differentFromMeCount: Int = 0
  private(set) var photoUri: String = ""
  private(set) var isAcceptButtonEnabled: Bool
  private(set) var completedMatchAction: MatchActionType? = nil
  private var valuePicks: [MatchValuePickItemModel] = []
  private let getMatchValuePickUseCase: GetMatchValuePickUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  private let refuseMatchUseCase: RefuseMatchUseCase
  
  func handleAction(_ action: Action) {
    switch action {
    case let .contentOffsetDidChange(offset):
      contentOffset = offset
      isNameViewVisible = offset > Constant.nameVisibilityOffset
      
    case .didTapMoreButton:
      isBottomSheetPresented = true
      
    case let .didSelectTab(tab):
      self.selectedTab = tab
      switch tab {
      case .all:
        displayedValuePicks = valuePicks
      case .same:
        displayedValuePicks = valuePicks.filter { $0.isSameWithMe }
      case .different:
        displayedValuePicks = valuePicks.filter { !$0.isSameWithMe }
      }
      
    case .didTapPhotoButton:
      isPhotoViewPresented = true
      
    case .didTapAcceptButton:
      isMatchAcceptAlertPresented = true
      
    case .didTapRefuseButton:
      isMatchDeclineAlertPresented = true
      
    case .didAcceptMatch:
      completedMatchAction = nil
      Task {
        await acceptMatch()
        isMatchAcceptAlertPresented = false
        completedMatchAction = .accept
      }
      
    case .didRefuseMatch:
      completedMatchAction = nil
      Task {
        await refuseMatch()
        isMatchDeclineAlertPresented = false
        completedMatchAction = .refuse
      }
    }
  }
  
  func fetchMatchValueTalk() async {
    do {
      let entity = try await getMatchValuePickUseCase.execute()
      valuePickModel = entity
      valuePicks = entity.valuePicks
      displayedValuePicks = entity.valuePicks
      sameWithMeCount = entity.valuePicks.filter { $0.isSameWithMe }.count
      differentFromMeCount = entity.valuePicks.filter { !$0.isSameWithMe }.count
      
      error = nil
    } catch {
      self.error = error
    }
    
    isLoading = false
  }
  
  private func fetchMatchPhoto() async {
    do {
      let uri = try await getMatchPhotoUseCase.execute()
      photoUri = uri
    } catch {
      self.error = error
    }
  }
  
  private func acceptMatch() async {
    do {
      _ = try await acceptMatchUseCase.execute()
    } catch {
      self.error = error
    }
  }
  
  private func refuseMatch() async {
    do {
      _ = try await refuseMatchUseCase.execute()
    } catch {
      self.error = error
    }
  }
}
