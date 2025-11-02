//
//  UseCaseFactory.swift
//  UseCases
//
//  Created by summercat on 1/30/25.
//

import Foundation
import RepositoryInterfaces

public struct UseCaseFactory {

  // MARK: - 권한
  public static func createCheckContactsPermissionUseCase() -> CheckContactsPermissionUseCase {
    CheckContactsPermissionUseCaseImpl()
  }
  
  public static func createRequestContactsPermissionUseCase(checkContactsPermissionUseCase: CheckContactsPermissionUseCase) -> RequestContactsPermissionUseCase {
    RequestContactsPermissionUseCaseImpl(checkContactsPermissionUseCase: checkContactsPermissionUseCase)
  }
  
  public static func createCheckNotificationPermissionUseCase() -> CheckNotificationPermissionUseCase {
    CheckNotificationPermissionUseCaseImpl()
  }
  
  public static func createRequestNotificationPermissionUseCase() -> RequestNotificationPermissionUseCase {
    RequestNotificationPermissionUseCaseImpl()
  }
  
  public static func createChangeNotificationRegisterStatusUseCase() -> ChangeNotificationRegisterStatusUseCase {
    ChangeNotificationRegisterStatusUseCaseImpl()
  }
  
  public static func createCameraPermissionUseCase() -> CameraPermissionUseCase {
    CameraPermissionUseCaseImpl()
  }
  
  public static func createPhotoPermissionUseCase() -> PhotoPermissionUseCase {
    PhotoPermissionUseCaseImpl()
  }
    
  // MARK: - 사용자
  public static func createGetUserInfoUseCase(repository: UserRepositoryInterface) -> GetUserInfoUseCase {
    GetUserRoleUseCaseImpl(repository: repository)
  }
  
  // MARK: - 로그인
  
  public static func createAppleAuthLoginUseCase() -> AppleAuthServiceUseCase {
    AppleAuthServiceUseCaseImpl()
  }
  
  public static func createSocialLoginUseCase(repository: LoginRepositoryInterface) -> SocialLoginUseCase {
    SocialLoginUseCaseImpl(repository: repository)
  }
  
  public static func createAppleAuthServiceUseCase() -> AppleAuthServiceUseCase {
    AppleAuthServiceUseCaseImpl()
  }
  
  public static func createSendSMSCodeUseCase(repository: LoginRepositoryInterface) -> SendSMSCodeUseCase {
    SendSMSCodeUseCaseImpl(repository: repository)
  }
  
  public static func createVerifySMSCodeUseCase(repository: LoginRepositoryInterface) -> VerifySMSCodeUseCase {
    VerifySMSCodeUseCaseImpl(repository: repository)
  }
  
  public static func createRegisterFcmTokenUseCase(repository: LoginRepositoryInterface) -> RegisterFcmTokenUseCase {
    RegisterFcmTokenUseCaseImpl(repository: repository)
  }
  
  public static func createTestLoginUseCase(repository: LoginRepositoryInterface) -> TestLoginUseCase {
    TestLoginUseCaseImpl(repository: repository)
  }
  
  // MARK: - 기타
  
  public static func createFetchTermsUseCase(repository: TermsRepositoryInterfaces) -> FetchTermsUseCase {
    FetchTermsUseCaseImpl(repository: repository)
  }
  
  public static func createCheckNicknameUseCase(repository: CheckNinknameRepositoryInterface) -> CheckNicknameUseCase {
    CheckNicknameUseCaseImpl(repository: repository)
  }
  
  public static func createFetchContactsUseCase() -> FetchContactsUseCase {
    FetchContactsUseCaseImpl()
  }
  
  public static func createBlockContactsUseCase(repository: BlockContactsRepositoryInterface) -> BlockContactsUseCase {
    BlockContactsUseCaseImpl(repository: repository)
  }
  
