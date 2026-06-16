# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SwiftUI iOS app with onboarding flow and tab-based main interface.

## Build & Run

```bash
# Build the project
xcodebuild -scheme AiChat -configuration Debug build

# Run tests
xcodebuild test -scheme AiChat -destination 'platform=iOS Simulator,name=iPhone 15'

# Open in Xcode
open AiChat.xcodeproj
```

## Architecture

### App Flow
1. **Entry**: `AiChatApp` → `AppView` (injects `AppState` into environment)
2. **Routing**: `AppViewBuilder` conditionally displays:
   - **Onboarding flow** (showTabBar = false): `WelcomeView` → `OnBoardingIntroView` → `OnBoardingColorView` → `OnBoardingCompletedView`
   - **Main app** (showTabBar = true): `TabBarView` with 3 tabs (Explore, Chats, Profile)

### State Management
- **AppState** (@Observable): Manages global app state
  - `showTabBar`: Controls whether user sees onboarding or main app
  - Persisted in UserDefaults automatically via didSet
  - Injected via `.environment(appState)` and accessed via `@Environment(AppState.self)`

### Key Patterns

**ForEach with Identifiable Types**
- When using `ForEach(colors, id: \.self)`, ensure all elements are unique
- Duplicate values will cause rendering issues (missing items in grid)

**Custom View Modifiers** (View+EXT.swift)
- `.callToFunctionButton()`: Standard CTA button styling
- `.tappableBackground()`: Expands tap area with transparent background

**Image Loading**
- Uses SDWebImageSwiftUI via `ImageLoaderView`
- Random images from Constants.randomImage

## Project Structure

```
AiChat/
├── Core/
│   ├── AiChatApp.swift (Entry point)
│   ├── AppView/ (Root view + state)
│   ├── OnBoarding/ (Welcome and onboarding flow)
│   ├── TabBar/ (Main app tabs)
│   ├── Explore/, Chats/, Profile/ (Tab views)
│   └── Settings/
├── Components/ (Reusable UI components)
├── Extensions/ (View+EXT, etc.)
└── Utility/ (Constants)
```

## Dependencies

- **SDWebImageSwiftUI** (3.1.4): Async image loading with caching
