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
    
    let prodTarget = Target.makeAppTarget(
      name: AppConstants.appName,
      bundleId: AppConstants.bundleId,
      dependencies: dependencies
    )
    
    // TODO: - 추후 타겟 분리하면 씀
//    let devTarget = Target.makeAppTarget(
//      name: AppConstants.devAppName,
//      bundleId: AppConstants.devBundleId,
//      bundleDisplayName: AppConstants.devBundleDisplayName,
//      dependencies: dependencies
//    )
    
    return Project(
      name: name,
      organizationName: AppConstants.organizationName,
      options: .options(
        automaticSchemesOptions: .disabled,
        developmentRegion: "kor"
      ),
      packages: packages,
      settings: .settings(),
      targets: [
        prodTarget,
        // TODO: - 추후 타겟 분리하면 씀
//        devTarget
      ],
      schemes: [
        .makeDevScheme(),
        .makeReleaseScheme(),
      ]
    )
  }
}

extension Target {
  static func makeAppTarget(
    name: String,
    bundleId: String,
    dependencies: [TargetDependency]
  ) -> Target {
    return Target.target(
      name: name,
      destinations: AppConstants.destinations,
      product: .app,
      bundleId: bundleId,
      deploymentTargets: AppConstants.deploymentTargets,
      infoPlist: .extendingDefault(
        with: [
          "UIUserInterfaceStyle": "Light",
          "UILaunchStoryboardName": "LaunchScreen",
          "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
          ],
          "UIBackgroundModes": ["remote-notification"],
          "NSCameraUsageDescription": "프로필 생성 시 사진 첨부를 위해 카메라 접근 권한이 필요합니다.",
          "NSPhotoLibraryUsageDescription": "프로필 생성 시 사진 첨부를 위해 앨범 접근 권한이 필요합니다.",
          "NSContactsUsageDescription": "'아는 사람 차단' 기능을 활성화하려면 연락처 접근이 필요합니다. 허용 시 해당 연락처와 일치하는 계정은 즉시 차단되며, 이를 위해 연락처 목록이 피스 서버에 안전하게 업로드됩니다. 업로드된 정보는 제3자에게 절대 제공되지 않습니다.",
          "BASE_URL": "$(BASE_URL)",
          "NATIVE_APP_KEY": "$(NATIVE_APP_KEY)",
          "AMPLITUDE_API_KEY": "$(AMPLITUDE_API_KEY)",
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
      scripts: [
        .post(
          script: "${SRCROOT}/../Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run",
          name: "Firebase Crashlytics dSYM Upload",
          inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
            "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
            "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)",
          ]
        )
      ],
      dependencies: dependencies,
      settings: .settings(
        base: [
          "OTHER_LDFLAGS": ["-ObjC"],
          "CODE_SIGN_STYLE": SettingValue.string(AppConstants.codeSignStyle),
          "DEVELOPMENT_TEAM": SettingValue.string(AppConstants.developmentTeam),
          "MARKETING_VERSION": SettingValue.string(AppConstants.versionString),
          "CURRENT_PROJECT_VERSION": SettingValue.string(AppConstants.buildString),
          "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        ],
        configurations: [
          .configuration(environment: .Debug),
          .configuration(environment: .Release),
        ]
      ),
      environmentVariables: [:],
      additionalFiles: []
    )
  }
}
