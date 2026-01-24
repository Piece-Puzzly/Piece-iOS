//
// PreviewProfileBasicViewModel.swift
// PreviewProfile
//
// Created by summercat on 2025/01/02.
//

import PCFoundationExtension
import Observation
import UseCases

@Observable
final class PreviewProfileBasicViewModel {
  enum Action {
    case didTapPhotoButton
  }
  
  private enum Constant {
    static let navigationTitle = ""
    static let title = ""
  }

  let navigationTitle = Constant.navigationTitle
  let title = Constant.title
  var isPhotoViewPresented: Bool = false
  
  private(set) var isLoading = true
  private(set) var error: Error?
  private(set) var matchingBasicInfoModel: BasicInfoModel?
  private(set) var photoUri: String = ""
  private let getProfileBasicUseCase: GetProfileBasicUseCase
  
  init(
    getProfileBasicUseCase: GetProfileBasicUseCase
  ) {
    self.getProfileBasicUseCase = getProfileBasicUseCase
    
    Task {
      await fetchMatchingBasicInfo()
    }
  }
  
  func handleAction(_ action: Action) {
    switch action {
    case .didTapPhotoButton:
      isPhotoViewPresented = true
    }
  }
  
  private func fetchMatchingBasicInfo() async {
    do {
      let entity = try await getProfileBasicUseCase.execute()
      matchingBasicInfoModel = BasicInfoModel(
        nickname: entity.nickname,
        shortIntroduction: entity.description,
        age: entity.age ?? -1,
        birthYear: entity.birthdate.extractYear(),
        height: entity.height,
        weight: entity.weight,
        region: entity.location,
        job: entity.job,
        smokingStatus: entity.smokingStatus
      )
      photoUri = entity.imageUri
      error = nil
    } catch {
      self.error = error
    }
    isLoading = false
  }
}
