# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Piece-iOS is a value-based dating app built with SwiftUI, following Clean Architecture principles with a modular design managed by Tuist. The project consists of 33 modules organized into distinct layers with clear separation of concerns.

## Setup & Build Commands

### Prerequisites
```bash
# Install mise (version manager)
brew install mise

# Install Tuist (version 4.37.0 via mise)
mise install

# Install Ruby dependencies
bundle install
```

### Project Generation
```bash
# Generate Xcode workspace and projects
tuist generate

# Open the workspace
open Piece-iOS.xcworkspace
```

### Build Schemes
- **Piece-iOS-Debug**: Development build using dev server (Debug.xcconfig)
- **Piece-iOS-Release**: Production build using prod server (Release.xcconfig)

### Deployment
```bash
# Deploy to TestFlight
bundle exec fastlane ios beta

# Deploy to App Store
bundle exec fastlane ios deploy
```

### Testing
Currently, no dedicated test targets exist. Test-related code is limited to mock use cases in the Domain layer (TestLoginUseCase, TestLoginError).

## Architecture

### Clean Architecture Layers

The project follows strict layering with dependencies flowing inward:

**App Layer** (`/App`)
- Main application target
- Entry point: `PieceApp.swift` (SwiftUI App)
- Initializes Firebase, Kakao SDK, Google Sign-In in AppDelegate
- Creates root Coordinator and Router

**Presentation Layer** (`/Presentation` - 26 modules)
- **Core**: DesignSystem, Router, Coordinator
- **Features**: 23 feature modules (Splash, Login, SignUp, Home, Profile, MatchingMain, Store, etc.)
- All features use SwiftUI with MVVM pattern
- ViewModels use `@Observable` macro (iOS 17+)

**Domain Layer** (`/Domain` - 3 modules)
- **Entities**: Business models (User, Profile, Match, ValueTalk, etc.)
- **UseCases**: Business logic interfaces (GetProfile, AcceptMatch, etc.)
- **RepositoryInterfaces**: Repository protocols (no concrete implementations)

**Data Layer** (`/Data` - 4 modules)
- **PCNetwork**: Alamofire-based networking with SSE support and OAuth auto-refresh
- **DTO**: Data transfer objects for API responses
- **Repository**: Concrete repository implementations
- **LocalStorage**: Keychain and UserDefaults wrappers

**Utility Layer** (`/Utility` - 4 modules)
- PCFoundationExtension, PCFirebase, PCAmplitude, PCNetworkMonitor

### Module Types
- **App**: Main application target
- **Dynamic Frameworks**: Core modules (Router, Coordinator) and data/domain modules
- **Dynamic Resource Frameworks**: DesignSystem (includes Pretendard fonts)
- **Static Libraries**: Feature modules for faster incremental builds

## Navigation & Dependency Injection

### Router Pattern
Navigation uses a custom `Router` class built on SwiftUI's `NavigationPath`:

```swift
// Centralized routing with type-safe Route enum
router.push(.profile(memberId: id))
router.pop()
router.popToRoot()
router.setRoute([.home, .settings])
```

### Coordinator Pattern
The `Coordinator` struct acts as the composition root for dependency injection:

```swift
// Flow: Route → Coordinator → ViewFactory → View (with dependencies)
Coordinator.view(for: .home) → HomeViewFactory.makeView() → HomeView
```

**Key responsibilities:**
- Creates all repositories via `RepositoryFactory`
- Creates all use cases via `UseCaseFactory`
- Maps `Route` enum cases to SwiftUI views
- Injects dependencies into view factories

### Factory Pattern
Each feature module has a factory for creating views with dependencies:

```swift
// Example: HomeViewFactory
public static func makeView(
    coordinator: Coordinator,
    router: Router,
    useCase: GetProfileUseCase
) -> some View {
    let viewModel = HomeViewModel(useCase: useCase)
    return HomeView(viewModel: viewModel, coordinator: coordinator, router: router)
}
```

