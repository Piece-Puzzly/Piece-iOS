//
// Project.swift
// Splash
//
// Created by summercat on 2025/02/14.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.Splash.rawValue,
  dependencies: [
    .domain(target: .Entities),
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .data(target: .LocalStorage),
    .utility(target: .PCFirebase),
    .utility(target: .PCFoundationExtension),
    .utility(target: .PCAmplitude),
  ]
)
