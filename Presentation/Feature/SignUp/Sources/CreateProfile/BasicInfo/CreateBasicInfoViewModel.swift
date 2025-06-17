//
//  CreateBasicInfoViewModel.swift
//  SignUp
//
//  Created by eunseou on 2/1/25.
//

import SwiftUI
import Observation
import UseCases
import DesignSystem
import _PhotosUI_SwiftUI
import Entities
import PCFoundationExtension

@Observable
final class CreateBasicInfoViewModel {
  enum Action {
    case tapNextButton
    case tapVaildNickName
    case selectCamera
    case selectPhotoLibrary
    case tapLocation
    case tapJob
    case tapAddContact
    case tapChangeContact(ContactModel)
    case saveLocation
    case saveJob
    case saveContact
    case editContact
    case updateNickname(value: String)
  }
  
  init(
    profileCreator: ProfileCreator,
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase
  ) {
    self.profileCreator = profileCreator
    self.checkNicknameUseCase = checkNicknameUseCase
    self.uploadProfileImageUseCase = uploadProfileImageUseCase
    self.jobItems = Jobs.all.map { BottomSheetTextItem(text: $0) }
    
    setupJobItemsWithEtc()
  }
  
  private let checkNicknameUseCase: CheckNicknameUseCase
  private let uploadProfileImageUseCase: UploadProfileImageUseCase
  let profileCreator: ProfileCreator
  var nicknameState: NicknameState = .empty
  
  // TextField Bind
  var profileImage: UIImage? = nil
  var nickname: String = ""
  var description: String = ""
  var birthDate: String = ""
  var location: String = ""
  var height: String = ""
  var weight: String = ""
  var job: String = ""
  var etcText: String = ""
  var contacts: [ContactModel] = [ContactModel(type: .kakao, value: "")]
  
  // isValid
  var isValidProfileImage: Bool = false
  var isDescriptionValid: Bool {
    !description.isEmpty && description.count <= 20
  }
  var isValidBirthDate: Bool { isValidBirthDateFormat(birthDate) }
  var isValidHeight: Bool {
    (2...3).contains(height.count) && height.allSatisfy(\.isNumber)
  }
  var isVaildWeight: Bool {
    (2...3).contains(weight.count) && weight.allSatisfy(\.isNumber)
  }
  var isContactsValid: Bool {
    return contacts.allSatisfy { !$0.value.isEmpty }
  }
  var isNextButtonEnabled: Bool {
    return isValidProfileImage &&
    nicknameState.isEnableNextButton &&
    isDescriptionValid &&
    isValidBirthDate &&
    !location.isEmpty &&
    isValidHeight &&
    isVaildWeight &&
    !job.isEmpty &&
    isContactsValid
  }
  var descriptionInfoText: String {
    if description.isEmpty && didTapnextButton {
      return "필수 항목을 입력해 주세요."
    } else if description.count > 20 {
      return "20자 이하로 작성해 주세요."
    } else {
      return ""
    }
  }
  var birthDateInfoText: String {
    if birthDate.isEmpty && didTapnextButton {
      return "필수 항목을 입력해 주세요."
    } else if !birthDate.isEmpty && !isValidBirthDateFormat(birthDate) {
      return "생년월일은 YYYYMMDD 형식으로 입력해 주세요."
    } else {
      return ""
    }
  }
  var locationInfoText: String {
    if location.isEmpty && didTapnextButton {
      return "필수 항목을 입력해 주세요."
    } else {
      return ""
    }
  }
  var heightInfoText: String {
    if height.isEmpty && didTapnextButton {
      return "필수 항목을 입력해 주세요."
    } else if !height.isEmpty && !((2...3).contains(height.count) && height.allSatisfy(\.isNumber)) {
      return "숫자가 정확한 지 확인해 주세요."
    } else {
      return ""
    }
  }
  var weightInfoText: String {
    if weight.isEmpty && didTapnextButton {
      return "필수 항목을 입력해 주세요."
    } else if !weight.isEmpty && !((2...3).contains(weight.count) && weight.allSatisfy(\.isNumber)) {
      return "숫자가 정확한 지 확인해 주세요."
    } else {
      return ""
    }
  }
  var jobInfoText: String {
    if job.isEmpty && didTapnextButton {
      return "필수 항목을 입력해 주세요."
    } else {
      return ""
    }
  }
  var smokingInfoText: String {
    if smokingStatus.isEmpty && didTapnextButton {
      return "필수 항목을 입력해 주세요."
    } else {
      return ""
    }
  }
  var snsInfoText: String {
    if snsActivityLevel.isEmpty && didTapnextButton {
      return "필수 항목을 입력해 주세요."
    } else {
      return ""
    }
  }
  
