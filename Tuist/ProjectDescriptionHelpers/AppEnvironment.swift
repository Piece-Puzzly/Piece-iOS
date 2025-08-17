//
//  AppEnvironment.swift
//  ProjectDescriptionHelpers
//
//  Created by summercat on 12/19/24.
//

import ProjectDescription
//
public enum AppEnvironment: String {
  case Debug /// 개발 서버 스킴
  case Release /// 운영 서버 스킴
  
  public var configurationName: ConfigurationName {
    return ConfigurationName.configuration(self.rawValue)
  }
}
