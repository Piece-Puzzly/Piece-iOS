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
import PCAmplitude

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
    case didAcceptMatch
  }
  
  init(
    getMatchValuePickUseCase: GetMatchValuePickUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase
  ) {
    self.getMatchValuePickUseCase = getMatchValuePickUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase

    Task {
      await fetchMatchValuePick()
      await fetchMatchPhoto()
    }
  }
  
  let tabs = ValuePickTab.allCases
  let navigationTitle: String = Constant.navigationTitle
  var isPhotoViewPresented: Bool = false
  var isBottomSheetPresented: Bool = false
  
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
  private(set) var isMatchAccepted: Bool = false
  private var valuePicks: [MatchValuePickItemModel] = []
  private let getMatchValuePickUseCase: GetMatchValuePickUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  
  func handleAction(_ action: Action) {
    switch action {
    case let .contentOffsetDidChange(offset):
      contentOffset = offset
      isNameViewVisible = offset > Constant.nameVisibilityOffset
      
    case .didTapMoreButton:
      isBottomSheetPresented = true
      PCAmplitude.trackScreenView(DefaultProgress.reportBlockSelectBottomsheet.rawValue)
      
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
      
      PCAmplitude.trackButtonClick(
        screenName: .matchDetailValuePick,
        buttonName: .photoView
      )
      
    case .didAcceptMatch:
      Task {
        await acceptMatch()
        isMatchAccepted = true
      }
    }
  }
  
  func fetchMatchValuePick() async {
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
}
