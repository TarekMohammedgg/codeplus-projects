# Doctor Hunt

Doctor Hunt is a Flutter UI demo for discovering doctors and exploring appointment screens. It currently uses local mock data, so authentication, booking, and backend persistence are not connected yet.

## Current screens

- Onboarding with a page indicator and role selection
- Login, sign-up, OTP, and password reset UI
- Home dashboard with doctor categories and favorites
- Doctor search, filtering, details, and local booking feedback

## Project structure

```text
lib/
├── main.dart
├── generated/
│   ├── app_image.dart
│   ├── generate_styles.dart
│   └── style_atoms.dart
└── apps/
    ├── core/
    │   ├── constants/
    │   ├── extensions/
    │   ├── router/
    │   ├── theme/
    │   └── widgets/
    └── features/
        ├── auth/
        ├── doctors/
        ├── home/
        └── onboarding/
```

Feature-specific models and mock data live under each feature's `data` folder. Screen-only widgets stay with their screen, while shared widgets are kept in `apps/core/widgets`.

## Packages

- [`go_router`](https://pub.dev/packages/go_router) for navigation
- [`pinput`](https://pub.dev/packages/pinput) for OTP input
- [`smooth_page_indicator`](https://pub.dev/packages/smooth_page_indicator) for onboarding progress
- [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash) for the native splash screen
- [`flutter_lints`](https://pub.dev/packages/flutter_lints) for analysis rules

## Setup

```bash
flutter pub get
flutter run
```

Run the tests with:

```bash
flutter test
```

The style atom file is generated from its local script:

```bash
dart run lib/generated/generate_styles.dart
```