  public static func createCheckTokenHealthUseCase(repository: LoginRepositoryInterface) -> CheckTokenHealthUseCase {
    CheckTokenHealthUseCaseImpl(repository: repository)
  }
  
  public static func createDeleteUserAccountUseCase(repository: WithdrawRepositoryInterface) -> DeleteUserAccountUseCase {
    DeleteUserAccountUseCaseImpl(repository: repository)
  }
  
  // MARK: - Profile
  public static func createUploadProfileImageUseCase(repository: ProfileRepositoryInterface) -> UploadProfileImageUseCase {
    UploadProfileImageUseCaseImpl(repository: repository)
  }
  
  public static func createGetProfileUseCase(repository: ProfileRepositoryInterface) -> GetProfileBasicUseCase {
    GetProfileUseCaseImpl(repository: repository)
  }
  
  public static func createUpdateProfileBasicUseCase(repository: ProfileRepositoryInterface) -> UpdateProfileBasicUseCase {
    UpdateProfileBasicUseCaseImpl(repository: repository)
  }
  
  public static func createProfileUseCase(repository: ProfileRepositoryInterface) -> CreateProfileUseCase {
    CreateProfileUseCaseImpl(repository: repository)
  }
  
  public static func createEditRejectedProfileUseCase(repository: ProfileRepositoryInterface) -> PutProfileUseCase {
    PutProfileUseCaseImpl(repository: repository)
  }
  
  public static func createGetValueTalksUseCase(repository: ValueTalksRepositoryInterface) -> GetValueTalksUseCase {
    GetValueTalksUseCaseImpl(repository: repository)
  }
  
  public static func createGetValuePicksUseCase(repository: ValuePicksRepositoryInterface) -> GetValuePicksUseCase {
    GetValuePicksUseCaseImpl(repository: repository)
  }
  
  public static func createGetProfileValueTalksUseCase(repository: ProfileRepositoryInterface) -> GetProfileValueTalksUseCase {
    GetProfileValueTalksUseCaseImpl(repository: repository)
  }
  
  public static func createUpdateProfileValueTalksUseCase(repository: ProfileRepositoryInterface) -> UpdateProfileValueTalksUseCase {
    UpdateProfileValueTalksUseCaseImpl(repository: repository)
  }
  
  public static func createGetProfileValuePicksUseCase(repository: ProfileRepositoryInterface) -> GetProfileValuePicksUseCase {
    GetProfileValuePicksUseCaseImpl(repository: repository)
  }
  
  public static func createUpdateProfileValuePicksUseCase(repository: ProfileRepositoryInterface) -> UpdateProfileValuePicksUseCase {
    UpdateProfileValuePicksUseCaseImpl(repository: repository)
  }
  
  public static func createUpdateProfileValueTalkSummaryUseCase(repository: ProfileRepositoryInterface) -> UpdateProfileValueTalkSummaryUseCase {
    UpdateProfileValueTalkSummaryUseCaseImpl(repository: repository)
  }
  
  // MARK: - 매칭
  public static func createGetUserRejectUseCase(repository: MatchesRepositoryInterface) -> GetUserRejectUseCase {
    GetUserRejectUseCaseImpl(repository: repository)
  }
  
  public static func createPatchMatchesCheckPieceUseCase(repository: MatchesRepositoryInterface) -> PatchMatchesCheckPieceUseCase {
    PatchMatchesCheckPieceUseCaseImpl(repository: repository)
  }
  
  public static func createGetMatchesInfoUseCase(repository: MatchesRepositoryInterface) -> GetMatchesInfoUseCase {
    GetMatchesInfoUseCaseImpl(repository: repository)
  }
  
  public static func createAcceptMatchUseCase(repository: MatchesRepositoryInterface) -> AcceptMatchUseCase {
    AcceptMatchUseCaseImpl(repository: repository)
  }
  
  public static func createRefuseMatchUseCase(repository: MatchesRepositoryInterface) -> RefuseMatchUseCase {
    RefuseMatchUseCaseImpl(repository: repository)
  }
  
