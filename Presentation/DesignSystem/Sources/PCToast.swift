//
//  PCToast.swift
//  DesignSystem
//
//  Created by summercat on 2/11/25.
//

import SwiftUI

public struct PCToast: View {
  @Binding public var isVisible: Bool
  @State private var displayIcon: Image? = nil
  @State private var displayText: String = ""
  @State private var animatedVisibility: Bool = false
  private let icon: Image?
  private let text: String?
  private let textColor: Color
  private let backgroundColor: Color
  
  public init(
    isVisible: Binding<Bool>,
    icon: Image? = nil,
    text: String?,
    textColor: Color = .grayscaleWhite,
    backgroundColor: Color = .grayscaleDark2
  ) {
    self._isVisible = isVisible
    self.icon = icon
    self.text = text
    self.textColor = textColor
    self.backgroundColor = backgroundColor
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: 8) {
      displayIcon?
        .renderingMode(.template)
        .resizable()
        .frame(width: 20, height: 20)
        .foregroundStyle(textColor)
      
        Text(displayText)
          .pretendard(.body_S_M)
          .foregroundStyle(textColor)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .foregroundStyle(backgroundColor)
    )
    .opacity(animatedVisibility ? 1 : 0)
    .animation(.easeInOut, value: animatedVisibility)
    .onAppear {
      if isVisible {
        updateContentThenFadeIn()
        scheduleAutoHide()
      }
    }
    .onChange(of: isVisible) { _, newValue in
      if newValue {
        updateContentThenFadeIn()
        scheduleAutoHide()
      } else {
        animatedVisibility = false
      }
    }
  }
}

// MARK: - Private Animation Methods
extension PCToast {
  /// 텍스트와 아이콘을 즉시 업데이트한 후, opacity만 애니메이션으로 페이드인
  private func updateContentThenFadeIn() {
    // 1단계: 텍스트와 아이콘 즉시 변경 (애니메이션 없음)
    displayText = text ?? "TOAST MESSAGE IS EMPTY"
    displayIcon = icon
    animatedVisibility = false  // 먼저 리셋
    
    // 2단계: 다음 프레임에서 opacity 애니메이션
    Task { @MainActor in
      animatedVisibility = true  // 다음 렌더 사이클에서 true
    }
  }
  
  /// 3초 후 자동 fade-out
  private func scheduleAutoHide() {
    Task {
      try? await Task.sleep(for: .seconds(3))
       animatedVisibility = false  // fade-out 시작
       isVisible = false           // 부모에게 상태 전달
    }
  }
}

public enum ToastTarget {
  case matchingHome
  case matchProfileBasic
  case matchDetailPhoto
  case matchResult
}

@MainActor
@Observable
public final class PCToastManager {
  public var isVisible: Bool = false
  public var target: ToastTarget? = nil
  public private(set) var icon: Image? = nil
  public private(set) var text: String? = nil
  public private(set) var textColor: Color = .grayscaleWhite
  public private(set) var backgroundColor: Color = .grayscaleDark2
  
  public init() {}
  
  public func showToast(
    target: ToastTarget? = nil,
    delay: Double = 0.3,
    icon: Image? = nil,
    text: String?,
    textColor: Color = .grayscaleWhite,
    backgroundColor: Color = .grayscaleDark2
  ) {
    Task {
      try? await Task.sleep(for: .seconds(delay))
      
      // 1. 먼저 isVisible을 false로 리셋 (이전 토스트 정리)
      self.isVisible = false
      
      // 2. 다음 프레임에서 새로운 토스트 표시
      Task { @MainActor in
        self.target = target
        self.icon = icon
        self.text = text
        self.backgroundColor = backgroundColor
        self.isVisible = true  // onChange 확실히 트리거!
      }
    } 
  }
  
  public func hideToast(for target: ToastTarget? = nil) {
    guard let target = target else {
      // target이 nil이면 모든 토스트 clear
      self.isVisible = false
      self.target = nil
      return
    }

    // 특정 target만 clear
    if self.target == target {
      self.isVisible = false
      self.target = nil
    }
  }
  
  public func shouldShowToast(for target: ToastTarget) -> Bool {
    self.target == target || self.target == nil
  }
}

#Preview {
  PCToast(
    isVisible: .constant(true),
    icon: DesignSystemAsset.Icons.question20.swiftUIImage,
    text: "토스트"
  )
}