  // temp
  var smokingStatus: String = ""
  var snsActivityLevel: String = ""
  var selectedSNSContactType: ContactModel.ContactType? = nil
  var prevSelectedContact: ContactModel? = nil
  var isContactTypeChangeSheetPresented: Bool = false
  var selectedItem: PhotosPickerItem? = nil
  var didCheckDuplicates: Bool = false
  var didTapnextButton: Bool = false
  
  var locationItems: [BottomSheetTextItem] = Locations.all.map { BottomSheetTextItem(text: $0) }
  var jobItems: [BottomSheetTextItem]
  var contactBottomSheetItems: [BottomSheetIconItem] = BottomSheetIconItem.defaultContactItems
  
  // Sheet
  var isPhotoSheetPresented: Bool = false
  var isCameraPresented: Bool  = false
  var isJobSheetPresented: Bool = false
  var isLocationSheetPresented: Bool = false
  var canAddMoreContact: Bool {
    contacts.count < Constant.contactModelCount
  }
  var isContactSheetPresented: Bool = false
  var isProfileImageSheetPresented: Bool = false
  var showToast: Bool = false
  
  func handleAction(_ action: Action) {
    switch action {
    case .tapNextButton:
      Task {
        await handleTapNextButton()
      }
    case .selectCamera:
      isCameraPresented = true
    case .selectPhotoLibrary:
      isPhotoSheetPresented = true
    case .tapVaildNickName:
      Task {
        await handleTapVaildNicknameButton()
      }
    case .tapLocation:
      isLocationSheetPresented = true
      updateLocationBottomSheetItems()
    case .tapJob:
      isJobSheetPresented = true
      initializeEtcTextFromJob()
      updateJobBottomSheetItems()
    case .tapAddContact:
      isContactSheetPresented = true
      updateContactBottomSheetItems()
    case .tapChangeContact(let prevContact):
      isContactTypeChangeSheetPresented = true
      updateContactBottomSheetItems()
      changeContactBottomSheetItem(with: prevContact)
      prevSelectedContact = prevContact
    case .saveLocation:
      tapLocationBottomSheetSaveButton()
    case .saveJob:
      tapJobBottomSheetSaveButton()
    case .saveContact:
      tapContactBottomSheetSaveButton()
    case .editContact:
      tapContactBottomSheetEditButton()
    case .updateNickname(let value):
      handleUpdateNickname(value)
    }
  }
  
  private func handleTapNextButton() async {
    switch nicknameState {
    case .empty:
      updateEditingNicknameState(to: .emptyError)
    case .editing:
      updateEditingNicknameState(to: .unchecked)
    default:
      break
    }
    
    if profileImage == nil || !nicknameState.isEnableNextButton || !isDescriptionValid || birthDate.isEmpty || location.isEmpty || height.isEmpty || weight.isEmpty || job.isEmpty || !isContactsValid {
      didTapnextButton = true
      profileCreator.isBasicInfoValid(false)
      await isToastVisible()
    } else if isNextButtonEnabled {
      do {
        guard let profileImage = profileImage else { return }
        guard let imageData = profileImage.resizedAndCompressedData(targetSize: CGSize(width: 400, height: 400), compressionQuality: 0.5) else {
          print("이미지 데이터 변환 실패")
          return
        }
        
        let imageURL = try await uploadProfileImageUseCase.execute(image: imageData)
        print("이미지 업로드 성공: \(imageURL)")
        
        let basicInfo = ProfileBasicModel(
          nickname: nickname,
          description: description,
          birthdate: birthDate,
          height: Int(height) ?? 0,
          weight: Int(weight) ?? 0,
          job: job,
          location: location,
          smokingStatus: smokingStatus,
          snsActivityLevel: snsActivityLevel,
          imageUri: imageURL.absoluteString,
          pendingImageUrl: nil,
          contacts: contacts
        )
        
        profileCreator.updateBasicInfo(basicInfo)
        profileCreator.isBasicInfoValid(true)
        print("ProfileCreator에 기본 정보 주입 완료")
      } catch {
        profileCreator.isBasicInfoValid(false)
        print(error.localizedDescription)
      }
    }
  }
  
  private func handleTapVaildNicknameButton() async {
    let isValidNickname = (try? await checkNicknameUseCase.execute(nickname: nickname)) ?? false
    let nickNameState: NicknameState = isValidNickname ? .success : .duplicated
    updateEditingNicknameState(to: nickNameState)
  }
  
  @MainActor
  private func isToastVisible() async {
    showToast = true
    try? await Task.sleep(for: .seconds(3))
    showToast = false
  }
  
  private func isValidBirthDateFormat(_ date: String) -> Bool {
    let dateRegex = #"^(19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$"# // YYYYMMDD
    let dateTest = NSPredicate(format: "SELF MATCHES %@", dateRegex)
    return dateTest.evaluate(with: date) && date.count == 8
  }
  
