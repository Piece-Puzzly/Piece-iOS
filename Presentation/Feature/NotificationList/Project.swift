//
// Project.swift
// NotificationList
//
// Created by summercat on 2025/02/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.NotificationList.rawValue,
  dependencies: [
    .domain(target: .Entities),
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCAmplitude),
  ]
)
