//
//  ImmediateScrollTapModifier.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/5/25.
//

import SwiftUI

private struct ScrollTouchTuning: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let v = UIView()
    Task {
      var cur: UIView? = v
      while let u = cur {
        if let s = u as? UIScrollView {
          s.delaysContentTouches = false
          s.canCancelContentTouches = true
          break
        }
        cur = u.superview
      }
    }
    return v
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {}
}

public extension View {
  func immediateScrollTap() -> some View {
    background(ScrollTouchTuning())
  }
}
