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
  private enum Constant {
    static let horizontalPadding: CGFloat = 20
    static let accepetButtonText = "인연 수락하기"
    static let refuseButtonText = "인연 거절하기"
  }
  
  @State var viewModel: ValuePickViewModel
  @State private var contentOffset: CGFloat = 0
  @Environment(Router.self) private var router: Router
  
  init(
    getMatchValuePickUseCase: GetMatchValuePickUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    refuseMatchUseCase: RefuseMatchUseCase
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        getMatchValuePickUseCase: getMatchValuePickUseCase,
        getMatchPhotoUseCase: getMatchPhotoUseCase,
        acceptMatchUseCase: acceptMatchUseCase,
        refuseMatchUseCase: refuseMatchUseCase
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
    .fullScreenCover(isPresented: $viewModel.isPhotoViewPresented) {
      MatchDetailPhotoView(
        nickname: viewModel.valuePickModel?.nickname ?? "",
        uri: viewModel.photoUri
      )
    }
    .pcAlert(isPresented: $viewModel.isMatchAcceptAlertPresented) {
      AlertView(
        title: {
          Text("\(viewModel.valuePickModel?.nickname ?? "")").foregroundStyle(Color.primaryDefault) +
          Text("님과의\n인연을 이어갈까요?").foregroundStyle(Color.grayscaleBlack)
        },
        message: "서로 수락하면 연락처가 공개돼요.",
        firstButtonText: "뒤로",
        secondButtonText: Constant.accepetButtonText
      ) {
        viewModel.isMatchAcceptAlertPresented = false
      } secondButtonAction: {
        viewModel.handleAction(.didAcceptMatch)
        router.popToRoot()
      }
    }
    .pcAlert(isPresented: $viewModel.isMatchDeclineAlertPresented) {
      AlertView(
        title: {
          Text("\(viewModel.valuePickModel?.nickname ?? "")님과의\n").foregroundStyle(Color.grayscaleBlack) +
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
        router.popToRoot()
      }
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
    .padding(.horizontal, Constant.horizontalPadding)
    .padding(.top, 20)
    .padding(.bottom, 60)
  }
  
  // MARK: - 매칭 거절하기 버튼
  private var refuseButton: some View {
    PCTextButton(content: Constant.refuseButtonText)
      .onTapGesture {
        viewModel.handleAction(.didTapRefuseButton)
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
  
  private var acceptButton: some View {
    RoundedButton(
      type: viewModel.isAcceptButtonEnabled ? .solid : .disabled,
      buttonText: Constant.accepetButtonText,
      icon: nil,
      rounding: true,
      action: {
        if viewModel.isAcceptButtonEnabled { viewModel.handleAction(.didTapAcceptButton) }
      }
    )
  }
  
  // MARK: - 바텀시트
  private func bottomSheetContent(model: MatchValuePickModel) -> some View {
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
