//
//  MatchingDetailAlertView.swift
//  MatchingDetail
//
//  Created by 홍승완 on 12/10/25.
//

import SwiftUI
import DesignSystem
import Entities

struct MatchingDetailAlertView: View {
  private let alertType: MatchingDetailAlertType
  private let nickname: String
  private let onDismiss: () -> Void
  private let onConfirm: () -> Void

  // MatchProfileBasicViewModel용
  init(
    viewModel: MatchProfileBasicViewModel,
    alertType: MatchingDetailAlertType
  ) {
    self.alertType = alertType
    self.nickname = viewModel.matchingBasicInfoModel?.nickname ?? ""
    self.onDismiss = { viewModel.handleAction(.dismissAlert) }
    self.onConfirm = { viewModel.handleAction(.didConfirmAlert(alertType)) }
  }

  // ValuePickViewModel용
  init(
    viewModel: ValuePickViewModel,
    alertType: MatchingDetailAlertType
  ) {
    self.alertType = alertType
    self.nickname = viewModel.valuePickModel?.nickname ?? ""
    self.onDismiss = { viewModel.handleAction(.dismissAlert) }
    self.onConfirm = { viewModel.handleAction(.didConfirmAlert(alertType)) }
  }

  // ValueTalkViewModel용
  init(
    viewModel: ValueTalkViewModel,
    alertType: MatchingDetailAlertType
  ) {
    self.alertType = alertType
    self.nickname = viewModel.valueTalkModel?.nickname ?? ""
    self.onDismiss = { viewModel.handleAction(.dismissAlert) }
    self.onConfirm = { viewModel.handleAction(.didConfirmAlert(alertType)) }
  }

  var body: some View {
    switch alertType {
    case .refuse:
      refuseAlert()
    
    case .freeAccept:
      freeAcceptAlert()
    
    case .paidAccept:
      paidAcceptAlert()
    
    case .paidPhoto:
      paidPhotoAlert()
    
    case .timeExpired:
      timeExpiredAlert()
      
    case .insufficientPuzzle:
      insufficientPuzzleAlert()
    }
  }
}

private extension MatchingDetailAlertView {
  // 거절
  func refuseAlert() -> some View {
    AlertView(
      title: {
        Text(nickname).foregroundColor(.grayscaleBlack) + Text("님과의\n") +
        Text("인연을 ").foregroundStyle(Color.grayscaleBlack) +
        Text("거절").foregroundStyle(Color.systemError) +
        Text("할까요?").foregroundStyle(Color.grayscaleBlack)
      },
      message: "매칭을 거절하면 이후에 되돌릴 수 없으니\n신중히 선택해 주세요.",
      firstButtonText: "뒤로",
      secondButtonText: "인연 거절하기",
      firstButtonAction: onDismiss,
      secondButtonAction: onConfirm
    )
  }

  // 무료수락
  func freeAcceptAlert() -> some View {
    AlertView(
      title: {
        Text(nickname).foregroundColor(.primaryDefault) + Text("님과의\n") +
        Text("인연을 이어갈까요?").foregroundStyle(Color.grayscaleBlack)
      },
      message: "서로 수락하면 연락처가 공개돼요.",
      firstButtonText: "뒤로",
      secondButtonText: "인연 수락하기",
      firstButtonAction: onDismiss,
      secondButtonAction: onConfirm
    )
  }

  // 유료수락
  func paidAcceptAlert() -> some View {
    AlertView(
      title: {
        Text(nickname).foregroundColor(.primaryDefault) + Text("님과의\n") +
        Text("인연을 이어갈까요?").foregroundStyle(Color.grayscaleBlack)
      },
      message: {
        Text("퍼즐 ") + Text("\(DomainConstants.PuzzleCost.acceptMatch)개").foregroundColor(.primaryDefault) +
        Text("를 사용해 인연을 수락할 수 있어요.\n") +
        Text("상대도 수락하면, 서로의 연락처가 공개돼요.")
      },
      firstButtonText: "뒤로",
      secondButtonText: "\(DomainConstants.PuzzleCost.acceptMatch)",
      firstButtonAction: onDismiss,
      secondButtonAction: onConfirm,
      secondButtonIcon: DesignSystemAsset.Icons.puzzleSolidRotate32.swiftUIImage
    )
  }

  // 유료사진
  func paidPhotoAlert() -> some View {
    AlertView(
      title: { Text(nickname).foregroundColor(.primaryDefault) + Text("님의\n사진을 확인할까요?") },
      message: {
        Text("퍼즐 ") +
        Text("\(DomainConstants.PuzzleCost.viewPhoto)개").foregroundColor(.primaryDefault) +
        Text("를 사용하면,\n지금 바로 사진을 확인할 수 있어요.")
      },
      firstButtonText: "취소",
      secondButtonText: "\(DomainConstants.PuzzleCost.viewPhoto)",
      firstButtonAction: onDismiss,
      secondButtonAction: onConfirm,
      secondButtonIcon: DesignSystemAsset.Icons.puzzleSolidRotate32.swiftUIImage
    )
  }

  // 제한시간 종료
  func timeExpiredAlert() -> some View {
    AlertView(
      icon: DesignSystemAsset.Icons.notice40.swiftUIImage,
      title: { Text("인연의 제한 시간이 종료되었어요") },
      message: "만료된 프로필은 삭제되며, 홈으로 이동합니다.",
      secondButtonText: "홈으로",
      secondButtonAction: onConfirm,
    )
  }
  
  func insufficientPuzzleAlert() -> some View {
    AlertView(
      title: { Text("앗, 퍼즐이 부족해요!") },
      message: "스토어에서 퍼즐을 구매하시겠어요?",
      firstButtonText: "뒤로",
      secondButtonText: "구매하기",
      firstButtonAction: onDismiss,
      secondButtonAction: onConfirm 
    )
  }
}