  func isAllowedInput(_ input: String) -> Bool {
      let pattern = #"^[A-Za-z0-9\s[:punct:][:symbol:]]*$"#
      guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
      let range = NSRange(location: 0, length: input.utf16.count)
      return regex.firstMatch(in: input, options: [], range: range) != nil
  }
  
  func loadImage() async {
    guard let selectedItem else {
      print("선택된 아이템이 없습니다.")
      return
    }
    
    do {
      if let data = try await selectedItem.loadTransferable(type: Data.self),
         let image = UIImage(data: data) {
        self.profileImage = image  // UIImage로 저장
        self.isValidProfileImage = true
      } else {
        print("이미지 데이터를 로드할 수 없습니다.")
      }
    } catch {
      print("이미지 로드 중 오류 발생: \(error.localizedDescription)")
    }
  }
  
  func setImageFromCamera(_ image: UIImage) {
    self.profileImage = image
    self.isValidProfileImage = true
  }
  
  private func handleUpdateNickname(_ newValue: String) {
    nickname = newValue.replacingOccurrences(of: " ", with: "")
    updateEditingNicknameState()
  }
  
  private func updateEditingNicknameState(to state: NicknameState? = nil) {
    if let state {
      nicknameState = state
      return
    }
    
    nicknameState = determineNicknameState(nickname: nickname)
  }
  
  private func determineNicknameState(nickname: String) -> NicknameState {
    guard !nickname.isEmpty else { return .empty }
    guard nickname.count <= 6 else { return .overLength }
    
    return .editing
  }
}

// MARK: - Location
extension CreateBasicInfoViewModel {
  var isLocationBottomSheetButtonEnable: Bool {
    locationItems.contains(where: { $0.state == .selected })
  }
  
  func updateLocationBottomSheetItems() {
    for index in locationItems.indices {
      locationItems[index].state = .unselected
    }
    
    if let index = locationItems.firstIndex(where: { $0.text == location }) {
      locationItems[index].state = .selected
    }
  }
  
  func tapLocationRowItem(_ item: any BottomSheetItemRepresentable) {
    if let index = locationItems.firstIndex(where: { $0.id == item.id }),
       item.state == .unselected {
      locationItems.enumerated().forEach { (i, item) in
        if locationItems[i].state == .unselected, i == index {
          locationItems[i].state = .selected
        } else if locationItems[i].state == .selected {
          locationItems[i].state = .unselected
        }
      }
    }
  }
  
  func tapLocationBottomSheetSaveButton() {
    if let selectedItem = locationItems.first(where: { $0.state == .selected }) {
      location = selectedItem.text
    }
    
    isLocationSheetPresented = false
  }
}

// MARK: - Job
extension CreateBasicInfoViewModel {
  /// "etcText"는 저장된 "job"에 종속됨
  private func initializeEtcTextFromJob() {
    if !job.isEmpty && !(jobItems.contains { item in
      switch item.type {
      case .normal:
        return item.text == job
      case .custom:
        return false
      }
    }) {
      etcText = job
    }
  }
  
  func setupJobItemsWithEtc() {
    let etcItem = BottomSheetTextItem(
      text: "기타",
      value: Binding(
      get: { self.etcText },
      set: { self.etcText = $0.replacingOccurrences(of: " ", with: "") })
    )
    
    if let index = jobItems.firstIndex(where: { $0.text == "기타" }) {
      jobItems[index] = etcItem
    }
  }
  
  var isJobBottomSheetButtonEnable: Bool {
    jobItems.contains { item in
      switch item.type {
      case .normal:
        return item.state == .selected
      case .custom:
        return !etcText.isEmpty && item.state == .selected
      }
    }
  }
  
  func updateJobBottomSheetItems() {
    for index in jobItems.indices {
      jobItems[index].state = .unselected
    }
    
    if let index = jobItems.firstIndex(where: { item in
      switch item.type {
      case .normal:
        item.text == job
      case .custom:
        !item.value.isEmpty && item.value == job
      }
    }) {
      jobItems[index].state = .selected
    }
  }
  
  func tapJobRowItem(_ item: any BottomSheetItemRepresentable) {
    if let index = jobItems.firstIndex(where: { $0.id == item.id }),
       item.state == .unselected {
      jobItems.enumerated().forEach { (i, item) in
        if jobItems[i].state == .unselected, i == index {
          jobItems[i].state = .selected
        } else if jobItems[i].state == .selected {
          jobItems[i].state = .unselected
        }
      }
    }
  }
  
  func tapJobBottomSheetSaveButton() {
    if let selectedItem = jobItems.first(where: { $0.state == .selected }) {
      switch selectedItem.type {
      case .normal(let text):
        job = text
      case .custom:
        job = selectedItem.value
      }
    }
    
    isJobSheetPresented = false
  }
}

