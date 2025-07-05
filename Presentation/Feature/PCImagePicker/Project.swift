//
//  Project.swift
//  AppManifests
//
//  Created by 홍승완 on 7/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.PCImagePicker.rawValue,
  dependencies: [
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCFoundationExtension),
    .externalDependency(dependency: .Mantis),
  ]
)

