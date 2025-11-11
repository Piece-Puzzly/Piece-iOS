//
//  Project.swift
//
//  Created by summercat on 12/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.dynamicFramework(
  name: Modules.Presentation.Coordinator.rawValue,
  dependencies: [
    .domain(target: .UseCases),
    .data(target: .PCNetwork),
    .data(target: .Repository),
    .presentation(target: .Router),
    .presentation(target: .Onboarding),
    .presentation(target: .Home),
    .presentation(target: .Profile),
    .presentation(target: .Settings),
    .presentation(target: .MatchingDetail),
    .presentation(target: .SignUp),
    .presentation(target: .EditValueTalk),
    .presentation(target: .EditValuePick),
    .presentation(target: .Withdraw),
    .presentation(target: .Login),
    .presentation(target: .Splash),
    .presentation(target: .BlockUser),
    .presentation(target: .ReportUser),
    .presentation(target: .MatchResult),
    .presentation(target: .PreviewProfile),
    .presentation(target: .NotificationList),
    .presentation(target: .EditProfile),
    .presentation(target: .Store),
  ]
)
