//
//  MatchInfosModle.swift
//  Entities
//
//  Created by eunseou on 2/15/25.
//

import SwiftUI

public struct MatchInfosModel {
  public let matchId: Int
  public let matchedUserId: Int
  public let matchStatus: MatchStatus
  public let description: String
  public let nickname: String
  public let birthYear: String
  public let location: String
  public let job: String
  public let matchedValueCount: Int
  public let matchedValueList: [String]
  public let isBlocked: Bool
  public let matchingType: MatchingType
  
  public init(
    matchId: Int,
    matchedUserId: Int,
    matchStatus: MatchStatus,
    description: String,
    nickname: String,
    birthYear: String,
    location: String,
    job: String,
    matchedValueCount: Int,
    matchedValueList: [String],
    isBlocked: Bool,
    matchingType: MatchingType,
  ) {
    self.matchId = matchId
    self.matchedUserId = matchedUserId
    self.matchStatus = matchStatus
    self.description = description
    self.nickname = nickname
    self.birthYear = birthYear
    self.location = location
    self.job = job
    self.matchedValueCount = matchedValueCount
    self.matchedValueList = matchedValueList
    self.isBlocked = isBlocked
    self.matchingType = matchingType
  }
}

public extension MatchInfosModel {
  static let dummy: [MatchInfosModel] = [
    MatchInfosModel(
      matchId: 1,
      matchedUserId: 101,
      matchStatus: .WAITING,
      description: "바깥 데이트를 즐기는",
      nickname: "김민수",
      birthYear: "1995",
      location: "서울 강남구",
      job: "IT 개발자",
      matchedValueCount: 3,
      matchedValueList: ["운동", "여행", "독서"],
      isBlocked: false,
      matchingType: .basic
    ),
    MatchInfosModel(
      matchId: 2,
      matchedUserId: 102,
      matchStatus: .BEFORE_OPEN,
      description: "바깥 데이트를 마음껏 재미있게 즐기는",
      nickname: "퍼즐리",
      birthYear: "1997",
      location: "서울 마포구",
      job: "디자이너",
      matchedValueCount: 2,
      matchedValueList: ["미술", "음악"],
      isBlocked: false,
      matchingType: .basic
    ),
    MatchInfosModel(
      matchId: 3,
      matchedUserId: 103,
      matchStatus: .RESPONDED,
      description: "자연과 함께하는 삶을 지향합니다.",
      nickname: "이서현",
      birthYear: "1996",
      location: "경기 성남시",
      job: "환경 컨설턴트",
      matchedValueCount: 4,
      matchedValueList: ["등산", "캠핑", "요가", "환경보호"],
      isBlocked: false,
      matchingType: .trialPremium
    ),
    MatchInfosModel(
      matchId: 4,
      matchedUserId: 104,
      matchStatus: .GREEN_LIGHT,
      description: "맛집 탐방과 요리를 좋아합니다.",
      nickname: "최준호",
      birthYear: "1994",
      location: "서울 송파구",
      job: "요리사",
      matchedValueCount: 2,
      matchedValueList: ["요리", "맛집"],
      isBlocked: false,
      matchingType: .auto
    ),
    MatchInfosModel(
      matchId: 5,
      matchedUserId: 105,
      matchStatus: .MATCHED,
      description: "영화와 책으로 세상을 배웁니다.",
      nickname: "정수민",
      birthYear: "1998",
      location: "서울 용산구",
      job: "영화 평론가",
      matchedValueCount: 5,
      matchedValueList: ["영화", "독서", "글쓰기", "커피", "산책"],
      isBlocked: false,
      matchingType: .auto
    )
  ]
}
