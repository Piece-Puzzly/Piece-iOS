//
//  ProfileRepositoryInterface.swift
//  UseCases
//
//  Created by summercat on 2/9/25.
//

import Entities
import SwiftUI

public protocol ProfileRepositoryInterface {
  func postProfile(_ profile: ProfileModel) async throws -> PostProfileResultModel
  func putProfile(_ profile: ProfileModel) async throws -> VoidModel
  func getProfileBasic() async throws -> ProfileBasicModel
  func updateProfileBasic(_ profile: ProfileBasicModel) async throws -> ProfileBasicModel
  func getProfileValueTalks() async throws -> [ProfileValueTalkModel]
  func updateProfileValueTalks(_ valueTalks: [ProfileValueTalkModel]) async throws -> [ProfileValueTalkModel]
  func updateProfileValueTalkSummary(profileTalkId: Int, summary: String) async throws -> VoidModel
  func getProfileValuePicks() async throws -> [ProfileValuePickModel]
  func updateProfileValuePicks(_ valuePicks: [ProfileValuePickModel]) async throws -> VoidModel
  func uploadProfileImage(_ imageData: Data) async throws -> URL
}
