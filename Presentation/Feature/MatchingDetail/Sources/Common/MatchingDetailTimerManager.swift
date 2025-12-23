//
//  MatchingDetailTimerManager.swift
//  MatchingDetail
//
//  Created by 홍승완 on 12/16/25.
//

import Foundation
import Observation
import PCFoundationExtension

@Observable
final class MatchingDetailTimerManager {
  private let matchedDate: Date
  private var timer: Timer?
  private var expirationDate: Date?

  var remainingTime: String = "60:00"
  var shouldShowTimer: Bool = false
  var onTimerExpired: (() -> Void)?

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
      remainingTime = "00:00"
      shouldShowTimer = false
      return
    }

    let now = Date()
    let timeInterval = expirationDate.timeIntervalSince(now)

    // 만료된 경우
    if timeInterval <= 0 {
      remainingTime = "00:00"
      shouldShowTimer = true
      timer?.invalidate()
      onTimerExpired?()
      return
    }

    let totalSeconds = Int(timeInterval)
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let seconds = totalSeconds % 60

    // 60분 이하인 경우만 표시 (60:00 ~ 00:01)
    if hours == 0 && minutes <= 60 {
      shouldShowTimer = true
      remainingTime = String(format: "%02d:%02d", minutes, seconds)
    } else {
      shouldShowTimer = false
    }
  }
}
