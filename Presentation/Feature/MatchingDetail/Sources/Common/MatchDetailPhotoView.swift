//
//  MatchDetailPhotoView.swift
//  MatchingDetail
//
//  Created by summercat on 1/30/25.
//

import DesignSystem
import Entities
import LocalStorage
import Router
import SwiftUI

struct MatchDetailPhotoView: View {
  private let nickname: String
  private let uri: String
  @Environment(Router.self) private var router: Router
  @Environment(\.dismiss) private var dismiss
  @State private var isAlertPresented: Bool = false
  @State private var isAcceptButtonEnabled: Bool
  private let onAcceptMatch: (() -> Void)?
  
  init(
    nickname: String,
    uri: String,
    onAcceptMatch: (() -> Void)? = nil
  ) {
    self.nickname = nickname
    self.uri = uri
    self.onAcceptMatch = onAcceptMatch
    
    var isAcceptButtonEnabled = false
    if let matchStatus = PCUserDefaultsService.shared.getMatchStatus() {
      switch matchStatus {
      case .BEFORE_OPEN: isAcceptButtonEnabled = true
      case .WAITING: isAcceptButtonEnabled = true
      case .REFUSED: isAcceptButtonEnabled = false
      case .RESPONDED: isAcceptButtonEnabled = false
      case .GREEN_LIGHT: isAcceptButtonEnabled = false
      case .MATCHED: isAcceptButtonEnabled = false
      }
    }
    self.isAcceptButtonEnabled = isAcceptButtonEnabled
  }
  
  var body: some View {
    content
      .background(
        Dimmer()
          .ignoresSafeArea()
      )
  }
  
  private var content: some View {
    VStack(alignment: .center) {
      NavigationBar(
        title: "",
        titleColor: .grayscaleWhite,
        rightButton: Button { dismiss() } label: {DesignSystemAsset.Icons.close32.swiftUIImage }
      )
      
      Spacer()
      
      AsyncImage(url: URL(string: uri)) { image in
        image.image?
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
      .frame(width: 180, height: 180)
      .background(.grayscaleBlack)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      
      Spacer()
      
      RoundedButton(
        type: isAcceptButtonEnabled ? .solid : .disabled,
        buttonText: "인연 수락하기",
        rounding: true
      ) {
        if isAcceptButtonEnabled { isAlertPresented.toggle() }
      }
    }
    .pcAlert(isPresented: $isAlertPresented) {
      AlertView(
        title: {
          Text("\(nickname)").foregroundStyle(Color.primaryDefault) +
          Text("님과의\n인연을 이어갈까요?").foregroundStyle(Color.grayscaleBlack)
        },
        message: "서로 수락하면, 연락처가 공개돼요.",
        firstButtonText: "뒤로",
        secondButtonText: "인연 수락하기"
      ) {
        isAlertPresented = false
      } secondButtonAction: {
        dismiss()
        onAcceptMatch?()
      }
    }
  }
}

#Preview {
  let uri = "https://www.thesprucepets.com/thmb/AyzHgPQM_X8OKhXEd8XTVIa-UT0=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/GettyImages-145577979-d97e955b5d8043fd96747447451f78b7.jpg"
  MatchDetailPhotoView(nickname: "티모대위", uri: uri)
    .environment(Router())
}
