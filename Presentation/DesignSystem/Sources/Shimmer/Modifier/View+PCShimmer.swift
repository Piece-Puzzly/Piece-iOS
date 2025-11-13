//
//  View+PCShimmer.swift
//  DesignSystem
//
//  Created by 홍승완 on 11/13/25.
//

import SwiftUI

public extension View {
  func pcShimmer(style: ShimmerStyle = .light) -> some View {
    modifier(PCShimmer(style: style))
  }
}
