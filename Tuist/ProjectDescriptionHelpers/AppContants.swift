//
//  AppContants.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 12/16/24.
//

import ProjectDescription

public enum AppConstants {
  public static let appName: String = "Piece-iOS"
  public static let organizationName: String = "puzzly"
  public static let bundleId: String = "com.puzzly.piece"
  public static let bundleDisplayName: Plist.Value = "피스"
  public static let version: Plist.Value = "1.0.1"
  public static let build: Plist.Value = "1"
  public static let destinations: Set<Destination> = [.iPhone]
  public static let deploymentTargets: DeploymentTargets = .iOS("17.0")
}
