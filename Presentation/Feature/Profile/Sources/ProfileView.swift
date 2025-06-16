//
// ProfileView.swift
// Profile
//
// Created by summercat on 2025/01/30.
//

import DesignSystem
import Router
import SwiftUI
import UseCases

struct ProfileView: View {
  @State var viewModel: ProfileViewModel
  @Environment(Router.self) private var router: Router
  
  init(getProfileUseCase: GetProfileBasicUseCase) {
    _viewModel = .init(wrappedValue: .init(getProfileUseCase: getProfileUseCase))
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing :0) {
        navigationBar
        
        if let userProfile = viewModel.userProfile {
          profile(userProfile: userProfile)
        } else {
          EmptyView()
        }
        
        Divider(weight: .thick, isVertical: false)
        
        matchingPiece
        
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.grayscaleWhite)
      .onAppear {
        viewModel.handleAction(.onAppear)
      }
    }
    .scrollIndicators(.hidden)
  }
  
  private var navigationBar: some View {
    HomeNavigationBar(
      title: "Profile",
      foregroundColor: .grayscaleBlack,
      rightIcon: DesignSystemAsset.Icons.alarm32.swiftUIImage
    ) {
      router.push(to: .notificationList)
    }
  }
  
  // MARK: - 프로필 영역
  
  private func profile(userProfile: UserProfile) -> some View {
    VStack(spacing: 24) {
      nameCard(userProfile: userProfile)
      basicInfoCards(userProfile: userProfile)
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
    .padding(.bottom, 32)
  }
  
  private func nameCard(userProfile: UserProfile) -> some View {
    HStack(alignment: .center, spacing: 20) {
      AsyncImage(url: URL(string: userProfile.imageUri)) { image in
        image.image?
          .resizable()
          .scaledToFill()
      }
      .frame(width: 80, height: 80)
      .clipShape(Circle())
      
      VStack(alignment: .leading, spacing: 6) {
        Text(userProfile.description)
          .lineLimit(1)
          .pretendard(.body_M_R)
          .foregroundStyle(Color.grayscaleBlack)
        
        Text(userProfile.nickname)
          .lineLimit(1)
          .pretendard(.heading_L_SB)
          .foregroundStyle(Color.primaryDefault)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      DesignSystemAsset.Icons.chevronRight24.swiftUIImage
        .renderingMode(.template)
        .foregroundStyle(Color.grayscaleBlack)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      router.push(to: .editProfile)
    }
  }
  
  // MARK: - Basic info card
  
  private func basicInfoCards(userProfile: UserProfile) -> some View {
    VStack(spacing: 4) {
      infoCardFirstRow(userProfile: userProfile)
      infoCardSecondRow(userProfile: userProfile)
    }
  }
  
  private func infoCardFirstRow(userProfile: UserProfile) -> some View {
    HStack(spacing: 4) {
      ProfileCard(
        type: .profile,
        category: "나이",
        answer: { ageAnswer(userProfile: userProfile) }
      )
      .frame(width: 144)
      
      ProfileCard(
        type: .profile,
        category: "키",
        answer: { heightAnswer(userProfile: userProfile) }
      )
      ProfileCard(
        type: .profile,
        category: "몸무게",
        answer: { weightAnswer(userProfile: userProfile) }
      )
    }
  }
  
  private func infoCardSecondRow(userProfile: UserProfile) -> some View  {
    HStack(spacing: 4) {
      ProfileCard(
        type: .profile,
        category: "활동 지역",
        answer: { locationAnswer(userProfile: userProfile) }
      )
      .frame(width: 144)
      
      ProfileCard(
        type: .profile,
        category: "직업",
        answer: { jobAnswer(userProfile: userProfile) }
      )
      ProfileCard(
        type: .profile,
        category: "흡연",
        answer: { smokingAnswer(userProfile: userProfile) }
      )
    }
  }
  
  private func ageAnswer(userProfile: UserProfile) -> some View {
    HStack(alignment: .center, spacing: 4) {
      Text("만")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleBlack)
      HStack(alignment: .center, spacing: 0) {
        Text("\(userProfile.age)")
          .pretendard(.heading_S_SB)
          .foregroundStyle(Color.grayscaleBlack)
        Text("세")
          .pretendard(.body_S_M)
          .foregroundStyle(Color.grayscaleBlack)
      }
      Text("\(userProfile.birthYear)년생")
        .lineLimit(1)
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark2)
    }
  }
  
  private func heightAnswer(userProfile: UserProfile) -> some View  {
    HStack(alignment: .center, spacing: 0) {
      Text(userProfile.height.description)
        .pretendard(.heading_S_SB)
        .foregroundStyle(Color.grayscaleBlack)
      Text("cm")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleBlack)
    }
  }
  
  private func weightAnswer(userProfile: UserProfile) -> some View  {
    HStack(alignment: .center, spacing: 0) {
      Text(userProfile.weight.description)
        .pretendard(.heading_S_SB)
        .foregroundStyle(Color.grayscaleBlack)
      Text("kg")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleBlack)
    }
  }
  
  private func locationAnswer(userProfile: UserProfile) -> some View  {
    Text(userProfile.location)
      .pretendard(.heading_S_SB)
      .foregroundStyle(Color.grayscaleBlack)
  }
  
  private func jobAnswer(userProfile: UserProfile) -> some View  {
    Text(userProfile.job)
      .lineLimit(1)
      .truncationMode(.tail)
      .pretendard(.heading_S_SB)
      .foregroundStyle(Color.grayscaleBlack)
  }
  
  private func smokingAnswer(userProfile: UserProfile) -> some View  {
    Text(userProfile.smokingStatus)
      .pretendard(.heading_S_SB)
      .foregroundStyle(Color.grayscaleBlack)
  }
  
  // MARK: - 나의 매칭 조각 수정 영역
  
  private var matchingPiece: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("나의 매칭 조각")
        .pretendard(.body_M_R)
        .foregroundStyle(Color.grayscaleDark2)
      
      settingCategories
    }
    .background(Color.grayscaleWhite)
    .padding(.horizontal, 20)
    .padding(.top, 24)
    .padding(.bottom, 100) // 작은 디바이스(SE3)에서 가려지는 이슈로 인해 디자인가이드보다 크게 설정
  }
  
  private var settingCategories: some View {
    VStack(spacing: 0) {
      SettingCategory(
        icon: DesignSystemAsset.Icons.question20.swiftUIImage,
        categoryText: "가치관 Pick",
        descriptionText: "퀴즈를 통해 나의 연애 스타일을 파악해보고\n선택한 답변을 수정할 수 있습니다."
      )
      .contentShape(Rectangle())
      .onTapGesture {
        router.push(to: .editValuePick)
      }
      
      Divider(weight: .normal, isVertical: false)
      
      SettingCategory(
        icon: DesignSystemAsset.Icons.talk20.swiftUIImage,
        categoryText: "가치관 Talk",
        descriptionText: "꿈과 목표, 관심사와 취향, 연애에 관련된\n내 생각을 확인하고 수정할 수 있습니다."
      )
      .contentShape(Rectangle())
      .onTapGesture {
        router.push(to: .editValueTalk)
      }
    }
  }
}
