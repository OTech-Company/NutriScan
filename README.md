# NutriScan

NutriScan is an iOS health and nutrition companion built with SwiftUI. It helps users scan packaged food, review personalized safety and nutrition information, track daily calories and activity, save products, and ask nutrition questions through an AI assistant.

## Highlights

- Scan food products with camera and barcode-driven flows.
- Review product safety verdicts, explanations, flagged ingredients, nutrition facts, and favorite state.
- Track calories, meals, water, steps, exercises, and history.
- View recent completed scans from Home and full scan history from Profile.
- Save products to Favorites and keep related screens refreshed.
- Manage onboarding, authentication, profile setup, family members, notifications, settings, and account restoration.
- Chat with an AI assistant that supports English and Arabic surfaces.
- Uses light and dark SwiftUI interfaces with shared semantic colors and custom fonts.

## Tech Stack

- Swift 5
- SwiftUI
- Observation
- Clean Architecture with feature-first modules
- Async/await
- HealthKit integration for steps
- AppAuth for authentication support
- Kingfisher for remote image loading
- SwiftUI-Shimmer for loading states

## Requirements

- Xcode 16 or newer
- iOS 17 or newer
- Swift Package Manager dependencies resolved by Xcode
- A simulator for most UI work
- A physical device for camera, HealthKit, motion, microphone, speech, and notification behavior that cannot be fully verified in Simulator

## Getting Started

1. Clone the repository.
2. Open `NutriScan/NutriScan.xcodeproj` in Xcode.
3. Let Xcode resolve Swift Package Manager dependencies.
4. Select the `NutriScan` scheme.
5. Choose an available iOS Simulator or physical device.
6. Build and run.

Command-line build example:

```sh
xcodebuild \
  -project NutriScan/NutriScan.xcodeproj \
  -scheme NutriScan \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build
```

If that simulator name is unavailable locally, run `xcodebuild -showdestinations -project NutriScan/NutriScan.xcodeproj -scheme NutriScan` and use one of the listed destinations.

## Project Structure

```text
NutriScan/
├── README.md
└── NutriScan/
    ├── NutriScan.xcodeproj
    ├── NutriScan/
    │   ├── Core/
    │   ├── DI/
    │   ├── Features/
    │   ├── Resources/
    │   ├── RootCoordinatorView.swift
    │   └── NutriScanApp.swift
    ├── NutriScanTests/
    └── NutriScanUITests/
```

## Architecture

NutriScan uses feature-first Clean Architecture:

- `Domain` contains entities, repository protocols, and use cases.
- `Data` contains DTOs, endpoints, services/data sources, repositories, and mappers.
- `Presentation` contains SwiftUI views, UI state, view models, routing, and presentation-only extensions.
- `DI` wires concrete implementations into `DIContainer`.
- `Core` contains shared networking, navigation, security, tab bar, notifications, and reusable UI.

Each main tab owns an independent `NavigationStack` and `AppRouter`, while `RootCoordinatorView` handles top-level app flows such as splash, onboarding, authentication, profile setup, main tabs, and account restoration.

## Main Features

### Scan

The Scan feature handles camera scanning, product lookup, image submission, processing, completed scans, failed scans, and handoff to product details when analysis is available.

### Product Details

Product details displays product identity, scan date, safety level, personalized explanation, flagged ingredients, nutrition facts, and favorite controls. Failed scans are clearly labeled and do not pretend that analysis succeeded.

### Home

Home surfaces the user's profile greeting, health tips, quick scan entry point, health news, AI chat access, and recent completed scans.

### Calories and Activity

Calories and activity screens cover calorie tracking, daily products, water, exercise, step tracking, and history.

### Profile and Settings

Profile and settings cover profile data, family members, edit profile, scan history, calories history, notifications, help, terms, and account controls.

### AI Assistant

The RAG assistant supports nutrition questions with chat, voice-oriented surfaces, and source display, including English and Arabic-oriented layout considerations.

## Design Principles

- Calm, trustworthy, and encouraging health guidance.
- Clear visible state for loading, empty, error, success, failed, and disabled cases.
- Shared semantic colors and `Font.AppFont` typography.
- Accessible controls with meaningful labels, values, hints, and readable contrast.
- Dark-mode support across feature surfaces.
- Privacy-aware previews, screenshots, logging, and documentation.

## Verification

Before opening a pull request or sharing a build:

```sh
git diff --check
xcodebuild -project NutriScan/NutriScan.xcodeproj -scheme NutriScan -destination '<available simulator destination>' build
```

Run focused unit tests for business logic, mapping, formatting, and repositories. Run UI tests or manually exercise flows when navigation, forms, camera, permissions, or user interaction changes.
