//
// Project.swift
// Settings
//
// Created by summercat on 2025/02/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.Settings.rawValue,
  dependencies: [
    .domain(target: .Entities),
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .presentation(target: .PCWebView),
    .data(target: .LocalStorage),
    .utility(target: .PCFirebase),
    .utility(target: .PCFoundationExtension),
    .utility(target: .PCAmplitude),
  ]
)
