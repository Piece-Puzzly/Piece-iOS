//
//  CompleteIAPError.swift
//  UseCases
//
//  Created by 홍승완 on 11/3/25.
//

import Foundation

public enum CompleteIAPError: Error {
  case productNotFound
  case purchaseFailed
  case userCancelled
  case purchasePending
  case unknown
}
