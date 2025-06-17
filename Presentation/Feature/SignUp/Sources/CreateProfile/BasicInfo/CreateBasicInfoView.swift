//
//  CreateBasicInfo.swift
//  SignUp
//
//  Created by eunseou on 1/30/25.
//

import SwiftUI
import DesignSystem
import _PhotosUI_SwiftUI
import Entities
import UseCases

struct CreateBasicInfoView: View {
  @State var viewModel: CreateBasicInfoViewModel
  @FocusState private var focusField: String?
  var didTapBottomButton: () -> Void
  
  init(
    profileCreator: ProfileCreator,
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase,
    didTapBottomButton: @escaping () -> Void
  ) {
    _viewModel = .init(
      wrappedValue: .init(
        profileCreator: profileCreator,
        checkNicknameUseCase: checkNicknameUseCase,
        uploadProfileImageUseCase: uploadProfileImageUseCase
      )
    )
    self.didTapBottomButton = didTapBottomButton
  }
  
  var body: some View {
    ZStack {
      VStack {
        ScrollViewReader { proxy in
          ScrollView {
            VStack(alignment: .center, spacing: 32) {
              title
              
              // 프로필 이미지
              VStack(spacing: 8) {
                Button {
                  viewModel.isProfileImageSheetPresented = true
                } label: {
                  profileImage
                }
                .actionSheet(isPresented: $viewModel.isProfileImageSheetPresented) {
                  ActionSheet(
                    title: Text("프로필 사진 선택"),
                    buttons: [
                      .default(Text("카메라")) { viewModel.handleAction(.selectCamera) },
                      .default(Text("앨범")) { viewModel.handleAction(.selectPhotoLibrary) },
                      .cancel(Text("취소"))
                    ]
                  )
                }
                .fullScreenCover(isPresented: $viewModel.isCameraPresented) {
                  CameraPicker {
                    viewModel.setImageFromCamera($0)
                  }
                }
                .photosPicker(
                  isPresented: $viewModel.isPhotoSheetPresented,
                  selection: Binding(
                    get: { viewModel.selectedItem },
                    set: {
                      viewModel.selectedItem = $0
                      Task { await viewModel.loadImage() }
                    }
                  ),
                  matching: .images
                )
                
                profileImageDescriptionLabel
              }
              // 닉네임
              nicknameTextField.id("nickname_scroll")
              
              // 나를 표현하는 한 마디
              descriptionTextField.id("description_scroll")
              
              // 생년월일
              birthdateTextField.id("birthDate_scroll")
              
              // 활동지역
              locationTextField.id("location_scroll")
              
              //키
              heightTextField.id("height_scroll")
              
              // 몸무게
              weightTextField.id("weight_scroll")
              
              // 직업
              jobTextField.id("job_scroll")
              
              // 흡연
              smokingTextField
              
              // SNS
              snsTextField
              
              // 연락처
              contactsTextField
              
              Button {
                focusField = nil
                viewModel.handleAction(.tapAddContact)
              } label: {
                HStack(spacing: 4) {
                  Text("연락처 추가하기")
                    .pretendard(.body_M_M)
                  DesignSystemAsset.Icons.plusLine20.swiftUIImage
                    .renderingMode(.template)
                }
                .foregroundStyle(Color.primaryDefault)
              }
              .opacity(viewModel.canAddMoreContact ? 1 : 0)
              .disabled(!viewModel.canAddMoreContact)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 200)
            .background(
              Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                  focusField = nil
                }
            )
          }
          .scrollIndicators(.hidden)
          .onChange(of: focusField) { _, newValue in
            withAnimation {
              if let field = newValue {
                proxy.scrollTo("\(field)_scroll", anchor: .center)
              }
            }
          }
        }
        
        nextButton
          .padding(.horizontal, 20)
          .padding(.bottom, 10)
      }
      .ignoresSafeArea(.keyboard)
      
      VStack {
        Spacer()
        if viewModel.showToast {
          toast
            .padding(.bottom, 84)
            .opacity(viewModel.showToast ? 1 : 0)
            .animation(.easeInOut(duration: 0.5), value: viewModel.showToast)
        }
      }
    }
    .sheet(isPresented: $viewModel.isLocationSheetPresented) {
      PCBottomSheet<BottomSheetTextItem>(
        isButtonEnabled: Binding(projectedValue: .constant(viewModel.isLocationBottomSheetButtonEnable)),
        items: $viewModel.locationItems,
        titleText: "활동 지역",
        subtitleText: "주로 활동하는 지역을 선택해주세요.",
        buttonText: "적용하기",
        buttonAction: { viewModel.handleAction(.saveLocation) },
        onTapRowItem: { viewModel.tapLocationRowItem($0) }
      )
      .presentationDetents([.height(602)])
    }
    .sheet(isPresented: $viewModel.isJobSheetPresented) {
      PCBottomSheet<BottomSheetTextItem>(
        isButtonEnabled: Binding(projectedValue: .constant(viewModel.isJobBottomSheetButtonEnable)),
        items: $viewModel.jobItems,
        titleText: "직업",
        buttonText: "적용하기",
        buttonAction: { viewModel.handleAction(.saveJob) },
        onTapRowItem: { viewModel.tapJobRowItem($0) }
      )
      .presentationDetents([.height(562)])
    }
    .sheet(isPresented: $viewModel.isContactSheetPresented) {
      PCBottomSheet<BottomSheetIconItem>(
        isButtonEnabled: Binding(projectedValue: .constant(viewModel.isContactBottomSheetButtonEnable)),
        items: $viewModel.contactBottomSheetItems,
        titleText: "연락처",
        subtitleText: "연락을 주고받고 싶은 연락처를 선택해 작성해주세요.\n1개 이상 필수로 작성해야 합니다.",
        buttonText: "적용하기",
        buttonAction: { viewModel.handleAction(.saveContact) },
        onTapRowItem: { viewModel.tapContactRowItem($0) }
      )
      .presentationDetents([.height(479)])
    }
    .sheet(isPresented: $viewModel.isContactTypeChangeSheetPresented) {
      PCBottomSheet<BottomSheetIconItem>(
        isButtonEnabled: Binding(projectedValue: .constant(viewModel.isContactBottomSheetButtonEnable)),
        items: $viewModel.contactBottomSheetItems,
        titleText: "연락처",
        subtitleText: "연락을 주고받고 싶은 연락처를 선택해 작성해주세요.\n1개 이상 필수로 작성해야 합니다.",
        buttonText: "적용하기",
        buttonAction: { viewModel.handleAction(.editContact) },
        onTapRowItem: { viewModel.tapContactRowItem($0) }
      )
      .presentationDetents([.height(479)])
    }
  }
  
  private var title: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("간단한 정보로\n당신을 표현하세요")
        .pretendard(.heading_L_SB)
        .foregroundStyle(Color.grayscaleBlack)
      Text("작성 후에도 언제든 수정 가능하니,\n편안하게 작성해 주세요.")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.bottom, 8)
    .padding(.top, 20)
  }
  
  private var profileImage: some View {
    Group {
      if let image = viewModel.profileImage {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(width: 120, height: 120)
          .clipShape(RoundedRectangle(cornerRadius: 20))
      } else {
        DesignSystemAsset.Images.profileImageNodata.swiftUIImage
      }
    }
    .overlay(alignment: .bottomTrailing) {
      profileEditButton(
        viewModel.profileImage != nil
        ? DesignSystemAsset.Icons.pencilFill24.swiftUIImage
        : DesignSystemAsset.Icons.plus24.swiftUIImage
      )
    }
  }
  
  private func profileEditButton(_ image: Image) -> some View {
    image
      .renderingMode(.template)
      .foregroundStyle(Color.grayscaleWhite)
      .background(
        Circle()
          .frame(width: 36, height: 36)
          .foregroundStyle(Color.primaryDefault)
          .overlay(
            Circle()
              .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
          )
      )
      .padding(.bottom, 10)
      .padding(.trailing, 10)
  }
  
  private var profileImageDescriptionLabel: some View {
    Text("얼굴이 잘 나온 사진으로 등록해 주세요.")
      .pretendard(.body_S_M)
      .foregroundStyle(Color.grayscaleDark3)
  }
  
  private var nicknameTextField: some View {
    PCTextField(
      title: "닉네임",
      text: $viewModel.nickname,
      focusState: $focusField,
      focusField: "nickname",
      placeholder: "6자 이하로 작성해 주세요"
    )
    .withButton(
      RoundedButton(
        type: viewModel.nicknameState.isEnableNickNameCheckButton ? .solid : .disabled,
        buttonText: "중복검사",
        width: .maxWidth,
        action: { viewModel.handleAction(.tapVaildNickName) }
      )
    )
    .infoText(
      viewModel.nicknameState.infoText,
      color: viewModel.nicknameState.infoTextColor
    )
    .textMaxLength(6)
    .onSubmit {
      focusField = "description"
    }
    .onChange(of: viewModel.nickname) { _, newValue in
      viewModel.handleAction(.updateNickname(value: newValue))
    }
  }
  
  private var descriptionTextField: some View {
    PCTextField(
      title: "나를 표현하는 한 마디",
      text: $viewModel.description,
      focusState: $focusField,
      focusField: "description",
      placeholder: "수식어 형태로 작성해 주세요"
    )
    .infoText(
      viewModel.descriptionInfoText,
      color: .systemError
    )
    .textMaxLength(20)
    .onSubmit {
      focusField = "birthDate"
    }
  }
  
  private var birthdateTextField: some View {
    PCTextField(
      title: "생년월일",
      text: $viewModel.birthDate,
      focusState: $focusField,
      focusField: "birthDate",
      placeholder: "8자리(YYYYMMDD) 형식으로 입력해 주세요"
    )
    .infoText(
      viewModel.birthDateInfoText,
      color: .systemError
    )
    .onChange { newValue in
      viewModel.birthDate = String(newValue.filter { $0.isNumber }.prefix(8))
    }
    .textContentType(.birthdate)
    .keyboardType(.numberPad)
  }
  
  private var locationTextField: some View {
    PCTextField(
      title: "활동지역",
      text: $viewModel.location,
      focusState: $focusField,
      focusField: "location"
    )
    .rightImage(DesignSystemAsset.Icons.chevronDown24.swiftUIImage)
    .infoText( viewModel.locationInfoText,
               color: .systemError
    )
    .disabled(true)
    .onTapGesture {
      focusField = nil
      viewModel.handleAction(.tapLocation)
    }
  }
  
  private var heightTextField: some View {
    PCTextField(
      title: "키",
      text: $viewModel.height,
      focusState: $focusField,
      focusField: "height"
    )
    .rightText("cm")
    .infoText(viewModel.heightInfoText,
              color: .systemError
    )
    .onChange { newValue in
      viewModel.height = newValue.filter { $0.isNumber }
    }
    .keyboardType(.numberPad)
  }
  
  private var weightTextField: some View {
    PCTextField(
      title: "몸무게",
      text: $viewModel.weight,
      focusState: $focusField,
      focusField: "weight"
    )
    .rightText("kg")
    .infoText( viewModel.weightInfoText,
               color: .systemError
    )
    .onChange { newValue in
      viewModel.weight = newValue.filter { $0.isNumber }
    }
    .keyboardType(.numberPad)
  }
  
  private var jobTextField: some View {
    PCTextField(
      title: "직업",
      text: $viewModel.job,
      focusState: $focusField,
      focusField: "job"
    )
    .rightImage(DesignSystemAsset.Icons.chevronDown24.swiftUIImage)
    .infoText(
      viewModel.jobInfoText,
      color: .systemError
    )
    .disabled(true)
    .onTapGesture {
      focusField = nil
      viewModel.handleAction(.tapJob)
    }
  }
  
  private var smokingTextField: some View {
    VStack(alignment: .leading) {
      Text("흡연")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
      HStack {
        SelectCard(isEditing: true, isSelected: viewModel.smokingStatus == "흡연", text: "흡연") {
          viewModel.smokingStatus = "흡연"
          focusField = nil
        }
        SelectCard(isEditing: true, isSelected: viewModel.smokingStatus == "비흡연", text: "비흡연") {
          viewModel.smokingStatus = "비흡연"
          focusField = nil
        }
      }
      Text( viewModel.smokingInfoText)
        .pretendard(.body_S_M)
        .foregroundStyle(Color.systemError)
    }
  }
  
  private var snsTextField: some View {
    VStack(alignment: .leading) {
      Text("SNS")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
      HStack {
        SelectCard(
          isEditing: true,
          isSelected: viewModel.snsActivityLevel == "활동",
          text: "활동"
        ) {
          viewModel.snsActivityLevel = "활동"
        }
        SelectCard(
          isEditing: true,
          isSelected: viewModel.snsActivityLevel == "은둔",
          text: "은둔"
        ){
          viewModel.snsActivityLevel = "은둔"
        }
      }
      Text(viewModel.snsInfoText)
        .pretendard(.body_S_M)
        .foregroundStyle(Color.systemError)
    }
  }
  
  private var contactsTextField: some View {
    VStack(alignment: .leading) {
      Text("연락처")
        .pretendard(.body_S_M)
        .foregroundStyle(Color.grayscaleDark3)
      
      CreateContactContainer(viewModel: viewModel, focusField: $focusField)
    }
  }
  
  private var nextButton: some View {
    RoundedButton(
      type: .solid,
      buttonText: "다음",
      width: .maxWidth,
      action: {
        viewModel.handleAction(.tapNextButton)
        if viewModel.isNextButtonEnabled {
          didTapBottomButton()
        }
      }
    )
  }
  
  private var toast: some View {
    HStack {
      DesignSystemAsset.Icons.notice20.swiftUIImage
        .renderingMode(.template)
      Text("모든 항목을 작성해 주세요")
        .pretendard(.body_S_M)
    }
    .foregroundStyle(Color.grayscaleWhite)
    .padding(.vertical, 8)
    .padding(.horizontal, 20)
    .background(
      Rectangle()
        .foregroundStyle(Color.grayscaleDark2)
        .cornerRadius(12)
    )
  }
}

