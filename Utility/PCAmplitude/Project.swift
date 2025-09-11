//
//  Project.swift
//  AppManifests
//
//  Created by 홍승완 on 9/11/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.dynamicResourceFramework(
  name: Modules.Utility.PCAmplitude.rawValue,
  dependencies: [
    .externalDependency(dependency: .AmplitudeSwift)
  ]
)
