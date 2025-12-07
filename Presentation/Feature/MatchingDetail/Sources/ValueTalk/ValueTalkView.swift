//
//  ValueTalkView.swift
//  MatchingDetail
//
//  Created by summercat on 1/5/25.
//

import DesignSystem
import Router
import SwiftUI
import UseCases
import LocalStorage

struct ValueTalkView: View {
  private enum Constant {
    static let horizontalPadding: CGFloat = 20
    static let accepetButtonText = "인연 수락하기"
    static let refuseButtonText = "인연 거절하기"
  }
  
  @State var viewModel: ValueTalkViewModel
  @State private var contentOffset: CGFloat = 0
  @Environment(Router.self) private var router: Router
  @Environment(PCToastManager.self) private var toastManager: PCToastManager
  
  private let images: [Image] = [
    DesignSystemAsset.Images.illustPuzzle01.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle02.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle03.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle04.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle05.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle06.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle07.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle08.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle09.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle10.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle11.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle12.swiftUIImage,
    DesignSystemAsset.Images.illustPuzzle13.swiftUIImage,
  ]
  
  init(
    matchId: Int,
    getMatchValueTalkUseCase: GetMatchValueTalkUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    refuseMatchUseCase: RefuseMatchUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        matchId: matchId,
        getMatchValueTalkUseCase: getMatchValueTalkUseCase,
        getMatchPhotoUseCase: getMatchPhotoUseCase,
        acceptMatchUseCase: acceptMatchUseCase,
        refuseMatchUseCase: refuseMatchUseCase
      )
    )
  }
  
  var body: some View {
    if let valueTalkModel = viewModel.valueTalkModel {
      content(valueTalkModel: valueTalkModel)
        .toolbar(.hidden)
        .sheet(isPresented: $viewModel.isBottomSheetPresented) { // TODO: - 바텀시트 커스텀 컴포넌트화
          bottomSheetContent(model: valueTalkModel)
            .presentationDetents([.height(160)])
        }
    } else {
      EmptyView()
    }
  }
  
  private func content(valueTalkModel: ValueTalkModel) -> some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: viewModel.navigationTitle,
        rightButton: Button {
          router.popToRoot()
        } label: {
          DesignSystemAsset.Icons.close32.swiftUIImage
        },
        backgroundColor: .grayscaleWhite
      )
      .overlay(alignment: .bottom) {
        Divider(weight: .normal, isVertical: false)
      }
      
      if viewModel.isNameViewVisible {
        BasicInfoNameView(
          shortIntroduction: valueTalkModel.description,
          nickname: valueTalkModel.nickname,
          moreButtonAction: { viewModel.handleAction(.didTapMoreButton) }
        )
        .padding(20)
        .background(Color.grayscaleWhite)
        .transition(.move(edge: .top).combined(with: .opacity))
      }
      
      ObservableScrollView(
        contentOffset: Binding(get: {
          viewModel.contentOffset
        }, set: { offset in
          viewModel.handleAction(.contentOffsetDidChange(offset))
        })) {
          talkCards(valueTalkModel: valueTalkModel)
          
          refuseButton
          
          Spacer()
            .frame(height: 60)
        }
        .scrollIndicators(.never)
        .frame(maxWidth: .infinity)
        .background(Color.grayscaleLight3)

      buttons
    }
    .toolbar(.hidden)
    .animation(.easeOut(duration: 0.3), value: viewModel.isNameViewVisible)
    .fullScreenCover(isPresented: $viewModel.isPhotoViewPresented) {
      MatchDetailPhotoView(
        nickname: viewModel.valueTalkModel?.nickname ?? "",
        uri: viewModel.photoUri,
        onAcceptMatch: { viewModel.handleAction(.didAcceptMatch) }
      )
    }
    .pcAlert(isPresented: $viewModel.isMatchAcceptAlertPresented) {
      AlertView(
        title: {
          Text("\(viewModel.valueTalkModel?.nickname ?? "")").foregroundStyle(Color.primaryDefault) +
          Text("님과의\n인연을 이어갈까요?").foregroundStyle(Color.grayscaleBlack)
        },
        message: "서로 수락하면 연락처가 공개돼요.",
        firstButtonText: "뒤로",
        secondButtonText: Constant.accepetButtonText
      ) {
        viewModel.isMatchAcceptAlertPresented = false
      } secondButtonAction: {
        viewModel.handleAction(.didAcceptMatch)
      }
    }
    .pcAlert(isPresented: $viewModel.isMatchDeclineAlertPresented) {
      AlertView(
        title: {
          Text("\(viewModel.valueTalkModel?.nickname ?? "")님과의\n").foregroundStyle(Color.grayscaleBlack) +
          Text("인연을 ").foregroundStyle(Color.grayscaleBlack) +
          Text("거절").foregroundStyle(Color.systemError) +
          Text("할까요?").foregroundStyle(Color.grayscaleBlack)
        },
        message: "매칭을 거절하면 이후에 되돌릴 수 없으니\n신중히 선택해 주세요.",
        firstButtonText: "뒤로",
        secondButtonText: Constant.refuseButtonText
      ) {
        viewModel.isMatchDeclineAlertPresented = false
      } secondButtonAction: {
        viewModel.handleAction(.didRefuseMatch)
      }
    }
    .onChange(of: viewModel.completedMatchAction) { _, actionType in
      guard let actionType else { return }

      router.popToRoot()
      
      switch actionType {
      case .accept:
        toastManager.showToast(
          icon: DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage,
          text: "인연을 수락했습니다",
          backgroundColor: .primaryDefault
        )
      case .refuse:
        toastManager.showToast(
          icon: DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage,
          text: "인연을 거절했습니다",
          backgroundColor: .primaryDefault
        )
      }
    }
  }
  
  private func talkCards(valueTalkModel: ValueTalkModel) -> some View {
    VStack(spacing: 20) {
      ForEach(
        Array(zip(valueTalkModel.valueTalks.indices,valueTalkModel.valueTalks)),
        id: \.0
      ) { index, valueTalk in
        ValueTalkCard(
          topic: valueTalk.topic,
          summary: valueTalk.summary,
          answer: valueTalk.answer,
          image: images[index % images.count]
        )
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
    .padding(.bottom, 60)
  }
  
  // MARK: - 매칭 거절하기 버튼
  
  private var shouldShowRefuseButton: Bool {
    guard let matchStatus = PCUserDefaultsService.shared.getMatchStatus() else { return false }
    switch matchStatus {
    case .BEFORE_OPEN, .WAITING, .GREEN_LIGHT: return true
    default: return false
    }
  }
  
  private var refuseButton: some View {
    Group {
      if shouldShowRefuseButton {
        PCTextButton(content: Constant.refuseButtonText)
          .onTapGesture {
            viewModel.handleAction(.didTapRefuseButton)
          }
      }
    }
  }
  
  // MARK: - 하단 버튼
  
  private var buttons: some View {
    HStack(alignment: .center, spacing: 8) {
      photoButton
      Spacer()
      backButton
      acceptButton
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .padding(.bottom, 10)
    .background(Color.grayscaleLight3)
  }
  
  private var photoButton: some View {
    CircleButton(
      type: .outline,
      icon: DesignSystemAsset.Icons.photoLine32.swiftUIImage
    ) {
      viewModel.handleAction(.didTapPhotoButton)
    }
  }
  
  private var backButton: some View {
    CircleButton(
      type: .solid_primary,
      icon: DesignSystemAsset.Icons.arrowLeft32.swiftUIImage,
      action: { router.pop() }
    )
  }

  private var acceptButton: some View {
    RoundedButton(
      type: viewModel.isAcceptButtonEnabled ? .solid : .disabled,
      buttonText: Constant.accepetButtonText,
      icon: nil,
      rounding: true,
      action: {
        if viewModel.isAcceptButtonEnabled { viewModel.handleAction(.didTapAcceptButton)
        }
      }
    )
  }
  
  // MARK: - 바텀시트
  private func bottomSheetContent(model: ValueTalkModel) -> some View {
    VStack(spacing: 0) {
      bottomSheetContentRow(text: "차단하기") {
        viewModel.isBottomSheetPresented = false
        router.push(to: .blockUser(matchId: model.id, nickname: model.nickname))
      }
      bottomSheetContentRow(text: "신고하기") {
        viewModel.isBottomSheetPresented = false
        router.push(to: .reportUser(nickname: model.nickname))
      }
    }
  }
  
  private func bottomSheetContentRow(
    text: String,
    tapAction: @escaping () -> Void
  ) -> some View {
    Button {
      tapAction()
    } label: {
      Text(text)
        .pretendard(.body_M_M)
        .foregroundStyle(Color.grayscaleBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
  }
}
//
//#Preview {
//  ValueTalkView(
//    viewModel: ValueTalkViewModel(
//      valueTalkModel: ValueTalkModel(
//        description: "수줍수줍수줍수줍",
//        nickname: "귀요미",
//        valueTalks: [
//          ValueTalk(
//            id: 0,
//            topic: "꿈과 목표",
//            summary: "여행하며 문화 경험, LGBTQ+ 변화를 원해요.",
//            answer: "안녕하세요! 저는 삶의 매 순간을 소중히 여기며, 꿈과 목표를 이루기 위해 노력하는 사람입니다. 제 가장 큰 꿈은 여행을 통해 다양한 문화와 사람들을 경험하고, 그 과정에서 얻은 지혜를 나누는 것입니다. 또한, LGBTQ+ 커뮤니티를 위한 긍정적인 변화를 이끌어내고 싶습니다. 내가 이루고자 하는 목표는 나 자신을 발시키고, 사랑하는 사람들과 함께 행복한 순간들을 만드는 것입니다. 서로의 꿈을 지지하며 함께 성장할 수 있는 관계를 기대합니다!"
//          ),
//          ValueTalk(
//            id: 1,
//            topic: "관심사와 취향",
//            summary: "음악, 요리, 하이킹을 좋아해요.",
//            answer: "저는 다양한 취미와 관심사를 가진 사람입니다. 음악을 사랑하여 콘서트에 자주 가고, 특히 인디 음악과 재즈에 매력을 느낍니다. 요리도 좋아해 새로운 레시피에 도전하는 것을 즐깁니다. 여행을 통해 새로운 맛과 문화를 경험하는 것도 큰 기쁨입니다. 또, 자연을 사랑해서 주말마다 하이킹이나 캠핑을 자주 떠납니다. 영화와 책도 좋아해, 좋은 이야기와 감동을 나누는 시간을 소중히 여깁니다. 서로의 취향을 공유하며 즐거운 시간을 보낼 수 있기를 기대합니다!"
//          ),
//          ValueTalk(
//            id: 2,
//            topic: "연애관",
//            summary: "서로 존중하고 신뢰하며, 함께 성장하는 관계를 원해요. ",
//            answer: "저는 연애에서 서로의 존중과 신뢰가 가장 중요하다고 생각합니다. 진정한 소통을 통해 서로의 감정을 이해하고, 함께 성장할 수 있는 관계를 원합니다. 일상 속 작은 것에도 감사하며, 서로의 꿈과 목표를 지지하고 응원하는 파트너가 되고 싶습니다. 또한, 유머와 즐거움을 잃지 않으며, 함께하는 순간들을 소중히 여기고 싶습니다. 사랑은 서로를 더 나은 사람으로 만들어주는 힘이 있다고 믿습니다. 서로에게 긍정적인 영향을 주며 행복한 시간을 함께하고 싶습니다!"
//          )
//        ]
//      )
//    )
//  )
//}
