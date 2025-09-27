//
//  PreviewProfileViewFactory.swift
//  PreviewProfile
//
//  Created by summercat on 1/30/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct PreviewProfileViewFactory {
  @ViewBuilder
  public static func createMatchProfileBasicView(getProfileBasicUseCase: GetProfileBasicUseCase) -> some View {
    PreviewProfileBasicView(getProfileBasicUseCase: getProfileBasicUseCase)
      .trackScreen(trackable: DefaultProgress.previewSelfBasicProfile)
  }
  
  @ViewBuilder
  public static func createMatchValueTalkView(
    nickname: String,
    description: String,
    imageUri: String,
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase
  ) -> some View {
    ValueTalkView(
      nickname: nickname,
      description: description,
      imageUri: imageUri,
      getProfileValueTalksUseCase: getProfileValueTalksUseCase
    )
    .trackScreen(trackable: DefaultProgress.previewSelfValueTalk)
  }
  
  @ViewBuilder
  public static func createMatchValuePickView(
    nickname: String,
    description: String,
    imageUri: String,
    getProfileValuePicksUseCase: GetProfileValuePicksUseCase
  ) -> some View {
    ValuePickView(
      nickname: nickname,
      description: description,
      imageUri: imageUri,
      getProfileValuePicksUseCase: getProfileValuePicksUseCase
    )
    .trackScreen(trackable: DefaultProgress.previewSelfValuePick)
  }
}