fileprivate struct CreateContactContainer: View {
  @Bindable var viewModel: CreateBasicInfoViewModel
  private var focusField: FocusState<String?>.Binding
  
  fileprivate init(
    viewModel: CreateBasicInfoViewModel,
    focusField: FocusState<String?>.Binding
  ) {
    self._viewModel = Bindable(wrappedValue: viewModel)
    self.focusField = focusField
  }
  
  fileprivate var body: some View {
    ScrollViewReader { proxy in
      VStack {
        contactFields
      }
      .onChange(of: focusField.wrappedValue) { _, newValue in
        withAnimation {
          if let field = newValue {
            proxy.scrollTo("\(field)_scroll", anchor: .center)
          }
        }
      }
      .onChange(of: viewModel.contacts) { oldValue, newValue in
        handleContactsChange(oldValue: oldValue, newValue: newValue)
      }
    }
  }
  
  private var contactFields: some View {
    ForEach(viewModel.contacts, id: \.id) { contact in
      HStack(spacing: 16) {
        PCContactField(
          contact: bindingForContact(id: contact.id),
          action: {
            viewModel.handleAction(.tapChangeContact(contact))
          }
        )
        .focused(focusField, equals: "contact_\(contact.id)")
        .id("contact_\(contact.id)_scroll")
        
        if viewModel.canDeleteContactField(contact: contact) {
          DeleteButton {
            viewModel.removeContact(for: contact)
          }
        }
      }
    }
  }
  
  private func bindingForContact(id: UUID) -> Binding<ContactDisplayModel> {
    Binding<ContactDisplayModel>(
      get: {
        guard let contact = viewModel.contacts.first(where: { $0.id == id }) else {
          return ContactDisplayModel(id: id, type: .unknown, value: "")
        }
        return ContactDisplayModel(
          id: contact.id,
          type: ContactDisplayModel.ContactType(rawValue: contact.type.rawValue) ?? .unknown,
          value: contact.value
        )
      },
      set: { newContact in
        guard let index = viewModel.contacts.firstIndex(where: { $0.id == id }) else { return }
        if viewModel.isAllowedInput(newContact.value) {
          viewModel.contacts[index].value = newContact.value
          viewModel.contacts[index].type = ContactModel.ContactType(rawValue: newContact.type.rawValue) ?? .unknown
        }
      }
    )
  }
  
  private func handleContactsChange(oldValue: [ContactModel], newValue: [ContactModel]) {
    let oldIds = Set(oldValue.map { $0.id })
    let newIds = Set(newValue.map { $0.id })

    if let addedId = newIds.subtracting(oldIds).first {
      self.focusField.wrappedValue = "contact_\(addedId)"
      return
    }

    for (old, new) in zip(oldValue, newValue) {
      if old.id == new.id && old != new {
        self.focusField.wrappedValue = "contact_\(new.id)"
        return
      }
    }
  }
}

fileprivate struct DeleteButton: View {
  private let action: (() -> Void)?
  
  fileprivate init(action: (() -> Void)?) {
    self.action = action
  }
  
  fileprivate var body: some View {
    Button(
      action: { action?() },
      label: {
        DesignSystemAsset.Icons.deletCircle20.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(Color.grayscaleLight1)
      }
    )
  }
}

//#Preview {
//  CreateBasicInfoView()
//}
