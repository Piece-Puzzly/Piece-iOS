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
  private let matchedDate: Date
  private var timer: Timer?
  private var expirationDate: Date?

  var remainingTime: String = "24:00:00"

  init(matchedDate: Date) {
    self.matchedDate = matchedDate
    setupTimer()
  }

  deinit {
    timer?.invalidate()
  }

  private func setupTimer() {
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
