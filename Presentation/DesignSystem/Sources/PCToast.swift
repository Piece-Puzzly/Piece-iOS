//
//  PCToast.swift
//  DesignSystem
//
//  Created by summercat on 2/11/25.
//

import SwiftUI

public struct PCToast: View {
  @Binding public var isVisible: Bool
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
      icon?
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
    .onChange(of: isVisible) { _, newValue in
      if newValue {
        updateTextThenFadeIn()
        scheduleAutoHide()
      }
    }
  }
}

// MARK: - Private Animation Methods
extension PCToast {
  /// 텍스트를 즉시 업데이트한 후, opacity만 애니메이션으로 페이드인
  private func updateTextThenFadeIn() {
    // 1단계: 텍스트 즉시 변경 (애니메이션 없음)
    displayText = text ?? "TOAST MESSAGE IS EMPTY"
    
    // 2단계: 다음 프레임에서 opacity 애니메이션
    Task {
      animatedVisibility = true
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

#Preview {
  PCToast(
    isVisible: .constant(true),
    icon: DesignSystemAsset.Icons.question20.swiftUIImage,
    text: "토스트"
  )
}
