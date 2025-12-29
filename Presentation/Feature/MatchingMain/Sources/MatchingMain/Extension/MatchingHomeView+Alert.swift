//
//  MatchingHomeView+Alert.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/29/25.
//

import SwiftUI
import DesignSystem
import Entities

extension MatchingHomeView {
  struct MatchingHomeAlertView: View {
    private let matchingHomeViewModel: MatchingHomeViewModel
    private let alertType: MatchingAlertType
    
    init(
      matchingHomeViewModel: MatchingHomeViewModel,
      alertType: MatchingAlertType
    ) {
      self.matchingHomeViewModel = matchingHomeViewModel
      self.alertType = alertType
    }
    
    var body: some View {
      switch alertType {
      case .contactConfirm(let matchId):
        contactConfirmAlert(matchId: matchId)
      case .insufficientPuzzle:
        insufficientPuzzleAlert()
      case .createNewMatch:
        createNewMatchAlert()
      case .matchPoolExhausted:
        matchPoolExhaustedAlert()
      }
    }
  }
}

private extension MatchingHomeView.MatchingHomeAlertView {
  func contactConfirmAlert(matchId: Int) -> some View {
    AlertView(
      title: { Text(matchingHomeViewModel.matchingCards.first(where: { $0.id == matchId })?.nickname ?? "").foregroundColor(.primaryDefault) + Text("님의\n연락처를 확인할까요?") },
      message: {
        Text("퍼즐 ") +
        Text("\(DomainConstants.PuzzleCost.checkContact)개").foregroundColor(.primaryDefault) +
        Text("를 사용하면,\n지금 바로 연락처를 확인할 수 있어요.")
      },
      firstButtonText: "뒤로",
      secondButtonText: "\(DomainConstants.PuzzleCost.checkContact)",
      firstButtonAction: { matchingHomeViewModel.handleAction(.dismissAlert) },
      secondButtonAction: { matchingHomeViewModel.handleAction(.didTapAlertConfirm(.contactConfirm(matchId: matchId))) },
      secondButtonIcon: DesignSystemAsset.Icons.puzzleSolidRotate32.swiftUIImage
    )
  }
  
  func insufficientPuzzleAlert() -> some View {
    AlertView(
      title: { Text("앗, 퍼즐이 부족해요!") },
      message: "스토어에서 퍼즐을 구매하시겠어요?",
      firstButtonText: "뒤로",
      secondButtonText: "구매하기",
      firstButtonAction: { matchingHomeViewModel.handleAction(.dismissAlert) },
      secondButtonAction: { matchingHomeViewModel.handleAction(.didTapAlertConfirm(.insufficientPuzzle)) }
    )
  }
  
  func createNewMatchAlert() -> some View {
    AlertView(
      title: { Text("새로운 인연을 만나볼까요?") },
      message: {
        Text("퍼즐 ") +
        Text("\(DomainConstants.PuzzleCost.createNewMatch)개").foregroundColor(.primaryDefault) +
        Text("로 나와 맞는 인연을 찾아보세요.")
      },
      firstButtonText: "뒤로",
      secondButtonText: "\(DomainConstants.PuzzleCost.createNewMatch)",
      firstButtonAction: { matchingHomeViewModel.handleAction(.dismissAlert) },
      secondButtonAction: { matchingHomeViewModel.handleAction(.didTapAlertConfirm(.createNewMatch)) },
      secondButtonIcon: DesignSystemAsset.Icons.puzzleSolidRotate32.swiftUIImage
    )
  }
  
  func matchPoolExhaustedAlert() -> some View {
    AlertView(
      icon: DesignSystemAsset.Icons.notice40.swiftUIImage,
      title: { Text("오늘은 꼭 맞는 인연이 없어요") },
      message: "피스가 더 잘 맞는 인연을 찾고 있어요.\n사용하신 퍼즐은 돌려드렸어요.",
      secondButtonText: "다음에 다시 시도할게요",
      secondButtonAction: {
        matchingHomeViewModel.handleAction(.dismissAlert)
      }
    )
  }
}

