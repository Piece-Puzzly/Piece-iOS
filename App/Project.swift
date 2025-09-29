import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  dependencies: [
    .presentation(target: .Router),
    .presentation(target: .Coordinator),
    .presentation(target: .DesignSystem),
    .externalDependency(dependency: .KakaoSDKCommon),
    .externalDependency(dependency: .KakaoSDKAuth),
    .externalDependency(dependency: .KakaoSDKUser),
    .externalDependency(dependency: .GoogleSignIn),
    .utility(target: .PCFirebase),
    .utility(target: .PCAmplitude)
  ]
)
