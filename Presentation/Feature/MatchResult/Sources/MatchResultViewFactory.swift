//
//  MatchResultViewFactory.swift
//  MatchResult
//
//  Created by summercat on 2/20/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct MatchResultViewFactory {
  public static func createMatchResultView(
    matchId: Int,
    nickname: String,
    getMatchPhotoUseCase: GetMatchPhotoUseCase,
    getMatchContactsUseCase: GetMatchContactsUseCase
  ) -> some View {
    MatchResultView(
      matchId: matchId,
      nickname: nickname,
      getMatchPhotoUseCase: getMatchPhotoUseCase,
      getMatchContactsUseCase: getMatchContactsUseCase
    )
    .trackScreen(trackable: DefaultProgress.contactShareResult)
  }
}
