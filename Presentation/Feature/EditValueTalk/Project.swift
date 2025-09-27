//
// Project.swift
// EditValueTalk
//
// Created by summercat on 2025/02/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.EditValueTalk.rawValue,
  dependencies: [
    .domain(target: .Entities),
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCAmplitude),
  ]
)
