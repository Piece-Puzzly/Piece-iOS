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
import PCAmplitude

struct MatchDetailPhotoView: View {
  private let nickname: String
  private let matchStatus: MatchStatus
  private let uri: String
  private let onDismiss: () -> Void
  private let onAcceptButtonTap: () -> Void
  
  @State private var isAcceptButtonEnabled: Bool
  @Environment(Router.self) private var router: Router
  @Environment(PCToastManager.self) private var toastManager: PCToastManager
  
  init(
    nickname: String,
    matchStatus: MatchStatus,
    uri: String,
    onDismiss: @escaping () -> Void,
    onAcceptButtonTap: @escaping () -> Void
  ) {
    self.nickname = nickname
    self.matchStatus = matchStatus
    self.uri = uri
    self.onDismiss = onDismiss
    self.onAcceptButtonTap = onAcceptButtonTap
    
    var isAcceptButtonEnabled = false
      switch matchStatus {
      case .BEFORE_OPEN: isAcceptButtonEnabled = true
      case .WAITING: isAcceptButtonEnabled = true
      case .REFUSED, .BLOCKED: isAcceptButtonEnabled = false
      case .RESPONDED: isAcceptButtonEnabled = false
      case .GREEN_LIGHT: isAcceptButtonEnabled = true
      case .MATCHED: isAcceptButtonEnabled = false
      }
    self.isAcceptButtonEnabled = isAcceptButtonEnabled
  }
  
  var body: some View {
    content
      .background(
        Dimmer()
          .ignoresSafeArea()
      )
      .overlay(alignment: .top) {
        if toastManager.shouldShowToast(for: .matchDetailPhoto) {
          PCToast(
            isVisible: Bindable(toastManager).isVisible,
            icon: toastManager.icon,
            text: toastManager.text,
            backgroundColor: toastManager.backgroundColor
          )
          .padding(.top, 56)
        }
      }
      .trackScreen(trackable: DefaultProgress.matchDetailPhoto)
  }
  
  private var content: some View {
    VStack(alignment: .center) {
      NavigationBar(
        title: "",
        titleColor: .grayscaleWhite,
        rightButton:
          Button(action: onDismiss) {
            DesignSystemAsset.Icons.close32.swiftUIImage
          }
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
        if isAcceptButtonEnabled {
          onAcceptButtonTap()
        }
      }
    }
  }
}
