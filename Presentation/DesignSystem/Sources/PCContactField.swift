//
//  PCContactField.swift
//  DesignSystem
//
//  Created by 홍승완 on 5/16/25.
//

import SwiftUI

// MARK: UI Model
public struct ContactDisplayModel: Identifiable, Hashable {
  public enum ContactType: String {
    case kakao = "KAKAO_TALK_ID"
    case openKakao = "OPEN_CHAT_URL"
    case instagram = "INSTAGRAM_ID"
    case phone = "PHONE_NUMBER"
    case unknown = "UNKNOWN"
    
    public var icon: Image {
      switch self {
      case .kakao:
        return DesignSystemAsset.Icons.kakao20.swiftUIImage
      case .openKakao:
        return DesignSystemAsset.Icons.kakaoOpenchat20.swiftUIImage
      case .instagram:
        return DesignSystemAsset.Icons.instagram20.swiftUIImage
      case .phone:
        return DesignSystemAsset.Icons.cell20.swiftUIImage
      case .unknown:
        return Image(systemName: "questionmark")
      }
    }
  }
  
  public let id: UUID
  public var type: ContactType
  public var value: String
  public var image: Image { type.icon }
  
  public init(id: UUID, type: ContactType, value: String) {
    self.id = id
    self.type = type
    self.value = value
  }
}

public struct PCContactField: View {
  // MARK: - Injected Properties
  @Binding private var contact: ContactDisplayModel
  private let action: () -> Void

  // MARK: - Initializer
  public init(
    contact: Binding<ContactDisplayModel>,
    action: @escaping () -> Void
  ) {
    self._contact = contact
    self.action = action
  }
  
  // MARK: Body
  public var body: some View {
    HStack(spacing: 12) {
      contactTypeButtonView
      contactField
    }
    .padding(.horizontal, Constant.horizontalPadding)
    .padding(.vertical, Constant.verticalPadding)
    .background(Color.grayscaleLight3)
    .cornerRadius(8)
  }

  private var contactTypeButtonView: some View {
    Button(action: action) {
      HStack(spacing: 4) {
        contact.image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, height: 24)
        
        DesignSystemAsset.Icons.chevronDown24.swiftUIImage
          .renderingMode(.template)
          .foregroundColor(Color.grayscaleDark3)
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }
  
  @ViewBuilder
  private var contactField: some View {
    switch contact.type {
    case .openKakao:
      TextField("", text: $contact.value, axis: .vertical)
        .font(DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 16))
        .foregroundStyle(Color.grayscaleBlack)
        .background(Color.grayscaleLight3)
        .lineLimit(1...)
        .frame(minHeight: 24, alignment: .top)

    default:
      TextField("", text: $contact.value)
        .font(DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 16))
        .foregroundStyle(Color.grayscaleBlack)
        .background(Color.grayscaleLight3)
        .frame(minHeight: 24, alignment: .top)
    }
  }
}

// MARK: Extenstion
extension PCContactField {
  private enum Constant {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 14
    static let lineHeight: CGFloat = 24.0
  }
}
