//
//  PCTextField.swift
//  Login
//
//  Created by eunseou on 1/11/25.
//

import SwiftUI
import PCFoundationExtension

public struct PCTextField<FocusField: Hashable>: View {
  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
      
      HStack(spacing: 8) {
        TextField("", text: $text)
          .focused(focusState, equals: focusField)
          .onChange(of: text) { _, newValue in
            text = newValue
            onChangeHandler?(newValue)
          }
          .foregroundStyle(textColor)
          .pretendard(.body_M_M)
          .padding(.vertical, 14)
          .padding(.leading, 16)
          .padding(.trailing, trailingPadding)
          .frame(minWidth: 202, maxWidth: 335)
          .frame(height: 52)
          .background(
            Rectangle()
              .foregroundStyle(backgroundColor)
              .cornerRadius(8)
              .overlay(placeholderText, alignment: .leading)
              .overlay(clearButton, alignment: .trailing)
              .overlay(rightTextView, alignment: .trailing)
              .overlay(rightImageRutton, alignment: .trailing)
          )
        
        if let button {
          button
            .frame(minWidth: 100, maxWidth: buttonWidth)
        }
      }
      
      HStack {
        if let infoText {
          Text(infoText)
            .foregroundStyle(infoTextColor ?? Color.grayscaleDark3)
        }
        
        Spacer()
        
        if let maxLength {
          Text("\(text.count)")
            .foregroundStyle(text.count > maxLength ? Color.systemError : Color.primaryDefault) +
          Text("/\(maxLength)")
        }
      }
      .pretendard(.body_S_M)
      .foregroundStyle(Color.grayscaleDark3)
    }
  }
  
  @ViewBuilder
  private var placeholderText: some View {
    if let placeholder, text.isEmpty, focusState.wrappedValue != focusField {
      Text(placeholder)
        .pretendard(.body_M_M)
        .foregroundStyle(Color.grayscaleDark3)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  @ViewBuilder
  private var clearButton: some View {
    if showClearButton && ( !text.isEmpty || focusState.wrappedValue == focusField) {
      Button {
        text = ""
      } label: {
        DesignSystemAsset.Icons.deletCircle20.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(Color.grayscaleLight1)
      }
      .padding(.trailing, 16)
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }
  
  @ViewBuilder
  private var rightTextView: some View {
    if let rightText {
      Text(rightText)
        .pretendard(.body_S_M)
        .foregroundStyle(rightTextColor ?? .grayscaleDark3)
        .padding(.trailing, 16)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }
  
  @ViewBuilder
  private var rightImageRutton: some View {
    if let rightImage {
      Button {
        tapRightImageButton?()
      } label: {
        rightImage
          .foregroundStyle(Color.grayscaleDark3)
          .padding(.trailing, 16)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }
  }
  
  private var trailingPadding: CGFloat {
    if rightImage != nil || rightText != nil || showClearButton {
      return 44
    }
    return 16
  }
  
  public init(
    title: String,
    text: Binding<String>,
    focusState: FocusState<FocusField>.Binding,
    focusField: FocusField,
    placeholder: String? = nil
  ) {
    self._text = text
    self.focusState = focusState
    self.focusField = focusField
    self.placeholder = placeholder
    self.title = title
  }
  
  @Binding private var text: String
  private var focusState: FocusState<FocusField>.Binding
  private let focusField: FocusField
  private let placeholder: String?
  private let title: String
  private var textColor: Color = .grayscaleBlack
  private var infoText: String?
  private var infoTextColor: Color?
  private var backgroundColor: Color = .grayscaleLight3
  private var button: RoundedButton?
  private var buttonWidth: CGFloat?
  private var maxLength: Int?
  private var showClearButton: Bool = false
  private var rightImage: Image?
  private var tapRightImageButton: (() -> Void)?
  private var rightText: String?
  private var rightTextColor: Color?
  private var timerText: String?
  private var onChangeHandler: ((String) -> Void)?
}

extension PCTextField {
  public func infoText(_ infoText: String, color: Color? = nil) -> PCTextField {
    var view = self
    view.infoText = infoText
    view.infoTextColor = color
    return view
  }
  
  public func backgroundColor(_ color: Color) -> PCTextField {
    var view = self
    view.backgroundColor = color
    return view
  }
  
  public func textColor(_ color: Color) -> PCTextField {
    var view = self
    view.textColor = color
    return view
  }
  
  public func textMaxLength(_ length: Int) -> PCTextField {
    var view = self
    view.maxLength = length
    return view
  }
  
  public func showClearButton(_ show: Bool) -> PCTextField {
    var view = self
    view.showClearButton = show
    return view
  }
  
  public func rightText(_ text: String, textColor: Color = .grayscaleDark3) -> PCTextField {
    var view = self
    view.rightText = text
    view.rightTextColor = textColor
    return view
  }
  
  public func rightImage(_ image: Image, action: (() -> Void)? = nil) -> PCTextField {
    var view = self
    view.rightImage = image
    view.tapRightImageButton = action
    return view
  }
  
  public func withButton(_ button: RoundedButton, width: CGFloat? = 100) -> PCTextField {
    var view = self
    view.button = button
    view.buttonWidth = width
    return view
  }
  
  public func onChange(_ handler: @escaping (String) -> Void) -> PCTextField {
    var view = self
    view.onChangeHandler = handler
    return view
  }
}

#Preview {
  struct PCTextFieldPreview: View {
    @State private var text1: String = ""
    @State private var text2: String = "입력"
    @State private var text3: String = "일이삼사오육칠팔구십일이삼사오육칠팔구 "
    @State private var text4: String = "입력입력입력ㅇ"
    @State private var text5: String = "0000"
    @State private var text6: String = "01012345678"
    @FocusState private var focusField: String?
    
    var body: some View {
      VStack(spacing: 10) {
        PCTextField(
          title: "기본 텍스트 필드",
          text: $text1,
          focusState: $focusField,
          focusField: "field1"
        )
        PCTextField(
          title: "인증번호",
          text: $text1,
          focusState: $focusField,
          focusField: "field2"
        )
        .infoText("어떤 경우에도 타인에게 공유하지 마세요")
        .rightText("05:00", textColor: .primaryDefault)
        .withButton(
          RoundedButton(
            type: .solid,
            buttonText: "확인",
            action: { }
          )
        )
        PCTextField(
          title: "작성항목",
          text: $text2,
          focusState: $focusField,
          focusField: "field3"
        )
        .disabled(true)
        PCTextField(
          title: "작성항목",
          text: $text3,
          focusState: $focusField,
          focusField: "field4",
          placeholder: "안내 문구"
        )
        .infoText("안내 문구")
        .showClearButton(true)
        .textMaxLength(20)
        PCTextField(
          title: "닉네임",
          text: $text4,
          focusState: $focusField,
          focusField: "field5",
          placeholder: "안내 문구"
        )
        .withButton(
          RoundedButton(
            type: .disabled,
            buttonText: "중복검사",
            action: { }
          )
        )
        .infoText("6자리 이하로 작성해주세요", color: .systemError)
        .showClearButton(true)
        .textMaxLength(6)
        PCTextField(
          title: "키",
          text: $text5,
          focusState: $focusField,
          focusField: "field6"
        )
        .rightText("CM")
        PCTextField(
          title: "닉네임",
          text: $text6,
          focusState: $focusField,
          focusField: "field7",
          placeholder: "휴대폰 번호"
        )
        .withButton(
          RoundedButton(
            type: .solid,
            buttonText: "인증번호 재전송",
            action: {}
          ),
          width: 125
        )
        .infoText("- 없이 숫자만 입력해주세요")
        .showClearButton(true)
      }
      .frame(width: 335)
    }
  }
  
  return PCTextFieldPreview()
}
