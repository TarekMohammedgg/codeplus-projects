<p align="center">
  <img src="assets/code-plus-logo.png" alt="Code Plus Software House" width="180"/>
</p>

<h1 align="center">Code Plus Software House</h1>

<p align="center">
  <strong>Flutter &amp; Dart Internship Projects &amp; Assignments</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.12+-0175C2.svg?logo=dart" alt="Dart" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT" /></a>
</p>

<p align="center">
  A structured repository containing the hands-on Dart lessons and full-scale Flutter applications<br/>
  developed during the <strong>Code Plus Software House</strong> internship program.
</p>

---

## 📌 Repository Branches & Roadmap

This repository is organized into dedicated branches for each phase of the internship:

| Branch | Description | Tech Stack | Direct Link |
| :--- | :--- | :--- | :--- |
| **[`dart-lessons`](https://github.com/TarekMohammedgg/codeplus-projects/tree/dart-lessons)** | Core Dart programming fundamentals, OOP concepts, collections, and asynchronous tasks (Lessons 01–04). | Dart 3.x | [View Branch ↗](https://github.com/TarekMohammedgg/codeplus-projects/tree/dart-lessons) |
| **[`doctor-hunt`](https://github.com/TarekMohammedgg/codeplus-projects/tree/doctor-hunt)** | Feature-First healthcare discovery & appointment mobile application with multi-language (EN/AR) support. | Flutter, GoRouter, Slang, Pinput | [View Branch ↗](https://github.com/TarekMohammedgg/codeplus-projects/tree/doctor-hunt) |

### Quick Branch Switching

```bash
# Clone the repository
git clone https://github.com/TarekMohammedgg/codeplus-projects.git
cd codeplus-projects

# Switch to the Dart Lessons branch
git checkout dart-lessons

# Switch to the Doctor Hunt Flutter Application branch
git checkout doctor-hunt
```

---

## ℹ️ Internship Details

| Property | Details |
| :--- | :--- |
| **Intern** | Tarek Mohammed |
| **Company** | Code Plus Software House |
| **Track** | Mobile Development (Flutter & Dart) |
| **Repository** | [`codeplus-projects`](https://github.com/TarekMohammedgg/codeplus-projects) |

---

## 📚 Branch 1: Dart Lessons Track (`dart-lessons`)

The [`dart-lessons`](https://github.com/TarekMohammedgg/codeplus-projects/tree/dart-lessons) branch contains structured assignments covering progressive Dart programming paradigms:

| Lesson | Script | Topics Covered |
| :---: | :--- | :--- |
| **01** | `lesson-1.dart` | Variables, primitive types, `const` vs `final`, null safety (`String?`), conditionals, string interpolation |
| **02** | `lesson-2.dart` | First-class functions, anonymous closures, arrow syntax (`=>`), higher-order functions |
| **03** | `lesson-3.dart` | Object-Oriented Programming (OOP), `Product` modeling, collection operations (filtering, mapping, reducing) |
| **04** | `lesson-4.dart` | Enhanced enums with properties & methods, asynchronous programming (`Future`, `async`/`await`, concurrency) |

### Running Dart Lessons

```bash
git checkout dart-lessons

dart run lesson-1.dart
dart run lesson-2.dart
dart run lesson-3.dart
dart run lesson-4.dart
```

---

## 🩺 Branch 2: Doctor Hunt Application (`doctor-hunt`)

The [`doctor-hunt`](https://github.com/TarekMohammedgg/codeplus-projects/tree/doctor-hunt) branch contains a production-ready Flutter UI for medical practitioner discovery and appointment management.

### Key Highlights & Features
- 🚀 **Onboarding & Role Selection**: Interactive multi-step carousel with animated indicators and role selection (Patient / Doctor).
- 🔐 **Authentication Workflows**: Sign-in, sign-up with client validation, OTP verification modal bottom sheets (`pinput`), and password resets.
- 🏠 **Home Dashboard**: Search bar, promotional health banners, medical specialty categories, and popular doctors carousel with favorite toggles.
- 👨‍⚕️ **Doctor Discovery & Profile**: Specialty search, category filtering, detailed doctor biographies, reviews, and appointment feedback.
- 🌐 **Full Internationalization (EN / AR)**: Multi-language support powered by `slang` with instant real-time locale switching and automatic RTL/LTR direction adjustments.
- 🧪 **Test Suite**: Automated unit and widget tests covering routing, UI components, localization, and search (`flutter test`).

### Running Doctor Hunt

```bash
git checkout doctor-hunt

# Install packages
flutter pub get

# Run code generator
dart run build_runner build -d

# Execute tests
flutter test

# Run application
flutter run
```

---

## 📂 Repository Architecture

```text
codeplus-projects/
├── 🌿 main              # Central project index, roadmap, and branch navigation
├── 🌿 dart-lessons      # Dart fundamentals, OOP, and asynchronous exercises (01–04)
└── 🌿 doctor-hunt       # Feature-First Flutter healthcare & appointment application
```

---

## 🏢 About Code Plus Software House

**Code Plus Software House** is a technology solutions provider specializing in modern mobile, web, and enterprise software engineering, empowering aspiring engineers through practical, industry-standard internship programs.

---

<p align="center">
  <sub>Code Plus Software House · Flutter &amp; Dart Internship</sub>
</p>
