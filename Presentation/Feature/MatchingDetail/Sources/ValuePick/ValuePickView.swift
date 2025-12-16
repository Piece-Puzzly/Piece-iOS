//
//  ValuePickView.swift
//  MatchingDetail
//
//  Created by summercat on 1/13/25.
//

import DesignSystem
import Entities
import Router
import SwiftUI
import UseCases

struct ValuePickView: View {
  @State var viewModel: ValuePickViewModel
  @State private var contentOffset: CGFloat = 0
  @Environment(Router.self) private var router: Router
  @Environment(PCToastManager.self) private var toastManager: PCToastManager

  init(
    matchId: Int,
    getMatchValuePickUseCase: GetMatchValuePickUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        matchId: matchId,
        getMatchValuePickUseCase: getMatchValuePickUseCase,
        getMatchPhotoUseCase: getMatchPhotoUseCase,
        postMatchPhotoUseCase: postMatchPhotoUseCase,
        acceptMatchUseCase: acceptMatchUseCase
      )
    )
  }
  
  var body: some View {
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
      .overlay(alignment: .leading) {
        if let timer = viewModel.timerManager, timer.shouldShowTimer {
          HStack(spacing: 4) {
            DesignSystemAsset.Icons.variant2.swiftUIImage
              .renderingMode(.template)
              .foregroundStyle(.systemError)
            
            Text(timer.remainingTime)
              .pretendard(.body_S_M)
              .foregroundStyle(.systemError)
            
            Spacer()
          }
          .padding(.horizontal, 20)
        }
      }
      .overlay(alignment: .bottom) {
        Divider(weight: .normal, isVertical: false)
      }
      
      if let valuePickModel = viewModel.valuePickModel {
        if viewModel.isNameViewVisible {
          BasicInfoNameView(
            shortIntroduction: valuePickModel.description,
            nickname: valuePickModel.nickname
          ) {
            viewModel.handleAction(.didTapMoreButton)
          }
          .padding(20)
          .background(Color.grayscaleWhite)
          .transition(.move(edge: .top).combined(with: .opacity))
        }
      }
      
      tabs
      
      ObservableScrollView(
        contentOffset: Binding(get: {
          viewModel.contentOffset
        }, set: { offset in
          viewModel.handleAction(.contentOffsetDidChange(offset))
        })) {
          pickCards
        }
        .scrollIndicators(.never)
        .frame(maxWidth: .infinity)
        .background(Color.grayscaleLight3)
      
      buttons
    }
    .toolbar(.hidden)
    .overlay {
      if viewModel.isPhotoViewPresented {
        MatchDetailPhotoView(
          nickname: viewModel.valuePickModel?.nickname ?? "",
          matchStatus: viewModel.valuePickModel?.matchStatus ?? .RESPONDED,
          uri: viewModel.photoUri,
          onDismiss: { viewModel.isPhotoViewPresented = false },
          onAcceptButtonTap: { viewModel.handleAction(.didTapAcceptButton) },
        )
      }
    }
    .onChange(of: viewModel.completedMatchAction) { _, actionType in
      guard let actionType else { return }

      switch actionType {
      case .accept:
        router.popToRoot()
        
        toastManager.showToast(
          target: .matchingHome,
          icon: DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage,
          text: "인연을 수락했습니다",
          backgroundColor: .primaryDefault
        )
        
      case .viewPhoto:
        toastManager.showToast(
          target: .matchDetailPhoto,
          icon: DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage,
          text: "퍼즐을 \(DomainConstants.PuzzleCost.viewPhoto)개 사용했어요",
          backgroundColor: .primaryDefault
        )
        
      case .timeExpired:
        router.popToRoot()
      }
    }
    .pcAlert(item: $viewModel.presentedAlert) { alertType in
      MatchingDetailAlertView(viewModel: viewModel, alertType: alertType)
    }
    .sheet(isPresented: $viewModel.isBottomSheetPresented) { // TODO: - 바텀시트 커스텀 컴포넌트화
      if let model = viewModel.valuePickModel {
        bottomSheetContent(model: model)
          .presentationDetents([.height(160)])
      } else {
        EmptyView()
      }
    }
  }
  
  // MARK: - 탭
  
  private var tabs: some View {
    ZStack(alignment: .bottom) {
      HStack(spacing: 0) {
        ForEach(viewModel.tabs) { tab in
          PCMiniTab(isSelected: viewModel.selectedTab == tab) {
            switch tab {
            case .all:
              Text(tab.description)
            case .same:
              HStack(spacing: 6) {
                Text(tab.description)
                Text("\(viewModel.sameWithMeCount)")
              }
            case .different:
              HStack(spacing: 6) {
                Text(tab.description)
                Text("\(viewModel.differentFromMeCount)")
              }
            }
          }
          .onTapGesture {
            withAnimation {
              viewModel.handleAction(.didSelectTab(tab))
            }
          }
        }
      }
      
      GeometryReader { geometry in
        let tabWidth = geometry.size.width / CGFloat(viewModel.tabs.count)
        let offset = tabWidth * CGFloat(viewModel.tabs.firstIndex(of: viewModel.selectedTab) ?? 0)
        Rectangle()
          .frame(width: tabWidth, height: 2)
          .foregroundStyle(Color.grayscaleBlack)
          .offset(x: offset)
          .animation(.spring, value: viewModel.selectedTab)
      }
      .frame(height: 2)
    }
    .frame(height: 48)
    .background(Color.grayscaleWhite)
  }
  
  // MARK: - Pick Card
  
  private var pickCards: some View {
    VStack(spacing: 20) {
      ForEach(viewModel.displayedValuePicks) { valuePick in
        ValuePickCard(valuePick: valuePick)
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
    .padding(.bottom, 60)
  }
  
  // MARK: - 하단 버튼
  
  private var buttons: some View {
    HStack(alignment: .center, spacing: 8) {
      photoButton
      Spacer()
      backButton
      nextButton
    }
    .frame(maxWidth: .infinity)
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
      icon: DesignSystemAsset.Icons.arrowLeft32.swiftUIImage
    ) {
      router.pop()
    }
  }
  
  private var nextButton: some View {
    CircleButton(
      type: .solid_primary,
      icon: DesignSystemAsset.Icons.arrowRight32.swiftUIImage,
      action: { router.push(to: .matchValueTalk(matchId: viewModel.matchId)) }
    )
  }
  
  // MARK: - 바텀시트
  private func bottomSheetContent(model: MatchValuePickModel) -> some View {
    VStack(spacing: 0) {
      bottomSheetContentRow(text: "차단하기") {
        viewModel.isBottomSheetPresented = false
        router.push(to: .blockUser(info: .init(model)))
      }
      bottomSheetContentRow(text: "신고하기") {
        viewModel.isBottomSheetPresented = false
        router.push(to: .reportUser(info: .init(model)))
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

//#Preview {
//  ValuePickView(
//    viewModel: ValuePickViewModel(
//      description: "음악과 요리를 좋아하는",
//      nickname: "수줍은 수달",
//      valuePicks: [
//        ValuePickModel(
//          id: 0,
//          category: "음주",
//          question: "연인과 함께 술을 마시는 것을 좋아하나요?",
//          answers: [
//            ValuePickAnswerModel(
//              id: 1,
//              content: "함께 술을 즐기고 싶어요",
//              isSelected: false
//            ),
//            ValuePickAnswerModel(
//              id: 2,
//              content: "같이 술을 즐길 수 없어도 괜찮아요",
//              isSelected: true
//            ),
//          ],
//          isSame: true
//        ),
//        ValuePickModel(
//          id: 1,
//          category: "음주",
//          question: "연인과 함께 술을 마시는 것을 좋아하나요?",
//          answers: [
//            ValuePickAnswerModel(
//              id: 1,
//              content: "함께 술을 즐기고 싶어요",
//              isSelected: true
//            ),
//            ValuePickAnswerModel(
//              id: 2,
//              content: "같이 술을 즐길 수 없어도 괜찮아요",
//              isSelected: false
//            ),
//          ],
//          isSame: true
//        ),
//        ValuePickModel(
//          id: 2,
//          category: "음주",
//          question: "연인과 함께 술을 마시는 것을 좋아하나요?",
//          answers: [
//            ValuePickAnswerModel(
//              id: 1,
//              content: "함께 술을 즐기고 싶어요",
//              isSelected: true
//            ),
//            ValuePickAnswerModel(
//              id: 2,
//              content: "같이 술을 즐길 수 없어도 괜찮아요",
//              isSelected: false
//            ),
//          ],
//          isSame: false
//        )
//      ]
//    )
//  )
//}