// MARK: - Contact
extension CreateBasicInfoViewModel {
  var isContactBottomSheetButtonEnable: Bool {
    contactBottomSheetItems.contains(where: { $0.state == .selected })
  }
  
  func canDeleteContactField(contact: ContactModel) -> Bool {
    guard let index = contacts.firstIndex(where: { $0.id == contact.id }) else {
      return false
    }
    return index > 0
  }
  
  func removeContact(for contact: ContactModel) {
    if let index = contacts.firstIndex(where: { $0.id == contact.id }),
       index > 0 {
      contacts.remove(at: index)
    }
  }
  
  func changeContactBottomSheetItem(with targetContact: ContactModel) {
    if let contactIndex = contacts.firstIndex(where: { $0.id == targetContact.id }) {
      let targetIcon = contacts[contactIndex].type.icon
      if let itemIndex = contactBottomSheetItems.firstIndex(where: { $0.icon == targetIcon }) {
        contactBottomSheetItems[itemIndex].state = .selected
      }
    }
  }
  
  func updateContactBottomSheetItems() {
    contactBottomSheetItems = BottomSheetIconItem.defaultContactItems.map { item in
      var copy = item
      let type = ContactModel.ContactType.from(iconName: item.icon)
      
      if contacts.contains(where: { $0.type == type }) {
        copy.state = .disable
      } else {
        copy.state = .unselected
      }
      
      return copy
    }
  }
  
  func tapContactRowItem(_ item: any BottomSheetItemRepresentable) {
    if let index = contactBottomSheetItems.firstIndex(where: { $0.id == item.id }),
       item.state == .unselected {
      contactBottomSheetItems.enumerated().forEach { (i, item) in
        if contactBottomSheetItems[i].state == .unselected, i == index {
          contactBottomSheetItems[i].state = .selected
        } else if contactBottomSheetItems[i].state == .selected {
          contactBottomSheetItems[i].state = .unselected
        }
      }
    }
  }
  
  func tapContactBottomSheetEditButton() {
    if let prevSelectedContact,
       let selectedItem = contactBottomSheetItems.first(where: { $0.state == .selected }) {
      let newType = ContactModel.ContactType.from(iconName: selectedItem.icon)
      
      if newType != .unknown,
         let targetIndex = contacts.firstIndex(where: { $0.id == prevSelectedContact.id }) {
        let changedContact = ContactModel(type: newType, value: prevSelectedContact.value)
        contacts[targetIndex] = changedContact
      }
    }
    
    prevSelectedContact = nil
    isContactTypeChangeSheetPresented = false
  }
  
  func tapContactBottomSheetSaveButton() {
    if let selectedItem = contactBottomSheetItems.first(where: { $0.state == .selected }) {
      let newType = ContactModel.ContactType.from(iconName: selectedItem.icon)
      
      if newType != .unknown {
        let newContact = ContactModel(type: newType, value: "")
        contacts.append(newContact)
      }
    }
    
    isContactSheetPresented = false
  }
}

// MARK: Constant
extension CreateBasicInfoViewModel {
  private enum Constant {
    static let contactModelCount: Int = 4
  }
  
  enum NicknameState {
    case empty // 비어있을 때, 텍스트 입력 시 지정 가능
    case emptyError // 비어있을 때 다음버튼 눌렀을 때
    case editing // 수정중이며 중복검사 안했을 때, 텍스트 입력 시 지정 가능
    case overLength // 6글자 초과, 텍스트 입력 시 지정 가능
    case duplicated // 중복된 상태, 중복버튼 누를 때 지정 가능
    case success // 가능한 닉네임, 중복버튼 누를 떄 지정 가능
    case unchecked // 수정은 했지만 중복검사 안함, 다음버튼 누를 시 editing -> unchecked로 넘어감
    
    var infoText: String {
      switch self {
      case .empty, .editing:
        return ""
      case .emptyError:
        return "필수 항목을 입력해 주세요."
      case .duplicated:
        return "이미 사용 중인 닉네임입니다."
      case .success:
        return "사용할 수 있는 닉네임입니다."
      case .overLength:
        return "6자 이하로 작성해주세요."
      case .unchecked:
        return "닉네임 중복 검사를 진행해 주세요."
      }
    }
    
    var infoTextColor: Color {
      switch self {
      case .editing, .empty:
        return Color.clear
      case .emptyError, .duplicated, .overLength, .unchecked:
        return Color.systemError
      case .success:
        return Color.primaryDefault
      }
    }
    
    var isEnableNickNameCheckButton: Bool {
      switch self {
      case .editing, .unchecked, .duplicated:
        return true
      case .empty, .emptyError, .success, .overLength:
        return false
      }
    }
    
    var isEnableNextButton: Bool {
      switch self {
      case .success:
        return true
      case .empty, .emptyError, .editing, .duplicated, .overLength, .unchecked:
        return false
      }
    }
  }
}
