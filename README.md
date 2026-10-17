<p align="center">
  <img src="https://cdn.jsdelivr.net/gh/TarekMohammedgg/codeplus-projects@f8d1f7d/assets/doctor-hunt-logo.png" alt="Doctor Hunt" width="280"/>
</p>

<p align="center">
  <a href="https://cdn.jsdelivr.net/gh/TarekMohammedgg/codeplus-projects@f8d1f7d/assets/demo/doctor-hunt-demo.mp4"><img src="https://cdn.jsdelivr.net/gh/TarekMohammedgg/codeplus-projects@f8d1f7d/assets/demo/doctor-hunt-preview.gif" alt="Doctor Hunt demo preview" width="240"/></a>
</p>

<p align="center">
  <a href="https://cdn.jsdelivr.net/gh/TarekMohammedgg/codeplus-projects@f8d1f7d/assets/demo/doctor-hunt-demo.mp4"><img src="https://img.shields.io/badge/%E2%96%B6%20Watch%20the%20demo-1%3A30-0EBE7E?style=for-the-badge" alt="Watch the demo"/></a>
  &nbsp;
  <a href="https://github.com/TarekMohammedgg/codeplus-projects#readme"><img src="https://img.shields.io/badge/%F0%9F%93%98%20Start%20here-main%20README-222B45?style=for-the-badge" alt="Start at the main README"/></a>
</p>

