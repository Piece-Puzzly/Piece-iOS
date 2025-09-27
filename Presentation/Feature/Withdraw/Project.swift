//
// Project.swift
// Withdraw
//
// Created by 김도형 on 2025/02/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.Withdraw.rawValue,
  dependencies: [
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
    .utility(target: .PCFoundationExtension),
    .utility(target: .PCAmplitude),
    .domain(target: .UseCases),
    .data(target: .LocalStorage),
    .externalDependency(dependency: .KakaoSDKUser),
  ]
)
