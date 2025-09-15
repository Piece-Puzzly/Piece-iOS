//
// Project.swift
// Profile
//
// Created by summercat on 2025/01/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.Profile.rawValue,
  dependencies: [
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCFoundationExtension),
    .utility(target: .PCAmplitude),
  ]
)
