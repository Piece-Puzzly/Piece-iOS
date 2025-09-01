//
//  PCButtonSheet.swift
//  DesignSystem
//
//  Created by eunseou on 2/1/25.
//

import SwiftUI

public protocol BottomSheetItemRepresentable: Hashable, Identifiable {
  associatedtype Body: View
  @ViewBuilder func render() -> Body
  
  var id: UUID { get }
  var text: String { get }
  var state: BottomSheetItemState { get set }
}

public enum BottomSheetItemState {
  case selected
  case unselected
  case disable
  
  var foregroundColor: Color {
    switch self {
    case .selected:
      Color.primaryDefault
    case .unselected:
      Color.grayscaleBlack
    case .disable:
      Color.grayscaleDark3
    }
  }
}

public struct BottomSheetIconItem: BottomSheetItemRepresentable {
  public var id: UUID = UUID()
  public var text: String
  public var state: BottomSheetItemState = .unselected
  public var icon: String
  
  public func render() -> some View {
    HStack {
      DesignSystemImages(name: icon).swiftUIImage
        .renderingMode(.template)
        .foregroundStyle(state.foregroundColor)
      Text(text)
        .pretendard(.body_M_M)
        .foregroundStyle(state.foregroundColor)
      Spacer()
      if state != .unselected {
        DesignSystemAsset.Icons.check24.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(state.foregroundColor)
      }
    }
    .frame(maxWidth: .infinity)
  }
  
  public init(
    id: UUID = UUID(),
    text: String,
    state: BottomSheetItemState = .unselected,
    icon: String
  ) {
    self.id = id
    self.text = text
    self.state = state
    self.icon = icon
  }
}

extension BottomSheetIconItem {
  public static let defaultContactItems: [BottomSheetIconItem] = [
    .init(text: "카카오톡 아이디", icon: "kakao-32"),
    .init(text: "카카오톡 오픈 채팅방", icon: "kakao-openchat-32"),
    .init(text: "인스타 아이디", icon: "instagram-32"),
    .init(text: "전화번호", icon: "cell-fill-32")
  ]
}

public enum BottomSheetItemType {
    case normal(String)
    case custom(String)
}

public struct BottomSheetTextItem: BottomSheetItemRepresentable {
  @Binding public var value: String
  
  public var id: UUID
  public var type: BottomSheetItemType
  public var state: BottomSheetItemState = .unselected
  
  public var text: String {
    switch type {
    case .normal(let text), .custom(let text):
      return text
    }
  }
  
  public func render() -> some View {
    switch type {
    case .normal:
      label
      
    case .custom:
      VStack(alignment: .leading, spacing: 0) {
        Spacer()
          .frame(maxHeight: 19)
        
        label
        .frame(height: 24)
        
        Spacer()
          .frame(maxHeight: 19)
        
        if state == .selected {
          textField
          
          Spacer()
        }
      }
    }
  }
  
  private var label: some View {
    HStack {
      Text(text)
        .pretendard(.body_M_M)
        .foregroundStyle(state.foregroundColor)
      Spacer()
      if state == .selected {
        DesignSystemAsset.Icons.check24.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(state.foregroundColor)
      }
    }
  }
  private var textField: some View {
    TextField("자유롭게 작성해주세요", text: $value)
      .autocorrectionDisabled()
      .multilineTextAlignment(.leading)
      .textInputAutocapitalization(.none)
      .pretendard(.body_M_M)
      .frame(height: 52)
      .padding(.horizontal, 16)
      .background(.grayscaleLight3)
      .cornerRadius(8)
      .onAppear {
        UITextField.appearance().clearButtonMode = .whileEditing
      }
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
  
  public static func == (lhs: BottomSheetTextItem, rhs: BottomSheetTextItem) -> Bool {
      lhs.id == rhs.id
  }
  
  public init(
    id: UUID = UUID(),
    text: String,
    state: BottomSheetItemState = .unselected
  ) {
    self.id = id
    self.type = .normal(text)
    self.state = state
    self._value = .constant("")
  }

  public init(
    id: UUID = UUID(),
    text: String,
    state: BottomSheetItemState = .unselected,
    value: Binding<String>
  ) {
    self.id = id
    self.type = .custom(text)
    self.state = state
    self._value = value
  }
}

public struct PCBottomSheet<T: BottomSheetItemRepresentable>: View {
  typealias BottomSheetItem = T
  
  @Binding var isButtonEnabled: Bool
  @Binding var items: [T]
  
  private let titleText: String
  private let subtitleText: String?
  private let buttonText: String
  private let buttonAction: (() -> Void)?
  private let onTapRowItem: ((T) -> Void)?
  
  public init(
    isButtonEnabled: Binding<Bool> = .constant(false),
    items: Binding<[T]>,
    titleText: String,
    subtitleText: String? = nil,
    buttonText: String,
    buttonAction: (() -> Void)? = nil,
    onTapRowItem: ((T) -> Void)? = nil
  ) {
    self._isButtonEnabled = isButtonEnabled
    self._items = items
    self.titleText = titleText
    self.subtitleText = subtitleText
    self.buttonText = buttonText
    self.buttonAction = buttonAction
    self.onTapRowItem = onTapRowItem
  }

  public var body: some View {
    ScrollViewReader { proxy in
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          header
            .padding(.vertical, 8)
          
          Spacer()
            .frame(maxHeight: 12)
          
          content
          
          Spacer()
          
          button
            .padding(.bottom, 10)
            .id("bottomButton")
        }
        .padding(.top, 28)
        .padding(.horizontal, 20)
      }
      .scrollIndicators(.hidden)
      .scrollDisabled(true)
      .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
        Task {
          await MainActor.run {
            withAnimation(.easeInOut(duration: 0.3)) {
              proxy.scrollTo("bottomButton", anchor: .top)
            }
          }
        }
      }
    }
  }

  private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(titleText)
        .foregroundStyle(Color.grayscaleBlack)
        .pretendard(.heading_L_SB)
      
      if subtitleText != nil {
        Text(subtitleText ?? "")
          .foregroundStyle(Color.grayscaleDark2)
          .pretendard(.body_S_M)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
          .multilineTextAlignment(.leading)
      }
    }
  }
  
  @ViewBuilder
  private var content: some View {
    ScrollViewReader { proxy in
      if items.count > 6 {
        ScrollView {
          itemList(proxy: proxy)
        }
        .scrollIndicators(.hidden)
        .frame(height: 400)
      } else {
        ScrollView {
          itemList(proxy: proxy)
        }
        .scrollIndicators(.hidden)
      }
    }
  }
  
  private func itemList(proxy: ScrollViewProxy) -> some View {
    ForEach(items, id: \.id) { item in
      Button(action: {
        onTapRowItem?(item)
        withAnimation {
          proxy.scrollTo(item.id, anchor: .center)
        }
      }) {
        if item.text == "기타", item.state == .selected {
          item.render()
            .frame(height: 130)
        } else {
          item.render()
            .frame(height: 62)
        }
      }
    }
  }
  
  private var button: some View {
    RoundedButton(
      type: isButtonEnabled ? .solid : .disabled,
      buttonText: buttonText,
      width: .maxWidth,
      action: { buttonAction?() }
    )
  }
}

extension Array where Element: BottomSheetItemRepresentable {
    public mutating func selectItem(withId id: UUID) {
        for i in indices {
            self[i].state = (self[i].id == id) ? .selected : .unselected
        }
    }
}
