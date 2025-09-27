//
//  ReportUserViewFactory.swift
//  ReportUser
//
//  Created by summercat on 2/16/25.
//

import SwiftUI
import UseCases
import PCAmplitude

public struct ReportUserViewFactory {
  public static func createReportUserView(
    nickname: String,
    reportUserUseCase: ReportUserUseCase
  ) -> some View {
    ReportUserView(nickname: nickname, reportUserUseCase: reportUserUseCase)
      .trackScreen(trackable: DefaultProgress.reportIntro)
  }
}
