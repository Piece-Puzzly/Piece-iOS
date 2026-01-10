//
//  MatchMainViewFactory.swift
//  MatchingMain
//
//  Created by eunseou on 2/15/25.
//

import SwiftUI
import UseCases

public struct MatchMainViewFactory {
  @ViewBuilder
  
  // TODO: - Deprecated ("MatcingMain" -> "MatchingHome") for "다중 매칭"
  
//  public static func createMatchMainView(
//    getUserInfoUseCase: GetUserInfoUseCase,
//    acceptMatchUseCase: AcceptMatchUseCase,
//    getMatchesInfoUseCase: GetMatchesInfoUseCase,
//    getUserRejectUseCase: GetUserRejectUseCase,
//    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase
//  ) -> some View {
//    MatchingMainView(
//      getUserInfoUseCase: getUserInfoUseCase,
//      acceptMatchUseCase: acceptMatchUseCase,
//      getMatchesInfoUseCase: getMatchesInfoUseCase,
//      getUserRejectUseCase: getUserRejectUseCase,
//      patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase
//    )
//  }
  
  public static func createMatchMainView(
    getUserInfoUseCase: GetUserInfoUseCase,
    getPuzzleCountUseCase: GetPuzzleCountUseCase,
    getMatchesInfoUseCase: GetMatchesInfoUseCase,
    getUserRejectUseCase: GetUserRejectUseCase,
    patchMatchesCheckPieceUseCase: PatchMatchesCheckPieceUseCase,
    createNewMatchUseCase: CreateNewMatchUseCase,
    checkCanFreeMatchUseCase: CheckCanFreeMatchUseCase,
    postMatchContactsUseCase: PostMatchContactsUseCase,
    getUnreadNotificationCountUseCase: GetUnreadNotificationCountUseCase
  ) -> some View {
    MatchingHomeView(
      getUserInfoUseCase: getUserInfoUseCase,
      getPuzzleCountUseCase: getPuzzleCountUseCase,
      getMatchesInfoUseCase: getMatchesInfoUseCase,
      getUserRejectUseCase: getUserRejectUseCase,
      patchMatchesCheckPieceUseCase: patchMatchesCheckPieceUseCase,
      createNewMatchUseCase: createNewMatchUseCase,
      checkCanFreeMatchUseCase: checkCanFreeMatchUseCase,
      postMatchContactsUseCase: postMatchContactsUseCase,
      getUnreadNotificationCountUseCase: getUnreadNotificationCountUseCase
    )
  }
}
