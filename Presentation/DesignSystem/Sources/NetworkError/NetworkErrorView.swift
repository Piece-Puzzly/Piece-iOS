//
//  NetworkErrorView.swift
//  DesignSystem
//
//  Created by 홍승완 on 10/13/25.
//

import SwiftUI

public struct NetworkErrorView: View {
  @Environment(\.dismiss) private var dismiss
  
  private let onRetry: () -> Void
  
  public init(
    onRetry: @escaping () -> Void
  ) {
    self.onRetry = onRetry
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(maxWidth: .infinity, maxHeight: 39)
      
      Spacer()
        .frame(maxWidth: .infinity, maxHeight: 141)
      
      content
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      Spacer()
        .frame(maxWidth: .infinity, maxHeight: 141)
      
      retryButton
        .padding(.horizontal, 20)
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
      type: .solid,
      buttonText: "다시 연결 시도하기",
      width: .maxWidth,
      action: {
        Task { @MainActor in
          onRetry()
          dismiss()
        }
      }
    )
  }
}
