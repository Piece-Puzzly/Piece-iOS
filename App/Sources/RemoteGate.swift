import Foundation
import SwiftUI
import Observation
import PCFirebase
import PCFoundationExtension

@MainActor
@Observable
final class RemoteGate {
  var showForceUpdate: Bool = false
  var showMaintenance: Bool = false
  var maintenancePeriod: String = ""
  
  func refresh() async {
    do {
      try await PCFirebase.shared.fetchRemoteConfigValues()
    } catch {
      print("🔥 RemoteConfig fetch failed on refresh: \(error)")
    }
    
    evaluateForceUpdate()
    evaluateMaintenance()
  }
  
  func openAppStore() {
    let appId = "6742348014"
    let appStoreUrl = "itms-apps://itunes.apple.com/app/apple-store/\(appId)"
    guard let url = URL(string: appStoreUrl) else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
  
  // MARK: - Private
  private func evaluateForceUpdate() {
    let currentVersion = AppVersion.appVersion()
    
    #if DEBUG
    let minimumVersion = PCFirebase.shared.minimumVersionDebug()
    #else
    let minimumVersion = PCFirebase.shared.minimumVersion()
    #endif
    
    let needsForceUpdate = currentVersion.compare(minimumVersion, options: .numeric) == .orderedAscending
    showForceUpdate = needsForceUpdate
  }
  
  private struct MaintenancePayload: Decodable {
    let maintenancePeriod: String?
  }
  
  private func evaluateMaintenance() {
    let isDebug = _isDebugAssertConfiguration()
    let jsonString = PCFirebase.shared.maintenancePeriodString(isDebug: isDebug)
    let trimmed = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !trimmed.isEmpty,
          let data = trimmed.data(using: .utf8),
          let payload = try? JSONDecoder().decode(MaintenancePayload.self, from: data),
          let period = payload.maintenancePeriod,
          !period.isEmpty else {
      showMaintenance = false
      maintenancePeriod = ""
      return
    }
    
    // 강제 업데이트가 우선이므로 force update가 켜져 있으면 점검은 띄우지 않음
    guard !showForceUpdate else {
      showMaintenance = false
      return
    }
    
    maintenancePeriod = period
    showMaintenance = true
  }
}
