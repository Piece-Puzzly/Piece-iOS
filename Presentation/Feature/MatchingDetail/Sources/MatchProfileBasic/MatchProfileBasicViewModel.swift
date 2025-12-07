//
// MatchProfileBasicViewModel.swift
// MatchingDetail
//
// Created by summercat on 2025/01/02.
//

import Observation
import UseCases
import PCAmplitude

@MainActor
@Observable
final class MatchProfileBasicViewModel {
  enum Action {
    case didTapMoreButton
    case didTapPhotoButton
    case didAcceptMatch
  }
  
  private enum Constant {
    static let navigationTitle = ""
    static let title = "오늘의 인연"
  }

  let navigationTitle = Constant.navigationTitle
  let title = Constant.title
  var isPhotoViewPresented: Bool = false
  var isBottomSheetPresented: Bool = false
  
  private(set) var isLoading = true
  private(set) var error: Error?
  private(set) var matchingBasicInfoModel: BasicInfoModel?
  private(set) var photoUri: String = ""
  private(set) var isMatchAccepted: Bool = false
  private(set) var matchId: Int
  private let getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  private let acceptMatchUseCase: AcceptMatchUseCase
  
  init(
    matchId: Int,
    getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase
  ) {
    self.matchId = matchId
    self.getMatchProfileBasicUseCase = getMatchProfileBasicUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    self.acceptMatchUseCase = acceptMatchUseCase
    
    Task {
      await fetchMatchingBasicInfo()
      await fetchMatchPhoto()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .didTapMoreButton:
      isBottomSheetPresented = true
      PCAmplitude.trackScreenView(DefaultProgress.reportBlockSelectBottomsheet.rawValue)
      
    case .didTapPhotoButton:
      isPhotoViewPresented = true
      
      PCAmplitude.trackButtonClick(
        screenName: .matchDetailBasicInfo,
        buttonName: .photoView
      )
      
    case .didAcceptMatch:
      Task {
        await acceptMatch()
        isMatchAccepted = true
      }
    }
  }
  
  private func fetchMatchingBasicInfo() async {
    do {
      let entity = try await getMatchProfileBasicUseCase.execute(matchId: matchId)
      matchingBasicInfoModel = BasicInfoModel(
        id: entity.id,
        nickname: entity.nickname,
        shortIntroduction: entity.description,
        age: entity.age,
        birthYear: entity.birthYear,
        height: entity.height,
        weight: entity.weight,
        region: entity.location,
        job: entity.job,
        smokingStatus: entity.smokingStatus
      )
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
