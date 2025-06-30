//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by eunseou on 1/12/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.SignUp.rawValue,
  dependencies: [
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .presentation(target: .PCWebView),
    .utility(target: .PCFoundationExtension),
    .domain(target: .UseCases),
    .domain(target: .Entities),
    .externalDependency(dependency: .Mantis),
  ]
)

