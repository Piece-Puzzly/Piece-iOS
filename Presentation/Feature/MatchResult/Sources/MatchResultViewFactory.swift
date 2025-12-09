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
    getMatchContactsUseCase: GetMatchContactsUseCase
  ) -> some View {
    MatchResultView(
      matchId: matchId,
      getMatchContactsUseCase: getMatchContactsUseCase
    )
    .trackScreen(trackable: DefaultProgress.contactShareResult)
  }
}
