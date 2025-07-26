//
//  Project+app.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 12/16/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

extension Project {
  public static func app(
    dependencies: [TargetDependency] = [],
    packages: [Package] = []
  ) -> Project {
    let name = AppConstants.appName
    let target = Target.target(
      name: AppConstants.appName,
      destinations: AppConstants.destinations,
      product: .app,
      bundleId: AppConstants.bundleId,
      deploymentTargets: AppConstants.deploymentTargets,
      infoPlist: .extendingDefault(
        with: [
          "UIUserInterfaceStyle": "Light",
          "UILaunchStoryboardName": "LaunchScreen",
          "UIBackgroundModes": ["remote-notification"],
          "NSCameraUsageDescription": "프로필 생성 시 사진 첨부를 위해 카메라 접근 권한이 필요합니다.",
          "NSPhotoLibraryUsageDescription": "프로필 생성 시 사진 첨부를 위해 앨범 접근 권한이 필요합니다.",
          "NSContactsUsageDescription": "사용자가 원할 경우, 사용자의 연락처에 있는 상대에게 사용자가 노출되지 않도록 하기 위해 연락처 정보를 수집합니다.",
          "BASE_URL": "$(BASE_URL)",
          "NATIVE_APP_KEY": "$(NATIVE_APP_KEY)",
          "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true
          ],
          "LSApplicationQueriesSchemes": [
            "kakaokompassauth",
            "kakaolink"
          ],
          "GIDClientID": "$(GIDClientID).apps.googleusercontent.com",
          "TEST_LOGIN_ID": "$(TEST_LOGIN_ID)",
          "TEST_LOGIN_PASSWORD": "$(TEST_LOGIN_PASSWORD)",
          "CFBundleShortVersionString": AppConstants.version,
          "CFBundleVersion": AppConstants.build,
          "CFBundleDisplayName": AppConstants.bundleDisplayName,
          "CFBundleURLTypes": [
            ["CFBundleURLSchemes": ["kakao$(NATIVE_APP_KEY)"]],
            ["CFBundleURLSchemes": ["\(AppConstants.bundleId)"]],
            ["CFBundleURLSchemes": ["com.googleusercontent.apps.$(GIDClientID)"]],
          ],
          "ITSAppUsesNonExemptEncryption": false,
          "FirebaseAppDelegateProxyEnabled": false,
        ]
      ),
      sources: ["Sources/**"],
      resources: .resources(
        ["Resources/**"],
        privacyManifest: .privacyManifest(
          tracking: false,
          trackingDomains: [],
          collectedDataTypes: [
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeName",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ],
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeEmailAddress",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ],
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypePhoneNumber",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ],
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeCoarseLocation",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ],
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeSensitiveInfo",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ],
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeContacts",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ],
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeUserID",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ],
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeDeviceID",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ],
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeOtherDataTypes",
              "NSPrivacyCollectedDataTypeLinked": true,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality"
              ]
            ]
          ],
          accessedApiTypes: [
            [
              "NSPrivacyAccessedAPIType": "NSPrivacyAccessedAPICategoryUserDefaults",
              "NSPrivacyAccessedAPITypeReasons": [
                "CA92.1",
              ],
            ],
          ]
        )
      ),
      entitlements: .file(path: .relativeToRoot("Piece-iOS.entitlements")),
      dependencies: dependencies,
      settings: .settings(
        base: [
          "OTHER_LDFLAGS": ["-ObjC"]
        ],
        configurations: [
          .debug(name: "Debug", xcconfig: .relativeToRoot("Debug.xcconfig")),
          .release(name: "Release", xcconfig: .relativeToRoot("Release.xcconfig"))
        ]
      )
      //          .settings(
      //        configurations: [
      //          .configuration(environment: .dev),
      //          .configuration(environment: .prod),
      //        ]
      //      )
      ,
      environmentVariables: [:],
      additionalFiles: []
    )
    
    return Project(
      name: name,
      organizationName: AppConstants.organizationName,
      options: .options(
        automaticSchemesOptions: .disabled,
        developmentRegion: "kor"
      ),
      packages: packages,
      settings: .settings(),
      //          .settings(configurations: [
      //        .configuration(environment: .dev),
      //        .configuration(environment: .prod),
      //      ]),
      targets: [target],
      schemes: [
        .makeScheme(),
        //        .makeScheme(environment: .dev),
        //        .makeScheme(environment: .prod),
      ]
    )
  }
}
