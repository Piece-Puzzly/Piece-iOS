//
//  Configuration+configuration.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 12/18/24.
//

import ProjectDescription

extension Configuration {
  public static func configuration(environment: AppEnvironment) -> Self {
    switch environment {
    case .Debug:
      return .debug(
        name: environment.configurationName,
        settings: [
          "CODE_SIGN_IDENTITY": SettingValue.string("Apple Development"),
          "PROVISIONING_PROFILE_SPECIFIER": SettingValue.string(AppConstants.provisioningProfile),
        ],
        xcconfig: .relativeToRoot("Debug.xcconfig")
      )
    case .Release:
      return .release(
        name: environment.configurationName,
        settings: [
          "CODE_SIGN_IDENTITY": SettingValue.string("Apple Distribution"),
          "PROVISIONING_PROFILE_SPECIFIER": SettingValue.string(AppConstants.provisioningProfile),
        ],
        xcconfig: .relativeToRoot("Release.xcconfig")
      )
    }
  }
}
