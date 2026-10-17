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
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFA611.svg?logo=firebase" alt="Firebase" /></a>
</p>

<p align="center">
  Hands-on Dart lessons and a full Flutter application built during the<br/>
  <strong>Code Plus Software House</strong> internship program.
</p>

<p align="center">
  <a href="#-repository-branches">Branches</a> ·
  <a href="#-how-to-use-doctor-hunt">How to use Doctor Hunt</a> ·
  <a href="#-run-it-locally">Run it locally</a> ·
  <a href="#-dart-lessons">Dart lessons</a>
</p>

---

## 🌿 Repository Branches

Each phase of the internship lives in its own branch. `main` is the index you are reading now.

| Branch | Status | What's inside | Tech |
| :--- | :---: | :--- | :--- |
| **[`doctor-hunt-bloc`](https://github.com/TarekMohammedgg/codeplus-projects/tree/doctor-hunt-bloc)** | ✅ **Current** | Doctor Hunt MVP — patient booking + admin clinic management, rebuilt with Cubits and clean layers. | Flutter, `flutter_bloc`, `get_it`, Firebase Auth & Firestore, Cloudinary, GoRouter, Slang |
| [`doctor-hunt`](https://github.com/TarekMohammedgg/codeplus-projects/tree/doctor-hunt) | 🗄️ Earlier | First version of Doctor Hunt (UI-first, services called from widgets). Kept for history. | Flutter, Firebase, GoRouter, Slang |
| [`dart-lessons`](https://github.com/TarekMohammedgg/codeplus-projects/tree/dart-lessons) | 📚 Done | Dart fundamentals, OOP, collections and async (Lessons 01–04). | Dart 3.x |

```bash
git clone https://github.com/TarekMohammedgg/codeplus-projects.git
cd codeplus-projects

git checkout doctor-hunt-bloc   # current Doctor Hunt app
git checkout dart-lessons       # Dart lessons
```

---

## 🩺 Doctor Hunt

**Doctor Hunt** is a clinic appointment app: one app, two roles (**Patient** and **Admin**),
one clinic. It follows a single patient journey:

```text
Find Doctor → Doctor Details → Book Slot → Manage Booking → Rate Doctor
```

- 👤 **Patients** search doctors, book a free time slot, cancel or track their booking,
  and rate the doctor after the visit.
- 🛡️ **The admin** adds doctors, sets their working hours, manages appointments and sets
  the clinic location shown for every doctor.
- 🌐 Full **Arabic (RTL)** and **English** support, switchable inside the app.

---

## 🎬 How to Use Doctor Hunt

### Demo video

<!--
  VIDEO PLACEHOLDER — replace when the video is ready.
  YouTube: swap VIDEO_ID in both URLs below:
    [![Doctor Hunt demo](https://img.youtube.com/vi/VIDEO_ID/hqdefault.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)
  GitHub upload: edit this file on github.com and drag the .mp4 here instead.
-->
<p align="center">
  <a href="#demo-video">
    <img src="https://img.shields.io/badge/%E2%96%B6%20Demo%20video-coming%20soon-1C6BA4?style=for-the-badge" alt="Doctor Hunt demo video (coming soon)" />
  </a>
</p>

| Chapter | Time |
| :--- | :---: |
| Onboarding & choosing a role | `00:00` |
| Patient: sign up / login | `--:--` |
| Patient: find a doctor & book a slot | `--:--` |
| Patient: manage & rate an appointment | `--:--` |
| Admin: add a doctor & set availability | `--:--` |
| Admin: manage appointments & clinic location | `--:--` |

### 1. First launch

1. Open the app and swipe through the onboarding, or tap **Skip**.
2. Tap **Get Started** and choose your role: **Patient** or **Admin**.

### 2. Using the app as a Patient

The patient app has four tabs: **Home · Doctors · Appointments · Profile**.

**Sign in**
1. Choose **Sign Up** to create an account, or **Login** with email / password.
2. You can also continue with **Google**.
3. Forgot your password? Tap **Forgot Password** and follow the email link.

**Find a doctor**
1. On **Home**, browse **Popular** (most reviewed) and **Top Rated** doctors,
   tap a specialty chip, or use the search bar.
2. Open the **Doctors** tab to search by name, filter by specialty, or show only your ❤️ favorites.
3. Tap the heart on any doctor card to add / remove a favorite.

**Book an appointment**
1. Tap a doctor to open **Doctor Details** — fee, rating, recent reviews, available slots
   and the clinic location.
2. Tap **Book Now**.
3. **Pick a date** — only the doctor's working days are shown.
4. **Pick a time slot** — already booked slots are hidden.
5. **Review** the doctor, date, time, fee and clinic location.
6. Tap **Confirm**. Your appointment is created as **Upcoming**.

**Manage your appointments** (Appointments tab)

| Tab | What you can do |
| :--- | :--- |
| **Upcoming** | See the booking details or **Cancel** it |
| **Completed** | **Rate Doctor** — 1 to 5 stars + optional comment (once per visit) |
| **Cancelled** | View only |

**Profile & settings**
- Edit your photo, name, phone, date of birth and gender.
- In **Settings**: change password, turn notifications on/off, switch **Arabic / English**, and log out.

### 3. Using the app as an Admin

> There is no admin sign-up. The admin account is created by the clinic owner
> (see [Run it locally](#-run-it-locally)).

1. Choose **Admin** and log in with email and password.
2. **Doctors list** — see total / active counters, search, and filter by specialty.
3. **Add a doctor** — tap add, then set the photo, name (Arabic & English), specialty and fee.
4. **Set availability** — open the doctor → **Availability** → choose working days,
   start / end time and slot duration. Patients can only book once this is saved.
5. **Activate / Deactivate** — hide a doctor from patients without losing their booking history.
6. **Appointments** — switch between All / Upcoming / Completed / Cancelled.
   For upcoming visits, tap **Mark Completed** after the visit (this unlocks rating)
   or **Cancel**. Open any appointment to see the patient's contact info.
7. **Profile** — update your photo, name, and the **clinic location**. The new location
   appears for every doctor immediately.
8. **Settings** — log out.

---

## 🚀 Run It Locally

```bash
git clone https://github.com/TarekMohammedgg/codeplus-projects.git
cd codeplus-projects
git checkout doctor-hunt-bloc
flutter pub get
```

1. **Firebase** — run `flutterfire configure` for your own Firebase project
   (Email/Password + Google auth, Cloud Firestore), then
   `firebase deploy --only firestore:rules`.
2. **Environment** — copy `.env.example` to `.env` and set `SERVER_CLIENT_ID`,
   `CLOUDINARY_CLOUD_NAME` and `CLOUDINARY_UPLOAD_PRESET` (unsigned preset).
3. **Admin account** — create a user in Firebase Authentication, then set
   `role: "admin"` on its `users/{uid}` document in Firestore.
4. **Generate code and run**:

```bash
dart run build_runner build -d
flutter run
```

Full setup, architecture and Firestore model: see the
[`doctor-hunt-bloc` README](https://github.com/TarekMohammedgg/codeplus-projects/tree/doctor-hunt-bloc#readme).

---

## 📚 Dart Lessons

The [`dart-lessons`](https://github.com/TarekMohammedgg/codeplus-projects/tree/dart-lessons)
branch holds the Dart assignments:

| Lesson | Script | Topics |
| :---: | :--- | :--- |
| **01** | `lesson-1.dart` | Variables, types, `const` vs `final`, null safety, conditionals, string interpolation |
| **02** | `lesson-2.dart` | Functions, closures, arrow syntax, higher-order functions |
| **03** | `lesson-3.dart` | OOP, `Product` modeling, collection operations |
| **04** | `lesson-4.dart` | Enhanced enums, `Future`, `async` / `await` |

```bash
git checkout dart-lessons
dart run lesson-1.dart
```

---

## ℹ️ Internship Details

| | |
| :--- | :--- |
| **Intern** | Tarek Mohammed |
| **Company** | Code Plus Software House |
| **Track** | Mobile Development (Flutter & Dart) |

---

<p align="center">
  <sub>Code Plus Software House · Flutter &amp; Dart Internship</sub>
</p>
