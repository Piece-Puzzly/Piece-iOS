//
//  TextCountIndicator.swift
//  SignUp
//
//  Created by summercat on 2/9/25.
//

import SwiftUI

public struct TextCountIndicator: View {
  @Binding public var count: Int
  private let minCount: Int?
  private let maxCount: Int
  
  public init(
    count: Binding<Int>,
    minCount: Int? = nil,
    maxCount: Int
  ) {
    self._count = count
    self.minCount = minCount
    self.maxCount = maxCount
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      if let minCount,
      minCount > count {
        Text("\(minCount)자 이상 작성해 주세요.")
          .pretendard(.body_S_M)
          .foregroundStyle(Color.systemError)
        Spacer()
      }
      Text(count.description)
        .pretendard(.body_S_M)
        .foregroundStyle(Color.primaryDefault)
      Text("/\(maxCount)")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
  }
}

#Preview {
  TextCountIndicator(count: .constant(15), minCount: 30, maxCount: 300)
  TextCountIndicator(count: .constant(150), minCount: 30, maxCount: 300)
  TextCountIndicator(count: .constant(150), maxCount: 300)
}
