//
//  BlockUserViewFactory.swift
//  BlockUser
//
//  Created by summercat on 2/12/25.
//

import SwiftUI
import UseCases
import PCAmplitude
import Entities

public struct BlockUserViewFactory {
  public static func createBlockUserView(
    info: BlockUserInfo,
    blockUserUseCase: BlockUserUseCase
  ) -> some View {
    BlockUserView(
      info: info,
      blockUserUseCase: blockUserUseCase
    )
    .trackScreen(trackable: DefaultProgress.blockIntro)
  }
}
