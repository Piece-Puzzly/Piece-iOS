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
}
