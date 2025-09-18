//
//  EditValueTalkViewFactory.swift
//  EditValueTalk
//
//  Created by summercat on 2/13/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct EditValueTalkViewFactory {
  public static func createEditValueTalkViewFactory(
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase,
    updateProfileValueTalksUseCase: UpdateProfileValueTalksUseCase,
    updateProfileValueTalkSummaryUseCase: UpdateProfileValueTalkSummaryUseCase,
    connectSseUseCase: ConnectSseUseCase,
    disconnectSseUseCase: DisconnectSseUseCase
  ) -> some View {
    EditValueTalkView(
      getProfileValueTalksUseCase: getProfileValueTalksUseCase,
      updateProfileValueTalksUseCase: updateProfileValueTalksUseCase,
      updateProfileValueTalkSummaryUseCase: updateProfileValueTalkSummaryUseCase,
      connectSseUseCase: connectSseUseCase,
      disconnectSseUseCase: disconnectSseUseCase
    )
    .trackScreen(trackable: DefaultProgress.profileEditValueTalk)
  }
}
