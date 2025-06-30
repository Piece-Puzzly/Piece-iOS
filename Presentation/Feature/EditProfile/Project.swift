//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by eunseou on 3/15/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.EditProfile.rawValue,
  dependencies: [
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCFoundationExtension),
    .externalDependency(dependency: .Mantis),
  ]
)
