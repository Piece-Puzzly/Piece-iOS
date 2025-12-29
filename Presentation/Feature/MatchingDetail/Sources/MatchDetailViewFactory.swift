//
//  MatchDetailViewFactory.swift
//  MatchingDetail
//
//  Created by summercat on 1/30/25.
//

import SwiftUI
import UseCases
import PCAmplitude
import Entities

public struct MatchDetailViewFactory {
  @ViewBuilder
  public static func createMatchProfileBasicView(
    matchId: Int,
    getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
  ) -> some View {
    MatchProfileBasicView(
      matchId: matchId,
      getMatchProfileBasicUseCase: getMatchProfileBasicUseCase,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      postMatchPhotoUseCase: postMatchPhotoUseCase,
      acceptMatchUseCase: acceptMatchUseCase,
      getPuzzleCountUseCase: getPuzzleCountUseCase,
    )
    .trackScreen(trackable: DefaultProgress.matchDetailBasicProfile)
    .trackDuration(action: .matchDetailBasicProfileDuration)
  }
  
  @ViewBuilder
  public static func createMatchValueTalkView(
    matchId: Int,
    getMatchValueTalkUseCase: GetMatchValueTalkUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    refuseMatchUseCase: RefuseMatchUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
  ) -> some View {
    ValueTalkView(
      matchId: matchId,
      getMatchValueTalkUseCase: getMatchValueTalkUseCase,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      postMatchPhotoUseCase: postMatchPhotoUseCase,
      acceptMatchUseCase: acceptMatchUseCase,
      refuseMatchUseCase: refuseMatchUseCase,
      getPuzzleCountUseCase: getPuzzleCountUseCase,
    )
    .trackScreen(trackable: DefaultProgress.matchDetailValueTalk)
  }
  
  @ViewBuilder
  public static func createMatchValuePickView(
    matchId: Int,
    getMatchValuePickUseCase: GetMatchValuePickUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    postMatchPhotoUseCase: PostMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
  ) -> some View {
    ValuePickView(
      matchId: matchId,
      getMatchValuePickUseCase: getMatchValuePickUseCase,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      postMatchPhotoUseCase: postMatchPhotoUseCase,
      acceptMatchUseCase: acceptMatchUseCase,
      getPuzzleCountUseCase: getPuzzleCountUseCase,
    )
    .trackScreen(trackable: DefaultProgress.matchDetailValuePick)
  }
}
