//
//  AppContants.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 12/16/24.
//

import ProjectDescription
import Foundation

public enum AppConstants {
  // MARK: - Signing & Certificate
  public static let developmentTeam: String = "$(DEVELOPMENT_TEAM)"
  public static let provisioningProfile: String = "$(PROVISIONING_PROFILE)"
  public static let codeSignStyle: String = "$(CODE_SIGN_STYLE)"
 
  // MARK: - 실제 앱스토어 릴리즈 전용
  public static let appName: String = "Piece-iOS"
  
  public static let bundleId: String = "com.puzzly.piece"
  
  public static let bundleDisplayNameString: String = "$(BUNDLE_DISPLAY_NAME)"
  public static let bundleDisplayName: Plist.Value = "\(bundleDisplayNameString)"
  
  // TODO: - 추후 카카오 디벨로퍼 멀티앱 승인 후 멀티 BundleId가 가능해지고, 타겟 분리가 가능해질 때 쓸 것
  // MARK: - 내부 테스트 전용
//  public static let devAppName: String = "Piece-iOS-Dev"
//  public static let devBundleId: String = "com.puzzly.piece.dev"
//  public static let devBundleDisplayName: Plist.Value = "피스-Dev"
  
  // MARK: - [내부 테스트/실제 앱스토어 릴리즈] 공통
  public static let organizationName: String = "puzzly"
  
  public static let versionString: String = "$(APP_VERSION)"
  public static let version: Plist.Value = "\(versionString)"
  
  public static let buildString: String = "$(APP_BUILD)"
  public static let build: Plist.Value = "\(buildString)"
  
  public static let destinations: Set<Destination> = [.iPhone]
  public static let deploymentTargets: DeploymentTargets = .iOS("17.0")
}
