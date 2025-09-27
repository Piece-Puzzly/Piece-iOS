//
// Project.swift
// MatchingDetail
//
// Created by summercat on 2025/01/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.MatchingDetail.rawValue,
  dependencies: [
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCAmplitude),
  ]
)
