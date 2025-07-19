//
// MatchProfileBasicViewModel.swift
// MatchingDetail
//
// Created by summercat on 2025/01/02.
//

import Observation
import UseCases

@MainActor
@Observable
final class MatchProfileBasicViewModel {
  enum Action {
    case didTapMoreButton
    case didTapPhotoButton
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
  private let getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase
  private let getMatchPhotoUseCase: GetMatchPhotoUseCase
  
  init(
    getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase
  ) {
    self.getMatchProfileBasicUseCase = getMatchProfileBasicUseCase
    self.getMatchPhotoUseCase = getMatchPhotoUseCase
    
    Task {
      await fetchMatchingBasicInfo()
      await fetchMatchPhoto()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .didTapMoreButton:
      isBottomSheetPresented = true
    case .didTapPhotoButton:
      isPhotoViewPresented = true
    }
  }
  
  private func fetchMatchingBasicInfo() async {
    do {
      let entity = try await getMatchProfileBasicUseCase.execute()
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
}
