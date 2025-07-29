// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
  // Customize the product types for specific package product
  // Default is .staticFramework
  // productTypes: ["Alamofire": .framework,]
  productTypes: [
    "Alamofire": .framework,
    "KakaoSDKAuth": .framework,
    "KakaoSDKCommon": .framework,
    "KakaoSDKUser": .framework,
    "GTMAppAuth": .framework,
    "AppAuth": .framework,
    "GoogleSignIn": .framework,
    "Mantis": .framework,
  ],
  baseSettings: .settings()
//      .settings(
//    configurations: [
//      .configuration(environment: .dev),
//      .configuration(environment: .prod),
//    ])
)
#endif

let package = Package(
  name: "Piece-iOS",
  dependencies:
    ExternalDependency.allCases.map {
      Package.Dependency.package(
        url: $0.url,
        from: $0.version
      )
    }
)

enum ExternalDependency: String, CaseIterable {
  case Kingfisher
  case Alamofire
  case KakaoOpenSDK
  case GoogleSignIn
  case Lottie
  case Firebase
  case Mantis
}

extension ExternalDependency {
  var url: String {
    switch self {
    case .Kingfisher: "https://github.com/onevcat/Kingfisher"
    case .Alamofire: "https://github.com/Alamofire/Alamofire"
    case .KakaoOpenSDK: "https://github.com/kakao/kakao-ios-sdk"
    case .GoogleSignIn: "https://github.com/google/GoogleSignIn-iOS"
    case .Lottie: "https://github.com/airbnb/lottie-ios"
    case .Firebase: "https://github.com/firebase/firebase-ios-sdk"
    case .Mantis: "https://github.com/guoyingtao/Mantis"
    }
  }
}

extension ExternalDependency {
  var version: PackageDescription.Version {
    switch self {
    case .Kingfisher: "8.1.4"
    case .Alamofire: "5.10.2"
    case .KakaoOpenSDK: "2.23.0"
    case .GoogleSignIn: "7.0.0"
    case .Lottie: "4.5.1"
    case .Firebase: "11.8.1"
    case .Mantis: "2.26.0"
    }
  }
}