> [!NOTE]
> ✅ **This branch is the final source code of Doctor Hunt.** New here? The [reviewer guide on `main`](https://github.com/TarekMohammedgg/codeplus-projects#-start-here-reviewer-guide) walks through the code step by step.

# Doctor Hunt 🩺

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2.svg?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFA611.svg?logo=firebase)](https://firebase.google.com)
[![State](https://img.shields.io/badge/State-flutter__bloc%20(Cubit)-6A1B9A.svg)](https://pub.dev/packages/flutter_bloc)
[![Branch](https://img.shields.io/badge/branch-doctor--hunt--bloc-informational.svg)](https://github.com/TarekMohammedgg/codeplus-projects/tree/doctor-hunt-bloc)

**Doctor Hunt** is a clinic appointment app built with Flutter. One app, two roles
(**Patient** and **Admin**), one clinic. Patients find a doctor, book a free slot,
manage the booking and rate the doctor after the visit. The admin manages
doctors, their working hours, appointments and the clinic location.

```text
Find Doctor → Doctor Details → Book Slot → Manage Booking → Rate Doctor
```

---

## 📌 About this branch

`doctor-hunt-bloc` is the **current, active** version of Doctor Hunt. It rebuilds the
earlier [`doctor-hunt`](https://github.com/TarekMohammedgg/codeplus-projects/tree/doctor-hunt)
branch around the locked MVP scope:

| | `doctor-hunt` (earlier) | `doctor-hunt-bloc` (this branch) |
| :--- | :--- | :--- |
| State management | `setState` / services in widgets | `flutter_bloc` Cubits + `get_it` DI |
| Layers | Screens call Firebase directly | `Screen → Cubit → Repository → Service → Firestore` |
| Feature folders | Flat (`home`, `doctors`, …) | Split by role: `common/`, `patient/`, `admin/` |
| Booking | UI-only time slots | Real slots from doctor availability, locked per slot (no double booking) |
| Appointments & reviews | — | Upcoming / Completed / Cancelled, rate after completion |
| Admin | Create / edit doctors | Doctors, availability, appointments, clinic location, activate/deactivate |

---

## ✨ Features

### 🧑 Patient
- **Auth** — sign up, login, Google Sign-In, forgot / reset password.
- **Home** — greeting with avatar, search, specialty chips, **Popular** (most reviews)
  and **Top Rated** (highest rating) doctors with *See All*.
- **Doctors** — search by name, filter by specialty, favorites filter. Each card shows
  image, name, specialty, rating + count, fee, heart and *Book Now*.
- **Doctor details** — photo, fee, `4.7 · 24 Reviews` summary, recent reviews,
  available slots and the live clinic location on a map.
- **Booking (4 steps)** — pick a date from the doctor's working days → pick a free slot →
  review → confirm. The slot is locked in a Firestore transaction so two patients
  can never book the same time.
- **Appointments** — Upcoming (cancel), Completed (rate doctor), Cancelled (view only).
- **Rate doctor** — 1–5 stars + optional comment, one review per completed appointment.
  The review and the doctor's rating average are written in one transaction.
- **Profile & settings** — edit photo, name, phone, date of birth, gender; change password,
  notifications toggle, Arabic / English, logout.

### 🛡️ Admin
- **Doctors list** — total / active counters, search and specialty filter.
- **Create / edit doctor** — photo (uploaded to Cloudinary), bilingual name, specialty, fee.
- **Availability** — working days, start / end time, slot duration. This is what
  generates the patient's bookable slots.
- **Activate / deactivate** — doctors are never deleted, so booking history stays intact.
  Patients only see active doctors.
- **Appointments** — tabs All / Upcoming / Completed / Cancelled; cancel or mark completed.
  Details include the patient's contact info.
- **Profile** — photo, name, and the **clinic location** used by every doctor.

### 🌐 Common
- Onboarding → choose role (Patient / Admin).
- Full **Arabic (RTL)** and **English (LTR)** support with in-app switching (`slang`).

---

## 🏗️ Architecture

```text
Screen  →  Cubit  →  Repository  →  Service  →  Firestore / Firebase Auth / Cloudinary
```

```text
lib/
├── main.dart                      # Firebase, dotenv, DI and slang init
├── generated/                     # Asset refs + slang i18n output
└── apps/
    ├── core/
    │   ├── di/injection.dart      # get_it registrations
    │   ├── router/                # go_router + go_router_builder typed routes
    │   ├── models/                # Doctor, Appointment, Review, Clinic, Specialty, Availability
    │   ├── services/              # Firestore services shared by both roles
    │   ├── utils/                 # slot_generator, rating_utils, doctor_sort, validators…
    │   ├── theme/                 # AppTheme
    │   └── widgets/               # Reusable UI (buttons, fields, cards, dialogs, empty states)
    └── features/
        ├── common/                # onboarding, role_selection, auth, shell, appointment_details
        ├── patient/               # home, find_doctors, doctor_details, doctor_booking,
        │                          # favorites, appointments, rate_doctor, profile
        └── admin/                 # doctors, create_doctor, doctor_details, availability,
                                   # appointments, profile, settings
```

Every feature follows the same layout:

```text
<feature>/
├── data/          models/ · service/ · repositories/
└── presentation/  controller/cubit/ · screens/ · widgets/
```

### Firestore model

| Collection | Purpose |
| :--- | :--- |
| `users/{uid}` | Profile + `role` (`patient` / `admin`) |
| `users/{uid}/favorites/{doctorId}` | Per-patient favorites |
| `doctors/{id}` | Bilingual name, specialty, fee, image, `isActive`, `rating`, `reviewsCount`, `availability` |
| `clinic/settings` | Clinic address + `GeoPoint` (single source of truth) |
| `appointments/{id}` | Patient + doctor snapshot, `startAt`, `status` (`upcoming` / `completed` / `cancelled`) |
| `bookedSlots/{doctorId_yyyyMMddHHmm}` | Slot lock — prevents double booking |
| `reviews/{appointmentId}` | Rating 1–5 + comment, one per appointment |

Access rules live in [`firestore.rules`](firestore.rules).

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) with Dart `^3.12.2`
- A Firebase project with **Authentication** (Email/Password + Google) and **Cloud Firestore**
- [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) and [Firebase CLI](https://firebase.google.com/docs/cli)
- A [Cloudinary](https://cloudinary.com) account with an **unsigned** upload preset (doctor photos)

### 1. Clone and install

```bash
git clone https://github.com/TarekMohammedgg/codeplus-projects.git
cd codeplus-projects
git checkout doctor-hunt-bloc
flutter pub get
```

### 2. Connect Firebase

`lib/firebase_options.dart` and `android/app/google-services.json` are not committed.
Generate them for your own Firebase project:

```bash
flutterfire configure
```

Then deploy the security rules:

```bash
firebase deploy --only firestore:rules
```

### 3. Environment variables

Copy `.env.example` to `.env` and fill it in:

```dotenv
SERVER_CLIENT_ID=your_google_web_client_id
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_UPLOAD_PRESET=your_unsigned_upload_preset
```

> Never put a Cloudinary API secret in the app. Only the unsigned preset is used.

### 4. Create the admin account

There is no admin sign-up (by design). Create the user in **Firebase Authentication**,
then set `role: "admin"` on its `users/{uid}` document in Firestore.

### 5. Generate code and run

```bash
dart run build_runner build -d
flutter run
```

---

## 🧪 Tests & quality

```bash
flutter analyze
flutter test
```

The suite covers the core logic (slot generation, rating aggregate, doctor sorting,
validators, models), cubits for every main feature, and widget tests for key screens.

---

## 📦 Main packages

| Purpose | Package |
| :--- | :--- |
| State management | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) |
| Dependency injection | [`get_it`](https://pub.dev/packages/get_it) |
| Routing | [`go_router`](https://pub.dev/packages/go_router) + [`go_router_builder`](https://pub.dev/packages/go_router_builder) |
| Backend | [`firebase_auth`](https://pub.dev/packages/firebase_auth), [`cloud_firestore`](https://pub.dev/packages/cloud_firestore), [`google_sign_in`](https://pub.dev/packages/google_sign_in) |
| i18n | [`slang`](https://pub.dev/packages/slang) + [`slang_flutter`](https://pub.dev/packages/slang_flutter), [`intl`](https://pub.dev/packages/intl) |
| Images | [`image_picker`](https://pub.dev/packages/image_picker), [`dio`](https://pub.dev/packages/dio) (Cloudinary upload), [`cached_network_image`](https://pub.dev/packages/cached_network_image) |
| Booking UI | [`easy_date_timeline`](https://pub.dev/packages/easy_date_timeline), [`time_slot`](https://pub.dev/packages/time_slot) |
| Map | [`flutter_map`](https://pub.dev/packages/flutter_map) + [`latlong2`](https://pub.dev/packages/latlong2) |
| UI helpers | [`skeletonizer`](https://pub.dev/packages/skeletonizer), [`smooth_page_indicator`](https://pub.dev/packages/smooth_page_indicator), [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash) |
| Config | [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv), [`shared_preferences`](https://pub.dev/packages/shared_preferences) |

---

## 🚫 Out of scope (MVP)

Doctor app / login, per-doctor locations, payments, chat, online consultation,
medical records, admin analytics and admin roles are intentionally **not** part of
this version.

---

<p align="center">
  <sub>Built by Tarek Mohammed · Code Plus Software House internship</sub>
</p>
