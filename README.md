# Doctor Hunt 🩺

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2.svg?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFA611.svg?logo=firebase)](https://firebase.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)]()

**Doctor Hunt** is a modern, feature-rich healthcare and medical appointment booking application built with Flutter. It delivers an intuitive, high-performance cross-platform experience for discovering doctors, exploring medical specialties, scheduling appointment time slots, managing favorite specialists, and managing user profiles — with seamless Firebase backend integration and compile-time type-safe internationalization (English & Arabic with full RTL support).

---

## ✨ Features & Modules

### 🚀 Onboarding & Role Selection
- Interactive multi-step onboarding carousel with rich medical illustrations and animated page indicators (`smooth_page_indicator`).
- Role selection gateway tailored for Patients and Healthcare Providers.

### 🔐 Authentication & Account Security (Firebase + Google Sign-In)
- **Email & Password Authentication**: Full sign-up and sign-in workflows with real-time validation and error handling via `FirebaseAuth`.
- **Google Sign-In**: One-tap social sign-in integration with `google_sign_in` and credential exchange.
- **Password Reset**: Automated password recovery via Firebase Auth email dispatch.
- **OTP Verification**: Secure PIN entry interfaces and modal bottom sheets powered by `pinput`.
- **Personalized User Greeting**: Context-aware user greeting ("Hi [Name] 👋" / "مرحبًا [Name] 👋") adapting dynamically to user profile and active locale.

### 🏠 Home & Medical Dashboard
- **Dynamic Doctor Feeds**: Cloud Firestore data fetching with graceful fallback to structured local mock data.
- **Specialty Categories**: Quick navigation across medical specialties (Cardiology, Dental, Ophthalmology, General Medicine, and more).
- **Popular & Featured Specialists**: Horizontal carousels showcasing doctor ratings, patient review counts, hourly rates, and real-time favorite toggling.
- **Live Doctors Section**: Highlighted cards for currently active and available specialists.
- **Global Search Surface**: Integrated search bar for instantaneous doctor queries.

### 👨‍⚕️ Doctor Discovery & Details
- **Doctor Catalog**: Searchable doctor directory with specialty filtering, rating indicators, and availability status.
- **Detailed Specialist Profile**: Comprehensive view featuring doctor biography, key metrics (patients served, years of experience, rating, reviews), clinic location, and direct booking actions.
- **Network Image Caching**: Smooth image rendering with memory caching via `cached_network_image` and custom fallback avatar placeholders (`DoctorAvatarPlaceholder`).

### 📅 Appointment Scheduling & Slot Selection (`doctor_select_time`)
- **Interactive Date Selection**: Date selection timeline with weekday indicators.
- **Time Slot Picker**: Categorized slot availability partitioned into **Afternoon** and **Evening** consultation sessions (`time_slot`).
- **Availability Fallback**: Smart detection for fully-booked days with instant navigation to the next available date or direct clinic contact action.
- **Booking Confirmation**: Custom modal feedback dialog (`ThankYouDialog`) summarizing doctor name, selected date, and time slot.

### ❤️ Favourite / Saved Doctors (`favourite_doctors`)
- Dedicated favorites screen displaying bookmarked doctors.
- Quick booking shortcuts directly from favorite cards.
- Interactive favorite toggle synchronization.

### 👤 User Profile & Settings (`profile`)
- User profile overview with customizable profile avatar.
- Structured personal information cards (Email, Phone, Date of Birth, Gender).
- Emergency contact details and medical information sections.

### 🛡️ Admin Portal & Doctor Management (`admin`)
- **Admin Dashboard**: Real-time doctor overview with aggregate counters (total doctors, active specialists) and live search/filter by doctor name or specialty.
- **Doctor Creation & Editing**: Create new specialists with full profile details, specialty categorization, and photo uploads, or update existing records.
- **Cloud Media Storage**: Integrated gallery image selection (`image_picker`) and direct upload pipeline to Supabase Storage (`doctor-images` bucket).
- **Real-Time Synchronization**: Live Cloud Firestore streams delivering updates instantaneously upon doctor creation, modification, or deletion, automatically organized with the latest modified doctors first.
- **Admin Settings & Security**: Dedicated admin settings and role-based access control (`UserRole.admin`).

### 🌐 Internationalization (i18n) & RTL Support
- Type-safe, compile-time translation generation powered by `slang`.
- Full bidirectional support for **English (LTR)** and **Arabic (RTL)** with layout mirroring.
- Seamless in-app locale switching without requiring application restarts.

---

## 📁 Project Structure

The project follows a scalable **Feature-First Architecture** with a strictly separated shared core:

```text
lib/
├── main.dart                           # App entry point & Firebase/Slang initialization
├── firebase_options.dart               # Generated Firebase configuration
├── generated/                          # Generated code (assets, tokens, i18n)
│   ├── app_image.dart                  # Strongly-typed asset references
│   ├── generate_styles.dart            # Design system atom generator script
│   ├── style_atoms.dart                # Atomic typography and style definitions
│   └── i18n/                           # Slang generated translation classes
│       ├── translations.g.dart
│       ├── translations_en.g.dart
│       └── translations_ar.g.dart
└── apps/
    ├── core/                           # Shared core module
    │   ├── constants/                  # Global app constants
    │   ├── errors/                     # Unified AppException handling
    │   │   └── app_exception.dart
    │   ├── extensions/                 # BuildContext, num, and SnackBar extensions
    │   │   ├── context_extensions.dart
    │   │   ├── custom_snack_bar.dart
    │   │   └── num_extensions.dart
    │   ├── models/                     # Shared domain models
    │   │   └── doctor_model.dart
    │   ├── router/                     # Type-safe GoRouter configuration
    │   │   ├── app_router.dart
    │   │   ├── routes.dart
    │   │   └── routes.g.dart
    │   ├── services/                   # Core shared services
    │   │   ├── doctor_service.dart
    │   │   └── supabase_storage_service.dart
    │   ├── theme/                      # AppTheme, color palette, and styles
    │   │   └── app_theme.dart
    │   ├── utils/                      # Form validators & phone utilities
    │   │   ├── phone_utils.dart
    │   │   └── validators.dart
    │   └── widgets/                    # Reusable shared UI components
    │       ├── app_header_section.dart
    │       ├── app_icon_button.dart
    │       ├── app_search_bar.dart
    │       ├── doctor_avatar_placeholder.dart
    │       ├── doctor_image.dart
    │       ├── doctor_profile_card.dart
    │       ├── featured_doctor_section.dart
    │       └── section_header.dart
    └── features/                       # Feature modules (Feature-Driven)
        ├── admin/                      # Admin portal (Doctor management, Create/Edit Doctor, Settings)
        │   ├── data/                   # AdminDoctorModel, AdminDoctorService & specialty options
        │   └── presentation/           # AdminDoctorsScreen, CreateDoctorScreen & admin widgets
        ├── auth/                       # Authentication (Login, Signup, OTP, Reset Password)
        │   ├── data/                   # Auth service (Firebase/Google) & UserRole model
        │   └── presentation/           # Auth screens & specialized widgets
        ├── doctor_select_time/         # Appointment date & time slot selection
        │   ├── data/                   # Date options and time slot data models
        │   └── presentation/           # SelectTimeScreen, date selector & slot widgets
        ├── doctors/                    # Doctor search and doctor details screens
        │   └── presentation/           # FindDoctorsScreen & DoctorDetailsScreen
        ├── favourite_doctors/          # Saved/bookmarked doctors feature
        │   └── presentation/           # FavouriteDoctorsScreen & FavouriteDoctorCard
        ├── home/                       # Home dashboard, banners, and categories
        │   ├── data/                   # Categories data & Firestore home service
        │   └── presentation/           # HomeScreen & dashboard modular widgets
        ├── onboarding/                 # Onboarding carousel & role selection
        │   ├── data/                   # Onboarding items & models
        │   └── presentation/           # OnboardingScreen
        └── profile/                    # User profile screen & personal info
            ├── data/                   # UserProfileModel & default profile data
            └── presentation/           # ProfileScreen & profile widgets
```

---

## 📦 Packages & Dependencies

| Category | Package | Purpose |
| :--- | :--- | :--- |
| **Routing & Navigation** | [`go_router`](https://pub.dev/packages/go_router) | Declarative, type-safe routing and deep linking |
| | [`go_router_builder`](https://pub.dev/packages/go_router_builder) | Code generation for compile-time typed routes |
| **Backend & Auth** | [`firebase_core`](https://pub.dev/packages/firebase_core) | Firebase initialization across platforms |
| | [`firebase_auth`](https://pub.dev/packages/firebase_auth) | User authentication, session management & password reset |
| | [`google_sign_in`](https://pub.dev/packages/google_sign_in) | Google OAuth social login integration |
| | [`cloud_firestore`](https://pub.dev/packages/cloud_firestore) | Real-time cloud database for doctor catalogs |
| **Cloud Storage** | [`supabase_flutter`](https://pub.dev/packages/supabase_flutter) | Supabase Storage integration for doctor media assets |
| **Media & Images** | [`image_picker`](https://pub.dev/packages/image_picker) | Multi-platform image selection from device gallery |
| | [`cached_network_image`](https://pub.dev/packages/cached_network_image) | High-performance remote image caching with placeholders |
| **Internationalization** | [`slang`](https://pub.dev/packages/slang) & [`slang_flutter`](https://pub.dev/packages/slang_flutter) | Type-safe, compile-time i18n with RTL support |
| | [`intl`](https://pub.dev/packages/intl) | Internationalization and date/number formatting |
| **UI Components** | [`pinput`](https://pub.dev/packages/pinput) | Customized PIN and OTP verification input field |
| | [`smooth_page_indicator`](https://pub.dev/packages/smooth_page_indicator) | Animated page indicators for onboarding flows |
| | [`easy_date_timeline`](https://pub.dev/packages/easy_date_timeline) | Interactive horizontal date timeline picker |
| | [`time_slot`](https://pub.dev/packages/time_slot) | Grid and card time slot selector |
| | [`skeletonizer`](https://pub.dev/packages/skeletonizer) | Shimmer loading skeleton overlays |
| **Maps & Location** | [`flutter_map`](https://pub.dev/packages/flutter_map) | Interactive OpenStreetMap rendering |
| | [`latlong2`](https://pub.dev/packages/latlong2) | Lightweight latitude/longitude coordinate utility |
| **Branding & Quality** | [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash) | Native splash screen configuration |
| | [`flutter_lints`](https://pub.dev/packages/flutter_lints) | Recommended static analysis lint rules |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.12.2` or later)
- [Dart SDK](https://dart.dev/get-dart)
- An IDE (VS Code, Android Studio, or IntelliJ IDEA) with Flutter and Dart plugins
- [Firebase CLI](https://firebase.google.com/docs/cli) *(optional, for custom Firebase configuration)*

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

## ⚙️ Code Generation & Tooling

This project leverages code generators for type-safe routing, localization, and design tokens:

- **Run all build runners (Routing & i18n)**:
  ```bash
  dart run build_runner build -d
  ```

- **Watch mode during active development**:
  ```bash
  dart run build_runner watch -d
  ```

- **Generate style atom tokens**:
  ```bash
  dart run lib/generated/generate_styles.dart
  ```

---

## 🧪 Testing & Quality Assurance

The codebase contains a comprehensive unit and widget test suite covering routing, authentication, home dashboard, appointment selection, favorite doctors, user profile, and internationalization:

- **Run automated test suite**:
  ```bash
  flutter test
  ```

- **Run static code analysis**:
  ```bash
  flutter analyze
  ```

---

## 📱 Running the Application

Launch Doctor Hunt on your connected emulator, simulator, or physical device:

```bash
# Run in debug mode (default target)
flutter run

# Run on a specific device or browser
flutter run -d chrome
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
