//
//  MatchDetailViewFactory.swift
//  MatchingDetail
//
//  Created by summercat on 1/30/25.
//

import SwiftUI
import UseCases

public struct MatchDetailViewFactory {
  @ViewBuilder
  public static func createMatchProfileBasicView(
    getMatchProfileBasicUseCase: GetMatchProfileBasicUseCase,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    acceptMatchUseCase: AcceptMatchUseCase
  ) -> some View {
    MatchProfileBasicView(
      getMatchProfileBasicUseCase: getMatchProfileBasicUseCase,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      acceptMatchUseCase: acceptMatchUseCase
    )
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
  }
  
  @ViewBuilder
  public static func createMatchDetailPhotoView(
    nickname: String,
    uri: String
  ) -> some View {
    MatchDetailPhotoView(nickname: nickname, uri: uri)
  }
}
