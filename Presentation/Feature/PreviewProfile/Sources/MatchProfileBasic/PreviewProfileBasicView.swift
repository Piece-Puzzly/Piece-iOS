//
// PreviewProfileBasicView.swift
// PreviewProfile
//
// Created by summercat on 2025/01/02.
//

import DesignSystem
import Entities
import Router
import SwiftUI
import UseCases

struct PreviewProfileBasicView: View {
  private enum Constant {
    static let horizontalPadding: CGFloat = 20
  }
  
  @State var viewModel: PreviewProfileBasicViewModel
  @Environment(Router.self) private var router: Router
  
  init(getProfileBasicUseCase: GetProfileBasicUseCase) {
    _viewModel = .init(
      wrappedValue: .init(getProfileBasicUseCase: getProfileBasicUseCase)
    )
  }
  
  var body: some View {
    if let basicInfoModel = viewModel.matchingBasicInfoModel {
      content(basicInfoModel: basicInfoModel)
        .toolbar(.hidden)
    } else {
      EmptyView()
    }
  }
  
  private func content(basicInfoModel: BasicInfoModel) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      NavigationBar(
        title: viewModel.navigationTitle,
        rightButton:Button {
          router.popToRoot()
        } label: {
          DesignSystemAsset.Icons.close32.swiftUIImage
        }
      )
      
      VStack(alignment: .leading) {
        title
        Spacer()
        BasicInfoNameView(
          shortIntroduction: basicInfoModel.shortIntroduction,
          nickname: basicInfoModel.nickname
        )
      }
      .padding(.horizontal, Constant.horizontalPadding)
      .padding(.vertical, 20)
      
      basicInfoCards(basicInfoModel: basicInfoModel)
        .padding(.horizontal, Constant.horizontalPadding)
      
