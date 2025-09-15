//
// Project.swift
// ReportUser
//
// Created by summercat on 2025/02/16.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.ReportUser.rawValue,
  dependencies: [
    .domain(target: .Entities),
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCAmplitude),
  ]
)
