//
//  Scheme+makeScheme.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 12/18/24.
//

import ProjectDescription

extension Scheme {
//   MARK: - 운영 서버
  public static func makeReleaseScheme(/*environment: AppEnvironment*/) -> Scheme {
    return .scheme(
      name: "\(AppConstants.appName)-Release",
      buildAction: .buildAction(targets: ["\(AppConstants.appName)"]),
      runAction: .runAction(configuration: "Release"),
      archiveAction: .archiveAction(configuration: "Release"),
      profileAction: .profileAction(configuration: "Release"),
      analyzeAction: .analyzeAction(configuration: "Release")
    )
  }
  
  // MARK: - 개발 서버
  public static func makeDevScheme() -> Scheme {
    return .scheme(
      name: "\(AppConstants.appName)-Debug"/*"\(AppConstants.devAppName)"*/,
      buildAction: .buildAction(targets: ["\(AppConstants.appName)"]),
      runAction: .runAction(configuration: "Debug"),
      archiveAction: .archiveAction(configuration: "Debug"),
      profileAction: .profileAction(configuration: "Debug"),
      analyzeAction: .analyzeAction(configuration: "Debug")
    )
  }
}
