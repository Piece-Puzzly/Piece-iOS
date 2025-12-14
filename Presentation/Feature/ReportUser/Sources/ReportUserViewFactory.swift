//
//  ReportUserViewFactory.swift
//  ReportUser
//
//  Created by summercat on 2/16/25.
//

import SwiftUI
import UseCases
import PCAmplitude
import Entities

public struct ReportUserViewFactory {
  public static func createReportUserView(
    info: ReportUserInfo,
    reportUserUseCase: ReportUserUseCase
  ) -> some View {
    ReportUserView(
      info: info,
      reportUserUseCase: reportUserUseCase
    )
    .trackScreen(trackable: DefaultProgress.reportIntro)
  }
}