      buttons
        .padding(.horizontal, Constant.horizontalPadding)
    }
    .background(
      DesignSystemAsset.Images.matchingDetailBG.swiftUIImage
        .resizable()
        .ignoresSafeArea()
    )
    .fullScreenCover(isPresented: $viewModel.isPhotoViewPresented) {
      PreviewProfilePhotoView(uri: viewModel.photoUri)
    }
    .transaction { transaction in
        transaction.disablesAnimations = true
    }
  }
  
  private var title: some View {
    Text(viewModel.title)
      .pretendard(.body_M_M)
      .foregroundStyle(Color.primaryDefault)
  }
  
  // MARK: - Basic info card
  
  private func basicInfoCards(basicInfoModel: BasicInfoModel) -> some View {
    VStack(spacing: 4) {
      infoCardFirstRow(basicInfoModel: basicInfoModel)
      infoCardSecondRow(basicInfoModel: basicInfoModel)
    }
    .padding(.vertical, 12)
  }
  
  private func infoCardFirstRow(basicInfoModel: BasicInfoModel) -> some View {
    HStack(spacing: 4) {
      ProfileCard(
        type: .matching,
        category: "나이",
        answer: { ageAnswer(basicInfoModel: basicInfoModel) }
      )
      .frame(width: 144)
      
      ProfileCard(
        type: .matching,
        category: "키",
        answer: { heightAnswer(basicInfoModel: basicInfoModel) }
      )
      ProfileCard(
        type: .matching,
        category: "몸무게",
        answer: { weightAnswer(basicInfoModel: basicInfoModel) }
      )
    }
  }
  
  private func infoCardSecondRow(basicInfoModel: BasicInfoModel) -> some View  {
    HStack(spacing: 4) {
      ProfileCard(
        type: .matching,
        category: "활동 지역",
        answer: { regionAnswer(basicInfoModel: basicInfoModel) }
      )
      .frame(width: 144)
      
      ProfileCard(
        type: .matching,
        category: "직업",
        answer: { jobAnswer(basicInfoModel: basicInfoModel) }
      )
      ProfileCard(
        type: .matching,
        category: "흡연",
        answer: { smokingAnswer(basicInfoModel: basicInfoModel) }
      )
    }
  }
  
  private func ageAnswer(basicInfoModel: BasicInfoModel) -> some View {
    HStack(alignment: .center, spacing: 4) {
      Text("만")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleBlack)
      HStack(alignment: .center, spacing: 0) {
        Text("\(basicInfoModel.age)")
          .pretendard(.heading_S_SB)
          .foregroundStyle(Color.grayscaleBlack)
        Text("세")
          .pretendard(.body_S_M)
          .foregroundStyle(Color.grayscaleBlack)
      }
      Text("\(basicInfoModel.birthYear)년생")
        .lineLimit(1)
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark2)
    }
  }
  
  private func heightAnswer(basicInfoModel: BasicInfoModel) -> some View  {
    HStack(alignment: .center, spacing: 0) {
      Text(basicInfoModel.height.description)
        .pretendard(.heading_S_SB)
        .foregroundStyle(Color.grayscaleBlack)
      Text("cm")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleBlack)
    }
  }
  
  private func weightAnswer(basicInfoModel: BasicInfoModel) -> some View  {
    HStack(alignment: .center, spacing: 0) {
      Text(basicInfoModel.weight.description)
        .pretendard(.heading_S_SB)
        .foregroundStyle(Color.grayscaleBlack)
      Text("kg")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleBlack)
    }
  }
  
  private func regionAnswer(basicInfoModel: BasicInfoModel) -> some View  {
    Text(basicInfoModel.region)
      .pretendard(.heading_S_SB)
      .foregroundStyle(Color.grayscaleBlack)
  }
  
  private func jobAnswer(basicInfoModel: BasicInfoModel) -> some View  {
    Text(basicInfoModel.job)
      .lineLimit(1)
      .truncationMode(.tail)
      .pretendard(.heading_S_SB)
      .foregroundStyle(Color.grayscaleBlack)
  }
  
  private func smokingAnswer(basicInfoModel: BasicInfoModel) -> some View  {
    Text(basicInfoModel.smokingStatus)
      .pretendard(.heading_S_SB)
      .foregroundStyle(Color.grayscaleBlack)
  }
  
  // MARK: - 하단 버튼
  
  private var buttons: some View {
    HStack(alignment: .center, spacing: 8) {
      photoButton
      Spacer()
      backButton
      nextButton
    }
    .padding(.top, 12)
  }
  
  private var photoButton: some View {
    RoundedButton(
      type: .outline,
      buttonText: "사진 보기",
      rounding: true
    ) {
      viewModel.handleAction(.didTapPhotoButton)
    }
  }
  
  private var backButton: some View {
    CircleButton(
      type: .disabled,
      icon: DesignSystemAsset.Icons.arrowLeft32.swiftUIImage,
      action: { }
    )
  }
  
  private var nextButton: some View {
    CircleButton(
      type: .solid_primary,
      icon: DesignSystemAsset.Icons.arrowRight32.swiftUIImage,
      action: {
        router.push(
          to: .previewProfileValuePicks(
              nickname: viewModel.matchingBasicInfoModel?.nickname ?? "",
              description: viewModel.matchingBasicInfoModel?.shortIntroduction ?? "",
              imageUri: viewModel.photoUri
            )
        )
      }
    )
  }
}

#Preview {
  PreviewProfileBasicView(
    getProfileBasicUseCase: DummyGetProfileBasicUseCase()
  )
  .environment(Router())
}

private final class DummyGetProfileBasicUseCase: GetProfileBasicUseCase {
  func execute() async throws -> Entities.ProfileBasicModel {
    return ProfileBasicModel(
      nickname: "수줍은 수달",
      description: "음악과 요리를 좋아하는",
      age: 25,
      birthdate: "1999-11-11",
      height: 180,
      weight: 72,
      job: "프리랜서",
      location: "세종특별자치시",
      smokingStatus: "비흡연",
      snsActivityLevel: "은둔",
      imageUri: "https://www.thesprucepets.com/thmb/AyzHgPQM_X8OKhXEd8XTVIa-UT0=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/GettyImages-145577979-d97e955b5d8043fd96747447451f78b7.jpg",
      pendingImageUrl: nil,
      contacts: []
    )
  }
}
