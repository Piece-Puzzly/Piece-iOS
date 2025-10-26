//
//  PCPuzzleCount.swift
//  DesignSystem
//
//  Created by 홍승완 on 10/26/25.
//

import SwiftUI

public struct PCPuzzleCount: View {
  private let count: Int
  private let style: Style
  
  public init(style: Style) {
    self.count = 0
    self.style = style
  }
  
  public init(count: Int, style: Style) {
    self.count = count
    self.style = style
  }
  
  public var body: some View {
    switch style {
    case .dark:
      PCPuzzleCountContent(count: count, style: style)
        .transition(.asymmetric(
          insertion: .offset(.init(width: 16, height: 0)),
          removal: .offset(.init(width: 16, height: 0)).combined(with: .opacity)
        ))

    case .light:
      HStack(spacing: 8) {
        DesignSystemAsset.Icons.chevronLeft32.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(Color.grayscaleWhite)
        
        PCPuzzleCountContent(count: count, style: style)
      }
      
    case .skeleton(let skeletonStyle):
      PCPuzzleCountSkeleton(skeletonStyle: skeletonStyle)
    }
  }
}

fileprivate struct PCPuzzleCountContent: View {
  let count: Int
  let style: PCPuzzleCount.Style
  
  var body: some View {
    let config = style.config
    
    HStack(spacing: 4) {
      DesignSystemAsset.Icons.puzzleSolid24.swiftUIImage
        .renderingMode(.template)
        .foregroundStyle(config.iconColor)
        .rotationEffect(.degrees(45))
      
      Text(formattedCount)
        .pretendard(.heading_M_M)
        .foregroundStyle(config.textColor)
      
      if config.showPlusIcon {
        DesignSystemAsset.Icons.plusLine20.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(config.plusIconColor)
      }
    }
    .padding(.leading, 12)
    .padding(.trailing, config.trailingPadding)
    .padding(.top, 7)
    .padding(.bottom, 8)
    .background(config.backgroundColor)
    .cornerRadius(24)
  }
  
  private var formattedCount: String {
    return count.formatted(.number.grouping(.automatic))
  }
}

fileprivate struct PCPuzzleCountSkeleton: View {
  let skeletonStyle: PCPuzzleCount.Style.SkeletonStyle
  
  var body: some View {
    let config = PCPuzzleCount.Style.skeleton(skeletonStyle).config
    
    Color.clear
      .frame(width: 80, height: 39)
      .padding(.trailing, config.trailingPadding)
      .background(config.backgroundColor)
      .cornerRadius(24)
  }
}

extension PCPuzzleCount {
  public enum Style: Equatable {
    case dark
    case light
    case skeleton(SkeletonStyle)
    
    public enum SkeletonStyle: Equatable {
       case dark
       case light
     }
    
    var config: (
      backgroundColor: Color,
      textColor: Color,
      iconColor: Color,
      plusIconColor: Color,
      trailingPadding: CGFloat,
      showPlusIcon: Bool
    ) {
      switch self {
      case .dark: (.alphaWhite10, .grayscaleWhite, .grayscaleWhite, .grayscaleDark3, 8, true)
      
      case .light: (.grayscaleWhite, .grayscaleBlack, .grayscaleBlack, .grayscaleDark3, 16, false)
      
      case .skeleton(let skeletonStyle):
        switch skeletonStyle {
        case .dark: (.alphaWhite10, .clear, .clear, .clear, 16, true)
        case .light: (.grayscaleLight3, .clear, .clear, .clear, 0, false)
        }
      }
    }
  }
}
