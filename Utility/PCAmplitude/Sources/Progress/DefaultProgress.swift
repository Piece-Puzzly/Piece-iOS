//
//  DefaultProgress.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation

public enum DefaultProgress: String, ProgressTrackable {
  /// 로그인 관련
  case loginIntro = "login_intro"
  case loginPhoneVerify = "login_phone_verify"
  case alreadyRegisteredPopup = "already_registered_popup"
  
  /// 가입 시 이용약관 팝업
  case termsDetail = "signup_terms_detail"
  
  /// 프로필 기본정보 생성 바텀시트
  case basicInfoJobBottomsheet = "basic_info_job_bottomsheet"
  case basicInfoRegionBottomsheet = "basic_info_region_bottomsheet"
  case basicInfoContactBottomsheet = "basic_info_contact_bottomsheet"
  
  /// 심사 전 프로필 프리뷰
  case previewSelfBasicProfile = "preview_self_basic_profile"
  case previewSelfValuePick = "preview_self_value_pick"
  case previewSelfValueTalk = "preview_self_value_talk"
  case previewSelfPhoto = "preview_self_photo"
  
  /// 매칭 메인
  case matchMainLoading = "match_main_loading"
  case matchMainNoMatch = "match_main_no_match" // Nodata
  case matchMainReviewing = "match_main_reviewing" // PENDING
  case matchMainHome = "match_main_home" // USER
  case matchMainProfileRejectPopup = "match_main_profile_reject_popup" // REJECTED
  case matchMainAcceptPopup = "match_main_accept_popup" // 인연 수락 팝업
  
  /// 매칭 상세
  case matchDetailBasicProfile = "match_detail_basic_profile"
  case matchDetailValuePick = "match_detail_value_pick"
  case matchDetailValueTalk = "match_detail_value_talk"
  case matchDetailPhoto = "match_detail_photo"
  case matchDetailAcceptPopup = "match_detail_accept_popup"
  case matchDetailRejectPopup = "match_detail_reject_popup"
  
  /// 로그인 후 프로필
  case profileBasic = "profile_basic"
  case profileEditBasic = "profile_edit_basic"
  case profileEditValueTalk = "profile_edit_value_talk"
  case profileEditValuePick = "profile_edit_value_pick"
  
  /// 알림 리스트
  case notification = "notification"
  
  /// 연락처 공개 화면
  case contactShareResult = "contact_share_result"
  
  /// 신고 / 차단
  case reportBlockSelectBottomsheet = "report_block_select_bottomsheet"
  case reportIntro = "report_intro"
  case reportConfirmPopup = "report_confirm_popup"
  case reportCompletePopup = "report_complete_popup"
  case blockIntro = "block_intro"
  case blockConfirmPopup = "block_confirm_popup"
  case blockCompletePopup = "block_complete_popup"
  
  /// 설정
  case settingIntro = "setting_intro"
  
  /// 로그아웃
  case logoutPopup = "logout_popup"
  
  /// 회원탈퇴
  case withdrawalReason = "withdrawal_reason"
  case withdrawalConfirm = "withdrawal_confirm"
  case withdrawalFoundPartnerBottomsheet = "withdrawal_found_partner_bottomsheet"
  
  /// 스토어
  case storeMain = "store_main"
}
