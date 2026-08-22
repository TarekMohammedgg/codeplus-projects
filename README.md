# Doctor Hunt 🩺

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2.svg?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)]()

**Doctor Hunt** is a modern, responsive healthcare and medical appointment discovery application built with Flutter. It provides an intuitive, polished user interface for exploring doctor profiles, discovering specialties, scheduling appointments, and managing user preferences with full internationalization support.

> [!NOTE]
> Currently, the application uses structured local mock data and is designed as a modular, production-ready frontend template ready for backend and API integration.

---

## ✨ Features & Screens

- 🚀 **Onboarding & Role Selection**: Interactive multi-step onboarding with smooth page indicators and role selection (Patient / Healthcare Provider).
- 🔐 **Authentication Flow**:
  - Email and password sign-in & registration with robust client-side validation.
  - Interactive OTP verification modal bottom sheets and screens with PIN inputs (`pinput`).
  - Forgot password & reset password workflows.
- 🏠 **Home Dashboard**:
  - Live search bar and promotional health banners.
  - Doctor specialty categories (Cardiology, Dental, Ophthalmology, General Medicine).
  - Popular doctors carousel with ratings, reviews, and dynamic favorite toggling.
- 👨‍⚕️ **Doctor Discovery & Profile**:
  - Doctor listing with search, filtering, and availability tags.
  - Detailed doctor profiles with biographies, patient reviews, and instant appointment booking feedback.
- 🌐 **Internationalization (i18n) & RTL Support**:
  - Full English and Arabic language support powered by `slang`.
  - Automatic RTL (Right-to-Left) and LTR layout direction adaptation.
  - Dedicated settings screen for real-time language switching without app restarts.

---

## 📁 Project Structure

The project follows a **Feature-First Architecture** ensuring clear separation of concerns, scalability, and maintainability:

```text
lib/
├── main.dart                      # App entry point & localization provider setup
├── generated/                     # Generated code (i18n, assets, and design tokens)
│   ├── app_image.dart             # Strongly-typed asset references
│   ├── generate_styles.dart       # Design system atom generator script
│   ├── style_atoms.dart           # Atomic style definitions
│   └── i18n/                      # Slang generated translation classes
│       ├── translations.g.dart
│       ├── translations_en.g.dart
│       └── translations_ar.g.dart
└── apps/
    ├── core/                      # Shared core module
    │   ├── constants/             # Global app constants
    │   ├── extensions/            # BuildContext, num, and UI utility extensions
    │   ├── router/                # Type-safe GoRouter configuration & routes
    │   ├── theme/                 # AppTheme, colors, and typography definitions
    │   ├── utils/                 # Form validators and helper utilities
    │   └── widgets/               # Reusable shared UI widgets (Header, Search, Buttons)
    └── features/                  # Feature modules (Feature-Driven)
        ├── auth/                  # Authentication screens, widgets, and state
        ├── doctors/               # Doctor search, list, details, and models
        ├── home/                  # Home dashboard, banners, and categories
        ├── onboarding/            # Onboarding carousel and role selection
        └── settings/              # App settings and locale switcher
```

- **Feature-Driven**: Feature-specific models, mock data, and private widgets reside within each feature folder.
- **Core Separation**: Global utilities, design tokens, extensions, and shared components live in `apps/core/`.

---

## 📦 Packages & Dependencies

| Package | Purpose |
| :--- | :--- |
| [`go_router`](https://pub.dev/packages/go_router) | Declarative, type-safe routing and deep-linking |
| [`go_router_builder`](https://pub.dev/packages/go_router_builder) | Code generation for type-safe route definitions |
| [`slang`](https://pub.dev/packages/slang) & [`slang_flutter`](https://pub.dev/packages/slang_flutter) | Type-safe, compile-time internationalization (i18n) |
| [`pinput`](https://pub.dev/packages/pinput) | Custom PIN and OTP verification input field |
| [`smooth_page_indicator`](https://pub.dev/packages/smooth_page_indicator) | Animated page indicators for onboarding flows |
| [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash) | Native splash screen configuration across platforms |
| [`flutter_lints`](https://pub.dev/packages/flutter_lints) | Recommended static analysis lint rules |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.12.2` or later)
- [Dart SDK](https://dart.dev/get-dart)
- An IDE (VS Code, Android Studio, or IntelliJ IDEA) with Flutter and Dart plugins

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/TarekMohammedgg/codeplus-projects.git
   cd codeplus-projects
   ```

2. **Switch to the `doctor-hunt` branch**:
   ```bash
   git checkout doctor-hunt
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

---

## ⚙️ Code Generation

This project leverages code generators for type-safe routing, localization, and design system tokens.

- **Run all build runners (Routing & i18n)**:
  ```bash
  dart run build_runner build -d
  ```

- **Watch mode during development**:
  ```bash
  dart run build_runner watch -d
  ```

- **Generate style atoms**:
  ```bash
  dart run lib/generated/generate_styles.dart
  ```

---

## 🧪 Testing & Quality Assurance

The codebase maintains a comprehensive test suite covering widgets, routing, authentication, home screen, and localization:

- **Run all automated tests**:
  ```bash
  flutter test
  ```

- **Run static code analysis**:
  ```bash
  flutter analyze
  ```

---

## 📱 Running the Application

Launch the app on your connected device or emulator:

```bash
# Debug mode
flutter run

# Run on a specific device/platform (e.g. Chrome, Android, iOS, Windows)
flutter run -d chrome
flutter run -d android
flutter run -d windows
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
