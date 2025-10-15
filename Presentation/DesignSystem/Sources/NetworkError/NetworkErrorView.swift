//
//  NetworkErrorView.swift
//  DesignSystem
//
//  Created by 홍승완 on 10/13/25.
//

import UIKit
import SwiftUI
import PCNetworkMonitor

public struct NetworkErrorView: View {
  enum BannerState: Equatable {
    case hidden          // 안정
    case unstable        // 불안정
    case restored        // 복구(문구 잠깐 노출 후 자동 숨김)
    case hiding          // 사라지는 중

    var text: String {
      switch self {
      case .hidden:   
        return ""
      case .unstable:
        return "네트워크 연결이 불안정해요!"
      case .restored, .hiding:
        return "네트워크가 다시 연결되었어요"
      }
    }

    var visible: Bool { self != .hidden }
  }
  
  @Environment(PCNetworkMonitor.self) var networkMonitor
  @State private var isCheckingNetwork: Bool = false
  @State private var bannerState: BannerState = .hidden
  @State private var bannerOpacity: Double = 1.0
  
  private let onRetry: () -> Void
  
  public init(onRetry: @escaping () -> Void) {
    self.onRetry = onRetry
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Spacer().frame(maxWidth: .infinity, maxHeight: 39)
      Spacer().frame(maxWidth: .infinity, maxHeight: 141)
      
      content
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      Spacer().frame(maxWidth: .infinity, maxHeight: 141)
      
      retryButton
        .padding(.horizontal, 20)
    }
    .background(Color.white)
    .overlay(alignment: .top) {
      TopNetworkBanner(state: bannerState)
        .ignoresSafeArea()
        .opacity(bannerOpacity)
    }
    .onAppear {
      Task {
        try await Task.sleep(nanoseconds: 100_000_000)
        await MainActor.run {
          bannerState = networkMonitor.isConnected ? .hidden : .unstable
        }
      }
    }
    .onChange(of: networkMonitor.isConnected) { _, isConnected in
      Task {
        await MainActor.run {
          if isConnected { bannerState = .restored }
          else { bannerState = .unstable }
        }
      }
    }
    .onChange(of: bannerState) { old, new in
      if new == .restored {
        Task {
          await MainActor.run { bannerState = .hiding }
          try? await Task.sleep(nanoseconds: 1_200_000_000)
          await MainActor.run { bannerState = .hidden }
        }
        return
      }
      
      Task {
        switch (old, new) {
        case (.hidden, .unstable):
          await MainActor.run { bannerOpacity = 1.0 }
        case (.hiding, .hidden):
          try? await Task.sleep(nanoseconds: 250_000_000)
          await MainActor.run { bannerOpacity = 0.0 }
        default: break
        }
      }
    }
  }
  
  private var content: some View {
    VStack(spacing: 12) {
      Text("네트워크 연결이 불안정해요!")
        .pretendard(.heading_L_SB)
        .foregroundStyle(Color.grayscaleBlack)
        .padding(.top, 20)
      
      Text("네트워크가 원활한 곳으로 이동해 주세요.")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
      
      DesignSystemAsset.Images.imgNotice.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  private var retryButton: some View {
    RoundedButton(
      type: isCheckingNetwork ? .disabled : .solid,
      buttonText: isCheckingNetwork ? "연결 확인 중..." : "다시 연결 시도하기",
      width: .maxWidth
    ) {
      guard !isCheckingNetwork else { return }
      isCheckingNetwork = true
      
      Task {
        let isSuccess = await networkMonitor.checkRealInternetConnection()

        if isSuccess {
          onRetry()
        }

        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run { isCheckingNetwork = false }
      }
    }
  }
}

fileprivate struct TopNetworkBanner: View {
  let state: NetworkErrorView.BannerState
  
  var body: some View {
    let top = topSafeAreaInset()
    
    VStack(spacing: 0) {
      Rectangle()
        .fill(Color.grayscaleDark3)
        .frame(maxWidth: .infinity)
        .frame(height: top)
      
      Text(state.text)
        .pretendard(.body_S_M)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(Color.grayscaleDark3)
    }
    .offset(y: state.visible ? 0 : -(top + 40))
    .animation(.easeInOut(duration: 0.25), value: state.visible)
  }
  
  private func topSafeAreaInset() -> CGFloat {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }?
      .safeAreaInsets.top ?? 0
  }
}