  // MARK: - 매칭 상세
  public static func createGetMatchProfileBasicUseCase(repository: MatchesRepositoryInterface) -> GetMatchProfileBasicUseCase {
    GetMatchProfileBasicUseCaseImpl(repository: repository)
  }
  
  public static func createGetMatchValueTalkUseCase(repository: MatchesRepositoryInterface) -> GetMatchValueTalkUseCase {
    GetMatchValueTalkUseCaseImpl(repository: repository)
  }
  
  public static func createGetMatchValuePickUseCase(repository: MatchesRepositoryInterface) -> GetMatchValuePickUseCase {
    GetMatchValuePickUseCaseImpl(repository: repository)
  }
  
  public static func createGetMatchPhotoUseCase(repository: MatchesRepositoryInterface) -> GetMatchPhotoUseCase {
    GetMatchPhotoUseCaseImpl(repository: repository)
  }
  
  public static func createGetMatchContactsUseCase(repository: MatchesRepositoryInterface) -> GetMatchContactsUseCase {
    GetMatchContactsUseCaseImpl(repository: repository)
  }
  
  public static func createReportUserUseCase(repository: ReportsRepositoryInterface) -> ReportUserUseCase {
    ReportUserUseCaseImpl(repository: repository)
  }
  
  public static func createBlockUserUseCase(repository: MatchesRepositoryInterface) -> BlockUserUseCase {
    BlockUserUseCaseImpl(repository: repository)
  }
  
  // MARK: - AI요약 SSE
  public static func createConnectSseUseCase(repository: SSERepositoryInterface) -> ConnectSseUseCase {
    ConnectSseUseCaseImpl(repository: repository)
  }
  
  public static func createDisconnectSseUseCase(repository: SSERepositoryInterface) -> DisconnectSseUseCase {
    DisconnectSseUseCaseImpl(repository: repository)
  }
  
  // MARK: - 설정
  public static func createGetSettingsInfoUseCase(repository: SettingsRepositoryInterface) -> GetSettingsInfoUseCase {
    GetSettingsInfoUseCaseImpl(repository: repository)
  }
  
  public static func createPutSettingsNotificationUseCase(repository: SettingsRepositoryInterface) -> PutSettingsNotificationUseCase {
    PutSettingsNotificationUseCaseImpl(repository: repository)
  }
  
  public static func createPutSettingsBlockAcquaintanceUseCase(repository: SettingsRepositoryInterface) -> PutSettingsBlockAcquaintanceUseCase {
    PutSettingsBlockAcquaintanceUseCaseImpl(repository: repository)
  }
  
  public static func createGetContactsSyncTimeUseCase(repository: SettingsRepositoryInterface) -> GetContactsSyncTimeUseCase {
    GetContactsSyncTimeUseCaseImpl(repository: repository)
  }
  
  public static func createLogoutUseCase(repository: SettingsRepositoryInterface) -> PatchLogoutUseCase {
    PatchLogoutUseCaseImpl(repository: repository)
  }
  
  // MARK: - 알림
  public static func createGetNotificationsUseCase(repository: NotificationRepositoryInterface) -> GetNotificationsUseCase {
    GetNotificationsUseCaseImpl(repository: repository)
  }
  
  public static func createReadNotificationUseCase(repository: NotificationRepositoryInterface) -> ReadNotificationUseCase {
    ReadNotificationUseCaseImpl(repository: repository)
  }
  
  // MARK: - IAP
  public static func createGetCashProductsUseCase(repository: IAPRepositoryInterface) -> GetCashProductsUseCase {
    GetCashProductsUseCaseImpl(repository: repository)
  }
  
  public static func createPostVerifyIAPUseCase(repository: IAPRepositoryInterface) -> PostVerifyIAPUseCase {
    PostVerifyIAPUseCaseImpl(repository: repository)
  }
}
