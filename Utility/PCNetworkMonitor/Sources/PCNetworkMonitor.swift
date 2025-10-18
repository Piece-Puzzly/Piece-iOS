//
//  PCNetworkMonitor.swift
//  Piece-iOS
//
//  Created by 홍승완 on 10/5/25.
//  Copyright © 2025 puzzly. All rights reserved.
//

import Network
import Observation
import Foundation
import Combine

/// 네트워크 상태 변화를 감지하고 이벤트를 방출하는 모니터
@MainActor
@Observable
public final class PCNetworkMonitor {
  /// 현재 네트워크 이벤트 (연결, 끊어짐, 인터페이스 변경)
  public private(set) var networkEvent: NetworkEvent? = nil
  
  /// 현재 네트워크 연결 상태
  public private(set) var isConnected: Bool = true
  
  /// Combine publisher로 연결 상태 구독 가능
  public var connectionPublisher: AnyPublisher<Bool, Never> {
    connectionSubject.eraseToAnyPublisher()
  }
  
  private let networkMonitor = NWPathMonitor()
  private let networkQueue = DispatchQueue(label: "NetworkMonitor")
  // Combine 지원을 위한 Subject 추가
  private let connectionSubject = PassthroughSubject<Bool, Never>()

  private var availableInterfaces: [String] = []
  private var previousInterfaces: [String] = []
  
  /// 네트워크 이벤트 타입
  public enum NetworkEvent: Equatable {
    case connected
    case disconnected
    case interfaceChanged(from: [String], to: [String])
  }
  
  /// 초기화 시 자동으로 네트워크 모니터링 시작
  public init() {
    print("🌐 NetworkMonitor init - startMonitoring")
    startMonitoring()
  }
  
  /// 네트워크 모니터링 시작
  public func startMonitoring() {
    networkMonitor.pathUpdateHandler = { [weak self] path in
      print("🌐 네트워크 pathUpdateHandler called: \(path)")
      Task { @MainActor in
        await self?.handlePathUpdate(path)
      }
      
      if path.status == .satisfied {
        print("🌐 네트워크 연결됨: \(path.availableInterfaces)")
      } else {
        print("🌐 네트워크 연결 안됨: \(path.availableInterfaces)")
      }
    }
    
    networkMonitor.start(queue: networkQueue)
  }
  
  /// 네트워크 모니터링 중지
  public func stopMonitoring() {
    networkMonitor.cancel()
  }
  
  /// 현재 네트워크 상태 강제 확인
  public func checkConnection() async {
    await MainActor.run {
      networkMonitor.pathUpdateHandler?(networkMonitor.currentPath)
    }
  }
  
  public func checkRealInternetConnection() async -> Bool {
    guard let url = URL(string: "https://www.apple.com") else {
      return false
    }
    
    do {
      let (_, response) = try await URLSession.shared.data(from: url)
      
      if let httpResponse = response as? HTTPURLResponse, isConnected {
        let isConnected = httpResponse.statusCode == 200
        print("DEBUG: 🌐 NetworkMonitor - 실제 인터넷 연결 확인: \(isConnected ? "성공" : "실패") (code: \(httpResponse.statusCode))")
        return isConnected
      }
    } catch {
      print("DEBUG: 🌐 NetworkMonitor - 실제 인터넷 연결 확인 실패: \(error)")
      return false
    }
    
    return false
  }
  
  /// 네트워크 경로 변화 처리
  /// - Parameter path: 새로운 네트워크 경로
  private func handlePathUpdate(_ path: NWPath) async {
    let wasConnected = isConnected
    let wasInterfaces = availableInterfaces
    
    isConnected = path.status == .satisfied
    availableInterfaces = path.availableInterfaces.map { $0.name }
    previousInterfaces = wasInterfaces
    
    connectionSubject.send(isConnected)
    
    // 이벤트 감지 및 방출
    let connectionChanged = wasConnected != isConnected
    let interfaceChanged = Set(wasInterfaces) != Set(availableInterfaces)
    
    // 연결 상태 변화 처리
    if connectionChanged {
      networkEvent = isConnected ? .connected : .disconnected
      print("DEBUG: 🌐 NetworkMonitor - 이벤트: \(networkEvent!)")
    } else if interfaceChanged && isConnected {
      // 연결된 상태에서만 인터페이스 변경 이벤트 발생
      networkEvent = .interfaceChanged(from: wasInterfaces, to: availableInterfaces)
      print("DEBUG: 🌐 NetworkMonitor - 이벤트: \(networkEvent!)")
    }
  }
  
  deinit {
    networkMonitor.cancel()
  }
}

