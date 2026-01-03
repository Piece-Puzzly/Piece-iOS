//
//  PCLottieView.swift
//  DesignSystem
//
//  Created by summercat on 2/16/25.
//

import Lottie
import SwiftUI

public struct PCLottieView: View {
  private let animation: Lotties
  private let loopMode: LottieLoopMode
  private let fromProgress: AnimationProgressTime?
  private let toProgress: AnimationProgressTime?
  private let width: CGFloat?
  private let height: CGFloat?
  private let animationDidFinish: ((Bool) -> Void)?
  
  public init(
    _ animation: Lotties,
    loopMode: LottieLoopMode = .loop,
    fromProgress: AnimationProgressTime? = nil,
    toProgress: AnimationProgressTime? = nil,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    animationDidFinish: ((Bool) -> Void)? = nil
  ) {
    self.animation = animation
    self.loopMode = loopMode
    self.fromProgress = fromProgress
    self.toProgress = toProgress
    self.width = width
    self.height = height
    self.animationDidFinish = animationDidFinish
  }
  
  public var body: some View {
    LottieView(animation: .named(animation.name, bundle: Bundle.module))
      .playing(
        .fromProgress(
          fromProgress ?? 0,
          toProgress: toProgress ?? 1,
          loopMode: loopMode
        )
      )
      .animationDidFinish { completed in
        animationDidFinish?(completed)
      }
      .frame(width: width ?? nil, height: height ?? nil)
  }
}

#Preview {
  VStack {
    PCLottieView(.aiSummaryLarge)
    PCLottieView(.aiSummaryLarge, width: 100, height: 100)
  }
}
