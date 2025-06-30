//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by eunseou on 2/2/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.dynamicFramework(
  name: Modules.Data.Repository.rawValue,
  dependencies: [
    .domain(target: .RepositoryInterfaces),
    .domain(target: .Entities),
    .data(target: .LocalStorage),
    .data(target: .DTO),
    .data(target: .PCNetwork)
  ]
)
