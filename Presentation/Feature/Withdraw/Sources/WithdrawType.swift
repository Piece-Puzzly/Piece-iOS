//
//  WithdrawType.swift
//  Withdraw
//
//  Created by 김도형 on 2/13/25.
//

import Foundation

enum WithdrawType: String, CaseIterable {
  case 인연을_만났어요 = "인연을 만났어요"
  case 잠시_매칭을_쉬고_싶어요 = "잠시 매칭을 쉬고 싶어요"
  case 나와_잘_맞는_분을_찾기_어려웠어요 = "나와 잘 맞는분을 찾기 어려웠어요"
  case 앱_사용이_전반적으로_불편했어요 = "앱 사용이 전반적으로 불편했어요"
  case 오류나_버그가_자주_발생했어요 = "오류나 버그가 자주 발생했어요"
  case 기타 = "기타"
}

enum WithdrawCoupleMadeRoute: String, CaseIterable {
  case 피스를_통해_만났어요 = "피스를 통해 만났어요"
  case 다른_경로로_만났어요 = "다른 경로로 만났어요"
}
