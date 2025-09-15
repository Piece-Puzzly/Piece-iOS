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
    .presentation(target: .PCImagePicker),
    .utility(target: .PCFoundationExtension),
    .utility(target: .PCAmplitude),
    .domain(target: .UseCases),
    .domain(target: .Entities),
  ]
)

