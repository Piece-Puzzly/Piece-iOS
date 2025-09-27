//
//  Router.swift
//  Router
//
//  Created by summercat on 1/29/25.
//

import Observation
import SwiftUI

@Observable
public final class Router {
  public var path = NavigationPath()
  public var initialRoute: Route {
    didSet {
      self.rootViewId = UUID()
    }
  }
  
  public private(set) var rootViewId = UUID()
  
  public init(initialRoute: Route = .splash) {
    print("➡️ initial route: \(initialRoute)")
    self.initialRoute = initialRoute
  }
  
  /// NavigationPath에 하나의 route를 추가합니다 (swipe back으로 뒤로가기 가능)
  /// - Parameter route: 이동하고자 하는 route
  public func push(to route: Route) {
    print("➡️ push to: \(route)")
    path.append(route)
  }
  
  /// 현재 화면을 NavigationPath에서 제거하고 이전 화면으로 이동합니다.
  public func pop() {
    print("➡️ pop")
    path.removeLast()
  }
  
  /// NavigationPath의 모든 route를 제거하고, initialRoute로 이동합니다.
  public func popToRoot() {
    print("➡️ pop to root")
    path.removeLast(path.count)
  }
  
  /// NavigationPath의 모든 route를 제거하고 인자로 전달받은 route로 이동합니다.
  /// - Parameter route: 이동하고자 하는 route
  public func setRoute(_ route: Route) {
    print("➡️ set route: \(route)")
    path.removeLast(path.count)
    initialRoute = route
  }
  
  @MainActor
  public func setRoute(_ route: Route, completion: @escaping (() -> Void)) {
    print("➡️ set route: \(route)")
    path.removeLast(path.count)
    initialRoute = route
    
    Task {
      await Task.yield()
      completion()
    }
  }
  
  public func setRouteAndPush(root: Route, pushTo route: Route) {
    print("➡️ set route and push: root \(root), route \(route)")
    path.removeLast(path.count)
    initialRoute = root
    path.append(route)
  }
}
