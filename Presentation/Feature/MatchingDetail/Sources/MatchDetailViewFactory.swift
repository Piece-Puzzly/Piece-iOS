//
//  MatchDetailViewFactory.swift
//  MatchingDetail
//
//  Created by summercat on 1/30/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct MatchDetailViewFactory {
  @ViewBuilder
  public static func createMatchProfileBasicView(
    matchId: Int,
    getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase
  ) -> some View {
    MatchProfileBasicView(
      matchId: matchId,
      getMatchProfileBasicUseCase: getMatchProfileBasicUseCase,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      acceptMatchUseCase: acceptMatchUseCase
    )
    .trackScreen(trackable: DefaultProgress.matchDetailBasicProfile)
    .trackDuration(action: .matchDetailBasicProfileDuration)
  }
  
  @ViewBuilder
  public static func createMatchValueTalkView(
    getMatchValueTalkUseCase: GetMatchValueTalkUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    refuseMatchUseCase: RefuseMatchUseCase
  ) -> some View {
    ValueTalkView(
      getMatchValueTalkUseCase: getMatchValueTalkUseCase,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      acceptMatchUseCase: acceptMatchUseCase,
      refuseMatchUseCase: refuseMatchUseCase
    )
    .trackScreen(trackable: DefaultProgress.matchDetailValueTalk)
  }
  
  @ViewBuilder
  public static func createMatchValuePickView(
    getMatchValuePickUseCase: GetMatchValuePickUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase
  ) -> some View {
    ValuePickView(
      getMatchValuePickUseCase: getMatchValuePickUseCase,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      acceptMatchUseCase: acceptMatchUseCase
    )
    .trackScreen(trackable: DefaultProgress.matchDetailValuePick)
  }
  
  @ViewBuilder
  public static func createMatchDetailPhotoView(
    nickname: String,
    uri: String
  ) -> some View {
    MatchDetailPhotoView(nickname: nickname, uri: uri)
  }
}
