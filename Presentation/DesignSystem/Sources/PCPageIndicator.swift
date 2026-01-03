//
//  PCPageIndicator.swift
//  DesignSystem
//
//  Created by summercat on 2/8/25.
//

import SwiftUI

public struct PCPageIndicator: View {
  public enum IndicatorStep {
    case first
    case second
    case third
    
    var widthRatio: CGFloat {
      switch self {
      case .first: 0.25
      case .second: 0.5
      case .third: 0.75
      }
    }
  }
  
  public init(step: IndicatorStep, width: CGFloat) {
    self.step = step
    self.width = width
  }
  
  private let step: IndicatorStep
  private let width: CGFloat
  
  public var body: some View {
    ZStack(alignment: .leading) {
      Rectangle()
        .fill(Color.grayscaleLight2)
        .frame(width: width, height: 6)
        .cornerRadius(4)
      Rectangle()
        .fill(Color.primaryDefault)
        .frame(width: width * step.widthRatio, height: 6)
        .cornerRadius(4)
    }
  }
}

#Preview {
  PCPageIndicator(step: .first, width: 500)
}
