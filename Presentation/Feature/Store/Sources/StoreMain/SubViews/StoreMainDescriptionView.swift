//
//  StoreMainDescriptionView.swift
//  Store
//
//  Created by 홍승완 on 11/5/25.
//

import SwiftUI
import DesignSystem
import Router

struct StoreMainDescriptionView: View {
  enum Constants {
    static let row1 = "구매한 퍼즐은 새로운 인연 만나기, 연락처 확인하기, 사진 보기, 인연 수락하기 등에 사용할 수 있습니다."
    static let row2 = "사용하지 않은 퍼즐에 한해, 구매일로부터 7일 이내 청약 철회가 가능합니다."
    static let row3 = "결제에 문제가 있으신 경우, 고객센터로 문의 주세요."
    static let highlightText = "고객센터"
    static let webViewTitle = "문의하기"
    static let webViewUri = "https://kd0n5.channel.io/home"
  }
  
  @Environment(Router.self) private var router: Router

  var body: some View {
    VStack(spacing: 8) {
      StoreMainDescriptionRow(text: Constants.row1)
      StoreMainDescriptionRow(text: Constants.row2)
      StoreMainDescriptionRow(text: Constants.row3)
        .tappableHighlight(text: Constants.highlightText) {
          router.push(to: .settingsWebView(title: Constants.webViewTitle, uri: Constants.webViewUri))
        }
    }
  }
}

fileprivate struct StoreMainDescriptionRow: View {
  private let text: String
  
  init(text: String) {
    self.text = text
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 6) {
      Text("·"); Text(text)
    }
    .pretendard(.body_S_R)
    .foregroundStyle(.grayscaleDark2)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  func tappableHighlight(
    text: String,
    action: @escaping () -> Void
  ) -> some View {
    TappableHighlightedText(
      text: self.text,
      highlightedText: text,
      onHighlightedTap: action
    )
  }
}

fileprivate struct TappableHighlightedText: View {
  private let text: String
  private let highlightedText: String?
  private let onHighlightedTap: (() -> Void)?
  
  init(
    text: String,
    highlightedText: String? = nil,
    onHighlightedTap: (() -> Void)? = nil
  ) {
    self.text = text
    self.highlightedText = highlightedText
    self.onHighlightedTap = onHighlightedTap
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 6) {
      Text("·")
      buildText()
    }
    .pretendard(.body_S_R)
    .foregroundStyle(.grayscaleDark2)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  private func buildText() -> some View {
    if let highlightedText = highlightedText,
       let range = text.range(of: highlightedText) {
      let before = String(text[..<range.lowerBound])
      let highlighted = String(text[range])
      let after = String(text[range.upperBound...])
      
      (Text(before) + Text(highlighted).underline() + Text(after))
        .contentShape(Rectangle())
        .onTapGesture {
          onHighlightedTap?()
        }
    } else {
      Text(text)
    }
  }
}
