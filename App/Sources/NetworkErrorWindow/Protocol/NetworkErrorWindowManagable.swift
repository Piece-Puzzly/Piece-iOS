//
//  NetworkErrorWindowManagable.swift
//  Piece-iOS
//
//  Created by 홍승완 on 10/18/25.
//  Copyright © 2025 puzzly. All rights reserved.
//

import Router
import PCNetworkMonitor

@MainActor
protocol NetworkErrorWindowManagable {
  func configure(router: Router, networkMonitor: PCNetworkMonitor)
}
