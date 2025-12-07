//
//  MatchingAnswer.swift
//  DesignSystem
//
//  Created by eunseou on 12/31/24.
//

import SwiftUI
import Entities
import DesignSystem

public struct MatchingAnswer: View {
  public init(type: MatchStatus) {
    self.type = type
  }
  
  private let type: MatchStatus
  
  public var body: some View {
    HStack(spacing: 8) {
      icon(for: type)
      Text(title(for: type))
        .pretendard(.body_S_SB)
        .foregroundColor(titleTextColor(for: type))
      Text(description(for: type))
        .pretendard(.body_S_M)
        .foregroundColor(.grayscaleDark3)
    }
  }
  
  private func icon(for status: MatchStatus) -> Image {
    switch status {
    case .BEFORE_OPEN, .WAITING:
      return DesignSystemAsset.Icons.matchingModeLoading20.swiftUIImage
    case .MATCHED, .RESPONDED, .REFUSED, .BLOCKED:
      return DesignSystemAsset.Icons.matchingModeCheck20.swiftUIImage
    case .GREEN_LIGHT:
      return DesignSystemAsset.Icons.matchingModeHeart20.swiftUIImage
    }
  }
  
  private func title(for status: MatchStatus) -> String {
    switch status {
    case .BEFORE_OPEN: "오픈 전"
    case .WAITING: "응답 대기중"
    case .REFUSED: "응답 완료"
    case .RESPONDED: "응답 완료"
    case .MATCHED: "매칭 완료"
    case .GREEN_LIGHT: "그린라이트"
    case .BLOCKED: "차단"
    }
  }
  
  private func titleTextColor(for status: MatchStatus) -> Color {
    switch status {
    case .BEFORE_OPEN, .WAITING: .grayscaleDark2
    case .BLOCKED, .REFUSED, .RESPONDED, .MATCHED, .GREEN_LIGHT: .primaryDefault
    }
  }
  
  private func description(for status: MatchStatus) -> String {
    switch status {
    case .BEFORE_OPEN: "매칭 조각을 확인해주세요!"
    case .WAITING: "매칭에 응답해주세요!"
    case .REFUSED: "상대방의 응답을 기다려봐요!"
    case .RESPONDED: "상대방의 응답을 기다려봐요!"
    case .MATCHED: "상대방과 연결되었어요!"
    case .GREEN_LIGHT: "상대방이 매칭을 수락했어요!"
    case .BLOCKED: "매칭을 차단했어요!"
    }
  }
}

#Preview {
  VStack {
    MatchingAnswer(type: .BEFORE_OPEN)
    MatchingAnswer(type: .WAITING)
    MatchingAnswer(type: .RESPONDED)
    MatchingAnswer(type: .MATCHED)
    MatchingAnswer(type: .GREEN_LIGHT)
  }
}
