//
//  Project.swift
//
//  Created by summercat on 12/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.MatchingMain.rawValue,
  dependencies: [
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCFoundationExtension),
    .utility(target: .PCAmplitude),
  ]
)
