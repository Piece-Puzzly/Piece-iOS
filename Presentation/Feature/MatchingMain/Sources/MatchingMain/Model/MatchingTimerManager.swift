//
//  MatchingTimerManager.swift
//  MatchingMain
//
//  Created by 홍승완 on 11/23/25.
//

import Foundation
import Observation
import PCFoundationExtension

@Observable
final class MatchingTimerManager {
  private let matchedDateTime: String
  private var timer: Timer?
  private var expirationDate: Date?

  var remainingTime: String = "24:00:00"

  init(matchedDateTime: String) {
    self.matchedDateTime = matchedDateTime
    setupTimer()
  }

  deinit {
    timer?.invalidate()
  }

  private func setupTimer() {
    // ISO8601 문자열을 Date로 변환 (타임존 없는 형식)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.locale = Locale(identifier: "en_US_POSIX") // 국제 표준: ISO8601 같은 표준 날짜 형식을 파싱할 때는 언어/지역과 무관한 POSIX 로케일 사용
    formatter.timeZone = TimeZone.current

    guard let matchedDate = formatter.date(from: matchedDateTime) else {
      remainingTime = "00:00:00"
      return
    }

    // 매칭 시간 + 24시간 = 만료 시간
    expirationDate = Calendar.current.date(byAdding: .hour, value: 24, to: matchedDate)

    // 초기 시간 업데이트
    updateRemainingTime()

    // 타이머 시작
    startTimer()
  }

  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      self?.updateRemainingTime()
    }
  }

  private func updateRemainingTime() {
    guard let expirationDate else {
      remainingTime = "00:00:00"
      return
    }

    let now = Date()
    let timeInterval = expirationDate.timeIntervalSince(now)

    // 만료된 경우
    if timeInterval <= 0 {
      remainingTime = "00:00:00"
      timer?.invalidate()
      return
    }
    
    remainingTime = DateFormatter.formattedTimeString(from: timeInterval)
  }
}
