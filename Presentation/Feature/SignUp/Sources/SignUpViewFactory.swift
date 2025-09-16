//
//  SignUpViewFactory.swift
//  SignUp
//
//  Created by eunseou on 2/5/25.
//

import Entities
import SwiftUI
import UseCases
import PCAmplitude

public struct SignUpViewFactory {
  public static func createAvoidContactsGuideView(
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase,
    fetchContactsUseCase: FetchContactsUseCase,
    blockContactsUseCase: BlockContactsUseCase
  ) -> some View {
    AvoidContactsGuideView(
      requestContactsPermissionUseCase: requestContactsPermissionUseCase,
      fetchContactsUseCase: fetchContactsUseCase,
      blockContactsUseCase: blockContactsUseCase
    )
    .trackScreen(trackable: SignUpProgress.avoidance)
  }

  public static func createTermsAgreementView(
    fetchTermsUseCase: FetchTermsUseCase
  ) -> some View {
    TermsAgreementView(fetchTermsUseCase: fetchTermsUseCase)
      .trackScreen(trackable: SignUpProgress.terms)
  }
  
  public static func createTermsWebView(term: TermModel) -> some View {
    TermsWebView(term: term)
      .trackScreen(trackable: DefaultProgress.termsDetail)
  }
  
  public static func createPermissionRequestView(
    photoPermissionUseCase: PhotoPermissionUseCase,
    requestNotificationPermissionUseCase: RequestNotificationPermissionUseCase,
    requestContactsPermissionUseCase: RequestContactsPermissionUseCase
  ) -> some View {
    PermissionRequestView(
      photoPermissionUseCase: photoPermissionUseCase,
      requestNotificationPermissionUseCase: requestNotificationPermissionUseCase,
      requestContactsPermissionUseCase: requestContactsPermissionUseCase
    )
    .trackScreen(trackable: SignUpProgress.permission)
  }
  
  public static func createCompleteSignUpView() -> some View {
    CompleteSignUpView()
      .trackScreen(trackable: SignUpProgress.complete)
  }
  
  public static func createProfileContainerView(
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase,
    cameraPermissionUseCase: CameraPermissionUseCase,
    getValueTalksUseCase: GetValueTalksUseCase,
    getValuePicksUseCase: GetValuePicksUseCase
  ) -> some View {
    CreateProfileContainerView(
      checkNicknameUseCase: checkNicknameUseCase,
      uploadProfileImageUseCase: uploadProfileImageUseCase,
      cameraPermissionUseCase: cameraPermissionUseCase,
      getValueTalksUseCase: getValueTalksUseCase,
      getValuePicksUseCase: getValuePicksUseCase
    )
  }
  
  public static func createEditRejectedProfileContainerView(
    getProfileBasicUseCase: GetProfileBasicUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    uploadProfileImageUseCase: UploadProfileImageUseCase,
    cameraPermissionUseCase: CameraPermissionUseCase,
    photoPermissionUseCase: PhotoPermissionUseCase,
    getProfileValueTalksUseCase: GetProfileValueTalksUseCase,
    getProfileValuePicksUseCase: GetProfileValuePicksUseCase
  ) -> some View {
    CreateEditRejectedProfileContainerView(
      getProfileBasicUseCase: getProfileBasicUseCase,
      checkNicknameUseCase: checkNicknameUseCase,
      uploadProfileImageUseCase: uploadProfileImageUseCase,
      cameraPermissionUseCase: cameraPermissionUseCase,
      photoPermissionUseCase: photoPermissionUseCase,
      getProfileValueTalksUseCase: getProfileValueTalksUseCase,
      getProfileValuePicksUseCase: getProfileValuePicksUseCase
    )
  }
  
  public static func createWaitingAISummaryView(
    profile: ProfileModel,
    createProfileUseCase: CreateProfileUseCase
  ) -> some View {
    WaitingAISummaryView(
      profile: profile,
      createProfileUseCase: createProfileUseCase
    )
  }
  
  public static func createEditRejectedWaitingAISummaryView(
    profile: ProfileModel,
    putProfileUseCase: PutProfileUseCase
  ) -> some View {
    EditRejectedWaitingAISummaryView(
      profile: profile,
      putProfileUseCase: putProfileUseCase
    )
  }
  
  public static func createCompleteCreateProfileView() -> some View {
    CompleteCreateProfileView()
  }
  
  public static func createCompleteEditRejectedProfileView() -> some View {
    CompleteEditRejectedProfileView()
  }
}
