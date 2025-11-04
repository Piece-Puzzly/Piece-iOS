//
// Project.swift
// Store
//
// Created by 홍승완 on 2025/11/04.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.Store.rawValue,
  dependencies: [
    .domain(target: .Entities),
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCFoundationExtension),
    .utility(target: .PCAmplitude),
  ]
)
