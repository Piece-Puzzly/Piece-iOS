//
//  DefaultProgress.swift
//  PCAmplitude
//
//  Created by 홍승완 on 9/14/25.
//

import Foundation

public enum DefaultProgress: String, ProgressTrackable {
  case termsDetail = "signup_terms_detail"
  case loginIntro = "login_intro"
  case loginPhoneVerify = "login_phone_verify"
  case alreadyRegisteredPopup = "already_registered_popup"
}
