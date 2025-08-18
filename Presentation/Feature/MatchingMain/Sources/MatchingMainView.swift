//
//  MatchingMainView.swift
//  MatchingMain
//
//  Created by eunseou on 12/28/24.
//

import Router
import SwiftUI
import DesignSystem
import UseCases

struct MatchingMainView: View {
  @Bindable var matchingTimerViewModel: MatchingTimerViewModel
  @Bindable var matchingMainViewModel: MatchingMainViewModel
  
  @Environment(Router.self) private var router: Router
  @Environment(PCToastManager.self) private var toastManager: PCToastManager
  
  init(
    getUserInfoUseCase: GetUserInfoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
  ) {
    _matchingMainViewModel = .init(
      wrappedValue: .init(
        getUserInfoUseCase: getUserInfoUseCase,
        acceptMatchUseCase: acceptMatchUseCase,
        getMatchesInfoUseCase: getMatchesInfoUseCase,
        getUserRejectUseCase: getUserRejectUseCase,
        patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase
      )
    )
    _matchingTimerViewModel = .init(wrappedValue: .init())
  }
  
  public var body: some View {
    ZStack {
      Color.grayscaleBlack.edgesIgnoringSafeArea(.all)
      VStack {
        HomeNavigationBar(
          title: "Matching",
          foregroundColor: .grayscaleWhite,
          rightIcon: DesignSystemAsset.Icons.alarm32.swiftUIImage,
          rightIconTap: {
            router.push(to: .notificationList)
          }
        )
        VStack(alignment: .center, spacing: 8) {
          if matchingMainViewModel.isShowMatchingPendingCard {
            matchingPendingCard
          } else if matchingMainViewModel.isShowMatchingNodataCard{
            MatchingTimer(matchingTimerViewModel: matchingTimerViewModel, prefixMessage: "소중한 인연이 시작되기까지")
            matchingNoDataCard
          } else if matchingMainViewModel.isShowMatchingMainBasicCard {
            MatchingTimer(matchingTimerViewModel: matchingTimerViewModel, prefixMessage: "소중한 인연이 사라지기까지")
            matchingBasicCard
          }
        }
        .padding(.horizontal, 20)
        
        Spacer()
      }
    }
    .pcAlert(isPresented: $matchingMainViewModel.isMatchAcceptAlertPresented) {
      AlertView(
        title: {
          Text("\(matchingMainViewModel.name)").foregroundStyle(Color.primaryDefault) +
          Text("님과의\n인연을 이어갈까요?").foregroundStyle(Color.grayscaleBlack)
        },
        message: "서로 수락하면, 연락처가 공개돼요.",
        firstButtonText: "뒤로",
        secondButtonText: "인연 수락하기"
      ) {
        matchingMainViewModel.isMatchAcceptAlertPresented = false
      } secondButtonAction: {
        matchingMainViewModel.handleAction(.didAcceptMatch)
        matchingMainViewModel.isMatchAcceptAlertPresented = false
      }
    }
    .pcAlert(isPresented: $matchingMainViewModel.isMatchAcceptAlertPresented) {
      AlertView(
        icon: DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage,
        title: { Text("프로필을 수정해주세요") },
        message: matchingMainViewModel.profileRejectAlertMessage,
        secondButtonText: "수정하기",
        secondButtonAction: { router.setRoute(.createProfile)}
      )
    }
    .onChange(of: matchingMainViewModel.destination) { _, destination in
      guard let destination else { return }
      router.push(to: destination)
    }
  }
  
  private var matchingNoDataCard: some View {
    VStack {
      VStack(alignment: .center, spacing: 8) {
        Text("진중한 만남을 위한\n")
          .foregroundStyle(Color.grayscaleBlack) +
        Text("매칭 조각")
          .foregroundStyle(Color.primary) +
        Text("이 곧 도착할 거예요!")
          .foregroundStyle(Color.grayscaleBlack)
        Text("매일 밤 10시에 매칭 조각이 도착해요\n생성한 프로필을 검토하며 기다려 주세요.")
          .pretendard(.body_S_M)
          .foregroundStyle(Color.grayscaleDark3)
      }
      .padding(.top, 40)
      .padding(.bottom, 20)
      .pretendard(.heading_M_SB)
      .multilineTextAlignment(.center)
      
      DesignSystemAsset.Images.imgMatching240.swiftUIImage
        .padding(.vertical, 14)
      
      matchingButton
      .padding(.vertical, 20)
    }
    .padding(.horizontal, 20)
    .background(
      Rectangle()
        .fill(Color.grayscaleWhite)
        .cornerRadius(16)
    )
  }
  
