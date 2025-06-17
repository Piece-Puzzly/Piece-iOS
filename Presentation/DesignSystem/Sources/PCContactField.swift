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
        return DesignSystemAsset.Icons.kakao32.swiftUIImage
      case .openKakao:
        return DesignSystemAsset.Icons.kakaoOpenchat32.swiftUIImage
      case .instagram:
        return DesignSystemAsset.Icons.instagram32.swiftUIImage
      case .phone:
        return DesignSystemAsset.Icons.cellFill32.swiftUIImage
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
  
  // MARK: - Internal State
  @State private var contactFieldHeight: CGFloat = 24.0
  
  // MARK: - Computed Properties
  private var estimatedLineCount: Int {
    max(1, Int(contactFieldHeight / Constant.lineHeight))
  }
  
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
    HStack(spacing: 16) {
      contactTypeButtonView
      contactField
    }
    .padding(.horizontal, Constant.horizontalPadding)
    .padding(.vertical, Constant.verticalPadding)
    .background(Color.grayscaleLight3)
    .cornerRadius(8)
  }
  
  private var contactTypeButtonView: some View {
    VStack {
      Button(action: action) {
        HStack {
          contact.image
          DesignSystemAsset.Icons.chevronDown24.swiftUIImage
            .renderingMode(.template)
            .foregroundColor(Color.grayscaleDark3)
        }
      }

      if contact.type == .openKakao, estimatedLineCount >= 2 {
        Spacer()
      }
    }
  }
  
  @ViewBuilder
  private var contactField: some View {
    switch contact.type {
    case .openKakao:
      TextEditor(text: $contact.value)
        .font(DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 16))
        .foregroundStyle(Color.grayscaleBlack)
        .scrollContentBackground(.hidden)
        .background(Color.grayscaleLight3)
        .background(
          GeometryReader { geo in
            Color.clear
              .onChange(of: geo.size.height) { _, newValue in
                contactFieldHeight = newValue
              }
          }
        )
    default:
      TextField("", text: $contact.value)
        .pretendard(.body_M_M)
        .foregroundStyle(Color.grayscaleBlack)
        .background(Color.grayscaleLight3)
        .frame(height: 24)
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