## Key Development Patterns

### Dependency Flow
1. App creates `Coordinator` (composition root)
2. Coordinator creates factories (Repository, UseCase)
3. Route triggers view creation via Coordinator
4. Coordinator calls feature's ViewFactory
5. ViewFactory creates ViewModel with injected use cases
6. View receives ViewModel, Coordinator, and Router

### Repository Pattern
- Protocols defined in Domain layer (`RepositoryInterfaces`)
- Implementations in Data layer (`Repository`)
- Created by `RepositoryFactory` with NetworkService dependency
- All network calls go through repositories

### Networking (PCNetwork)
- Custom `NetworkService` using Alamofire
- OAuth authentication with automatic token refresh
- SSE (Server-Sent Events) support for real-time updates
- Endpoint-based architecture with custom serialization
- Error handling with domain-specific error types

### State Management
- ViewModels use `@Observable` macro (no Combine/ObservableObject)
- Requires iOS 17.0+ deployment target
- State mutations trigger automatic SwiftUI updates

### Environment Configuration
- `Debug.xcconfig`: Development server URLs and API keys
- `Release.xcconfig`: Production server URLs and API keys
- Build number auto-increments based on main branch commit count
- Never commit sensitive values to version control

## Module Organization Rules

### Dependency Boundaries
- **Presentation** can depend on Domain and Utility
- **Domain** has no dependencies on other layers
- **Data** can depend on Domain and Utility
- **Features** cannot depend on other features (enforced by Tuist)
- **Utility** modules are independent

### Adding New Features
Use Tuist scaffolding template:
```bash
tuist scaffold feature --name FeatureName
```

This generates:
- Feature module in Presentation/Feature/
- Project.swift with proper dependencies
- ViewFactory boilerplate
- Basic View and ViewModel structure

## Third-Party Dependencies

All dependencies managed via `Tuist/Package.swift`:

- **Networking**: Alamofire (5.10.2)
- **Image Loading**: Kingfisher (8.1.4), SDWebImageSwiftUI (3.1.4), SDWebImageSVGCoder (1.7.0)
- **Social Login**: KakaoOpenSDK (2.23.0), GoogleSignIn (7.0.0)
- **Animations**: Lottie (4.5.1)
- **Firebase**: firebase-ios-sdk (11.8.1) - Analytics, Crashlytics, RemoteConfig, Messaging
- **Image Editing**: Mantis (2.26.0)
- **Analytics**: AmplitudeSwift (1.14.0)

Most dependencies configured as `.framework` for dynamic linking.

## Commit Convention

Format: `[TICKET-ID] Type: Description`

**Types:**
- `Feature`: New functionality
- `Fix`: Bug fixes
- `Build`: Build system or dependency changes
- `Chore`: Maintenance tasks
- `Refactor`: Code restructuring without behavior changes

**Examples:**
```
[PC-1342] Feature: StoreMain 프로모션 상품 UI 구현
[PC-1342] Fix: Description 하단 패딩 수정
[PC-1342] Build: SVG 이미지 url 로드를 위한 서드파티 의존성 추가
```

## Important Notes

### Version Requirements
- **iOS**: 17.0+
- **Xcode**: 16.3
- **Tuist**: 4.37.0 (managed via mise)
- **Swift**: Version specified by Xcode

### Common Gotchas
- Always run `tuist generate` after modifying Project.swift files
- xcconfig files contain environment-specific configurations - check before building
- Router must be passed down through view hierarchy for navigation
- Coordinator is needed for navigating to different features
- Factory pattern is required for creating views with proper dependency injection

### Main Navigation Structure
Tab-based main screen with three tabs:
1. **Profile Tab**: User's own profile (ProfileView)
2. **Home/Match Tab**: Main matching interface (MatchingMainView)
3. **Settings Tab**: App settings (SettingsView)

Accessed via `Route.home` which contains nested routes for each tab.
