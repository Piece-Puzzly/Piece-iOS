//
// Project.swift
// Onboarding
//
// Created by summercat on 2025/02/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.Onboarding.rawValue,
  dependencies: [
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .data(target: .LocalStorage),
    .utility(target: .PCAmplitude)
  ]
)