  private var matchingPendingCard: some View {
    VStack {
      Text("심사가 완료되면 소중한 인연이 공개됩니다.")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleLight1)
        .padding(.vertical, 12)
        .padding(.horizontal, 33)
        .frame(maxWidth: .infinity)
        .background(
          Rectangle()
            .foregroundStyle(Color.grayscaleWhite.opacity(0.1))
        )
        .cornerRadius(8)
      
      VStack {
        VStack(alignment: .center, spacing: 8) {
          Group {
            Text("진중한 만남")
              .foregroundStyle(Color.primaryDefault) +
            Text("을 이어가기 위해\n프로필을 살펴보고 있어요.")
              .foregroundStyle(Color.grayscaleBlack)
          }
          .pretendard(.heading_M_SB)
          Text("작성 후 24시간 이내에 심사가 진행돼요.\n푸쉬 알림을 켜면 결과를 빠르게 확인할 수 있어요.")
            .pretendard(.body_S_M)
            .foregroundStyle(Color.grayscaleDark3)
        }
        .padding(.top, 40)
        .padding(.bottom, 20)
        .multilineTextAlignment(.center)
        
        DesignSystemAsset.Images.imgScreening.swiftUIImage
          .padding(.vertical, 14)
        
        matchingButton
          .padding(.vertical, 20)
      }
      .padding(.horizontal, 20)
      .background(
        Rectangle()
          .fill(Color.grayscaleWhite)
          .cornerRadius(16)
      )
    }
  }
  
  private var matchingBasicCard: some View {
    VStack(alignment: .leading) {
      MatchingAnswer(type: matchingMainViewModel.matchingStatus)
        .padding(.bottom, 20)
      
      Button {
        matchingMainViewModel.handleAction(.tapProfileInfo)
      } label: {
        profileInfo
      }
      
      Divider(weight: .normal, isVertical: false)
      
      HStack(spacing: 4) {
        Text("나와 같은 가치관")
        Text("\(matchingMainViewModel.tags.count)개")
          .foregroundColor(.primaryDefault)
      }
      .pretendard(.body_M_M)
      .foregroundColor(.grayscaleBlack)
      
      tags
      
      Spacer()
        .frame(height: 16)
      
      matchingButton
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 20)
    .background(
      Rectangle()
        .fill(Color.grayscaleWhite)
        .cornerRadius(16)
    )
    .padding(.bottom, 108)
  }
  
  private var profileInfo: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading, spacing: 4) {
        Text(matchingMainViewModel.description)
          .multilineTextAlignment(.leading)
        Text("\(matchingMainViewModel.name)입니다")
      }
      .pretendard(.heading_L_SB)
      .foregroundStyle(Color.grayscaleBlack)
      
      Spacer()
        .frame(height: 12)
      
      HStack(spacing: 8) {
        Text("\(matchingMainViewModel.age)년생")
        Divider(weight: .normal, isVertical: true)
          .frame(height: 12)
        Text(matchingMainViewModel.location)
        Divider(weight: .normal, isVertical: true)
          .frame(height: 12)
        Text(matchingMainViewModel.job)
      }
      .pretendard(.body_M_M)
      .foregroundStyle(Color.grayscaleDark2)
    }
  }
  
  private var tags: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(alignment: .leading, spacing: 8) {
        ForEach(matchingMainViewModel.tags, id: \.self) { tag in
          Tag(badgeText: tag)
            .frame(maxWidth: 260, alignment: .leading)
            .lineLimit(2)
            .truncationMode(.tail)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Spacer()
        .frame(height: 32)
    }
  }
  
  private var matchingButton: some View {
    RoundedButton(
      type: matchingMainViewModel.matchingButtonState.buttonType,
      buttonText: matchingMainViewModel.matchingButtonState.title,
      icon: nil,
      width: .maxWidth,
      action: {
        matchingMainViewModel.handleAction(.tapMatchingButton)
        if let route = matchingMainViewModel.matchingButtonDestination {
          router.push(to: route)
        }
      }
    )
  }
}
//
//#Preview {
//  MatchingMainView(
//    matchingTimerViewModel: MatchingTimerViewModel(),
//    matchingMainViewModel: MatchingMainViewModel(
//      description: "[나를 표현하는 한마디]",
//      name: "[닉네임]",
//      age: "02",
//      location: "대구광역시",
//      job: "학생",
//      tags: [
//        "바깥 데이트 스킨십도 가능",
//        "함께 술을 즐기고 싶어요",
//        "커밍아웃은 가까운 친구에게만 했어요",
//        "연락은 바쁘더라도 자주",
//        "최대 너비 260. 두 줄 노출 가능. 최대 너비 260. 두 줄 노출 가능.",
//        "최대 너비 260. 두 줄 노출 가능. 최대 너비 260. 두 줄 노출 가능.",
//        "최대 너비 260. 두 줄 노출 가능. 최대 너비 260. 두 줄 노출 가능.",
//        "최대 너비 260. 두 줄 노출 가능. 최대 너비 260. 두 줄 노출 가능."
//      ],
//      matchingButtonState: .responseComplete,
//      matchingStatus: .before
//    )
//  )
//}
