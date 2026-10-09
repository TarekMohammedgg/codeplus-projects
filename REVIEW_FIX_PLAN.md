# Doctor Hunt — Fix Plan (strict scope)

Baseline (2026-10-07, branch `doctor-hunt-bloc`): `flutter analyze` = 0 issues, `flutter test` = 324 passed.
The baseline must still be true at the end of every step.

---

## 0. Rules for the implementer (read before doing anything)

**You may change ONLY what this file lists.** Each step names its files and its exact change. If something is not written
here, it is out of scope, even if it looks wrong, even if it is in the same file, even if a rule in `AGENTS.md` or the skill
says it should be fixed.

### Hard rules
1. **Do only the listed items.** No extra refactors, renames, reformatting of untouched code, "while I'm here" fixes,
   new features, new screens, or new abstractions beyond the ones named here.
2. **Do not change how the app looks** except where a step says "visible change: …". When you replace a private widget
   with a shared one, its paddings, sizes, radius, colors, shadow, and text styles must stay the same. If they differ and
   the step does not say how to handle it, **leave that call site unchanged** and write it in your report.
3. **Do not add packages.** Do not edit `pubspec.yaml`.
4. **Do not touch Trello and do not run git commands that change state** (no commit, push, branch, reset, stash, checkout).
   Tarek commits.
5. **Do not delete or edit any `//CR` or `// solved` / `// Solved` comment line.** If code you delete has a `//CR` comment
   directly above it, stop and ask Tarek.
6. Do not edit generated files (`*.g.dart`, `lib/generated/**`) by hand. After you change routes or translations, run
   `dart run build_runner build -d`.
7. Every new user-facing string goes in BOTH `assets/translation/en.json` and `assets/translation/ar.json`.
8. When a step removes an injected constructor parameter from a screen (`cubit`, `repository`, `clinicService`, …),
   update the tests of that screen so they provide the Cubit with `BlocProvider.value(...)` or register fakes in `getIt`.
   Use only the existing hand-written fakes in `test/helpers/test_fakes.dart` (add new fakes there if needed).
   `mocktail` / `bloc_test` are not installed, so do not use them.
9. **Stop and report instead of guessing** if: a test fails and the fix would need a change outside this file's scope;
   a value you must replace has no identical shared equivalent; or an instruction is unclear.
10. Do the steps **in order**. After EACH step, run the 4 commands below, fix only what your step broke, then write a short
    report (files changed, test result, anything skipped and why) and continue to the next step.

```bash
dart format lib test
```
```bash
dart run build_runner build -d
```
```bash
flutter analyze
```
```bash
flutter test
```

### Explicitly OUT of scope (do NOT touch, even if you notice them)
- Patient bottom tabs (Favorites vs Doctors), the side menu drawer, the Privacy Policy screen, `shared_preferences`.
- The global `tr` vs `context.tr` usage, except inside code you are already rewriting in a step.
- Raw `Colors.*` uses, except the AppBar props that Step 3.3 deletes.
- Localization inside models / `AppException` / validators / `auth_state.dart` / `onboarding_data.dart`.
- `DoctorModel.accentColorHex`, the `DoctorAccentColor` extension, and the legacy-field fallbacks in `DoctorModel.fromFirestore`.
- Other hardcoded strings not listed in Step 2.3 (e.g. `'Patient'` in `rate_doctor_repository.dart`, `'Not set'` and `' min'` in `doctor_availability.dart`).
- Cubits that call a service instead of a repository (e.g. `AdminDoctorDetailsCubit`), the folder `rate_doctor/presentation/cubit/`,
  state classes living in cubit files, empty folders, test folder locations.
- Screens that create their Cubit with `getIt<XCubit>()` without a `??` fallback (`rate_doctor_screen.dart`, `doctor_booking_screen.dart`).
- `firestore.rules`, Firebase data, `AGENTS.md`, `workflow.md`.

---

## Step order

| Step | Topic | Risk |
|---|---|---|
| 1 | Shared helpers: locale, date/time, fee | low |
| 2 | Hardcoded strings + magic strings + gender bug | low |
| 3 | Reuse existing widgets: snackbars, back/pop, AppBar | low |
| 4 | Duplicated widgets → one shared widget each | medium |
| 5 | Layers / DI: no services or `FirebaseAuth` in screens, no `?? getIt` | medium |
| 6 | Swallowed errors `catch (_)` | low |
| 7 | `AdminDoctorModel` / `AdminDoctorService` → `DoctorModel` / `DoctorService` | HIGH, last |

---

## Step 1: Shared helpers (locale, date/time, fee)

### 1.1 One way to read the locale
Today the locale is read 4 ways: `LocaleSettings.currentLocale.languageCode`, `TranslationProvider.of(context).translations.$meta.locale.languageCode`,
`context.tr.$meta.locale.languageCode`, `Localizations.localeOf(context)`.

**Do:** add to `lib/apps/core/extensions/context_extensions.dart`:
```dart
String get localeCode => TranslationProvider.of(this).translations.$meta.locale.languageCode;
```
(import `package:doctor_hunt/generated/i18n/translations.g.dart`). Then, **in presentation files only**, replace the
"language code for formatting" reads with `context.localeCode`:
`patient_appointment_card.dart:36`, `patient_appointment_details_screen.dart:152`, `doctor_details_sections.dart:70`,
`profile_screen.dart:70-72`, `edit_profile_screen.dart:189`, `time_slots_section.dart:35-37`, `date_selector_list.dart:34-36`,
`booking_success_dialog.dart:25`, `admin_appointment_card.dart:38`, `admin_doctor_details.dart:134`,
`admin_appointment_details_screen.dart:172`, `booking_review_screen.dart:66`, `doctor_booking_screen.dart:97-99`.

**Do NOT change:** models (`*_model.dart`, `doctor_availability.dart`), `app_header_section.dart:99`, and
`patient_settings_screen.dart:108`. Those last two read `AppLocale` to switch language, which is a different purpose.

### 1.2 Date / time / fee formatters
Create `lib/apps/core/utils/formatters.dart` with exactly:
```dart
import 'package:intl/intl.dart';

final _usd = NumberFormat.simpleCurrency(locale: 'en', name: 'USD');

/// "$28.00"
String formatFee(num fee) => _usd.format(fee);

/// "$" (for UIs that style the symbol and the amount separately)
String get feeCurrencySymbol => _usd.currencySymbol;

/// "28.00"
String formatFeeAmount(num fee) =>
    NumberFormat.decimalPatternDigits(locale: 'en', decimalDigits: 2).format(fee);

/// "07 Oct 2026" (the format used by the Figma appointment cards)
String formatDate(DateTime date, String locale) =>
    DateFormat('dd MMM yyyy', locale).format(date);

/// "09:00 AM"
String formatTime(DateTime date, String locale) =>
    DateFormat('hh:mm a', locale).format(date);
```

**Replace fee formatting** (`'\$${x.toStringAsFixed(n)}'`) with `formatFee(x)` in:
`find_doctors_widgets.dart:132`, `patient_appointment_card.dart:125`, `booking_review_screen.dart:101`,
`admin_appointment_card.dart:133`, `admin_appointment_details_screen.dart:346`, `admin_doctor_details.dart:335`,
`patient_appointment_details_screen.dart:244,290`.
In `doctor_profile_card.dart:~392-402`, the `$` and the amount are two styled `TextSpan`s. Keep both spans and their styles; use
`'$feeCurrencySymbol '` and `formatFeeAmount(doctor.consultationFee)`.
Visible change: `patient_appointment_details_screen` shows `$28.00` instead of `$28`. This is intended.
**Do NOT touch** `create_doctor_screen.dart:83-84 _formatFee` (it fills an input field) or any `rating.toStringAsFixed(1)`.

**Replace appointment date/time formatting** with `formatDate(x, context.localeCode)` / `formatTime(x, context.localeCode)` in:
`patient_appointment_card.dart:102-116`, `admin_appointment_card.dart:111-125`, `admin_appointment_details_screen.dart:173-180`,
`patient_appointment_details_screen.dart:153-154`, `booking_review_screen.dart:67-68`, `rate_doctor_screen.dart:146-147`
(it currently passes no locale), `booking_success_dialog.dart:53` (time only, keep its `MMMMd` date, which is inside a sentence).
**Replace date of birth formatting** with `formatDate` in `profile_screen.dart:74-82` and `edit_profile_screen.dart:190-197`, and
delete their `try { … } catch (_) { …'en'… }` fallbacks (`main.dart` already calls `initializeDateFormatting()`).
Visible change: these screens now show `07 Oct 2026` / `09:00 AM`. This is intended.
**Do NOT touch:** `slot_generator.dart` (data keys), `date_selector_list.dart` / `doctor_booking_screen.dart` day labels (Step 4.2),
`time_slots_section.dart:59` (slot chips), `doctor_details_sections.dart:94` (review date), and `doctor_availability.dart`.

**Test:** add `test/apps/core/utils/formatters_test.dart` (comments `// arrange`, `// act`, `// assert`) covering `formatFee(28)` → `$28.00`,
`formatFeeAmount(28)` → `28.00`, `formatDate`, and `formatTime` with locale `'en'`.

---

## Step 2: Hardcoded strings, magic strings, gender bug

### 2.1 Hardcoded text (closed list, only these)
| Where | Now | Change to |
|---|---|---|
| `admin_appointment_details_screen.dart:238,245` | `'-'` | `context.tr.notSet` (key exists) |
| `date_selector_list.dart:82,90` | `'...'` | new key `loadingEllipsis` (en `"..."`, ar `"..."`) |
| `create_doctor_screen.dart:222` | `'${tr.doctorNameLabel} (AR)'` | new key `doctorNameArLabel` (en `"Doctor Name (AR)"`, ar `"اسم الطبيب (عربي)"`) |
| `create_doctor_screen.dart:231` | `'${tr.doctorNameLabel} (EN)'` | new key `doctorNameEnLabel` (en `"Doctor Name (EN)"`, ar `"اسم الطبيب (إنجليزي)"`) |
| `admin_profile_screen.dart:208` | `'Error'` | `context.tr.unexpectedError` (key exists) |
| `doctor_availability_screen.dart:88-97` | `'Mon'..'Sun'` map in `catch` | deleted in Step 4.2 |
| `doctor_availability.dart:66-84` | `enDays` / `arDays` maps + `catch` | deleted in Step 4.2 |

### 2.2 Magic strings
| Where | Now | Change to |
|---|---|---|
| `patient_settings_screen.dart:44` | `'password'` | `EmailAuthProvider.PROVIDER_ID` (from `firebase_auth`, already installed). Step 5.4 moves this line. |
| `admin_profile_cubit.dart:106-107`, `admin_profile_screen.dart:206` | `'requires-recent-login'` | add `enum AdminProfileFailure { requiresRecentLogin, unknown }` in `admin_profile_state.dart`; the state gets `AdminProfileFailure? failure` (keep `errorMessage` for other errors). The Cubit sets `failure: AdminProfileFailure.requiresRecentLogin` when `e.code == 'requires-recent-login'` (comparing the Firebase code once, inside the Cubit, is allowed). The screen checks `state.failure == AdminProfileFailure.requiresRecentLogin`. |
| `auth_service.dart:148` | `'role': 'patient'` | `'role': UserRole.patient.name` (`lib/apps/features/common/role_selection/data/models/user_role.dart`) |
| `auth_service.dart:162` | `== 'admin'` | `== UserRole.admin.name` |
| `edit_profile_screen.dart:52,86,374,375,383,384` | `'male'` / `'female'` | `Gender` enum (2.3) |

### 2.3 Gender enum + the untranslated-gender bug
Bug: `profile_screen.dart:85-88` shows the raw stored value (`male`) instead of a translated label.

**Do:**
1. In `lib/apps/features/patient/profile/data/models/user_profile_model.dart` add `enum Gender { male, female }`.
   Change the field to `final Gender? gender;`. Parse it with `Gender.values.asNameMap()[(data['gender'] as String?)?.trim().toLowerCase()]`.
   Write it as `gender?.name`. Update `copyWith`.
2. Keep `ProfileService` / `ProfileRepository` `String? gender` params unchanged. Callers pass `gender?.name`.
3. `edit_profile_screen.dart`: `Gender _selectedGender = Gender.male;` init from `profile?.gender ?? Gender.male`; comparisons use the enum.
4. `profile_screen.dart:85-88`: `switch (profile.gender) { Gender.male => tr.male, Gender.female => tr.female, null => tr.notSet }`
   (keys `male`, `female`, `notSet` already exist).
5. Fix any test that builds `UserProfileModel(gender: 'male')` to use `Gender.male`.

---

## Step 3: Use the existing widgets (snackbars, pop, AppBar)

### 3.1 Raw `SnackBar` → existing extension
`lib/apps/core/extensions/custom_snack_bar.dart` already has `context.showSuccessSnackBar(msg)` / `context.showErrorSnackBar(msg)`.
Replace every `ScaffoldMessenger.of(context).showSnackBar(SnackBar(...))` (success = primary background, error = error background) in:
`rate_doctor_screen.dart:96-110`, `change_password_screen.dart:69-85`, `doctor_availability_screen.dart:119-125,146-152`,
`admin_profile_screen.dart:197-216`, `admin_doctor_details.dart:106-127`, `admin_appointment_details_screen.dart:99-164`,
`patient_appointment_details_screen.dart:123-145`, `patient_appointments_screen.dart:83-99`.
Keep the same message text. Visible change: these snackbars now use the app's standard snackbar design. This is intended.
Delete imports that become unused.

### 3.2 `_popScreen` + `catch (_) {}` → plain pop
`AppBackButton` already pops with `Navigator.maybePop` when `onTap` is null.
- Delete `_popScreen` in `admin_doctor_details.dart:56-64`, `doctor_availability_screen.dart:66-74`, `admin_profile_screen.dart:154-162`,
  and `rate_doctor_screen.dart:67-75`.
- Back buttons that called it → `AppBackButton.leading()` / `AppBackButton()` with no `onTap`.
- Places that pop after a successful action → `context.pop()` (go_router).
- In `admin_appointment_details_screen.dart:105-109,149-153,190-196` and `patient_appointment_details_screen.dart:129-133,162-168`,
  the `if (context.canPop()) context.pop(); else Navigator.maybePop()` blocks get the same treatment: back button → no `onTap`;
  after the action → `context.pop()`.
- **Keep unchanged:** `doctor_booking_screen.dart:49-55`, `patient_appointments_screen.dart:116`, `find_doctors_screen.dart:78`,
  `signup_screen.dart:288`, `change_password_screen.dart:60,75`. They fall back to a specific route, which is real behavior.

### 3.3 Repeated AppBar props that the theme already sets
`AppTheme.appBarTheme` (`app_theme.dart:~214-220`) already sets `backgroundColor: transparent`, `elevation: 0`,
`scrolledUnderElevation: 0`, `centerTitle: false`.
**Do:** in every `AppBar(...)` under `lib/apps/features/**`, delete ONLY those 4 props when their value equals the theme
(`backgroundColor: Colors.transparent` / `AppColors.transparent`, `elevation: 0`, `scrolledUnderElevation: 0`, `centerTitle: false`).
Files: `rate_doctor_screen.dart`, `patient_appointment_details_screen.dart`, `find_doctors_screen.dart`, `patient_appointments_screen.dart`,
`doctor_booking_screen.dart`, `booking_review_screen.dart`, `privacy_policy_screen.dart`, `patient_settings_screen.dart`,
`edit_profile_screen.dart`, `change_password_screen.dart`, `admin_doctor_details.dart`, `create_doctor_screen.dart`,
`admin_appointment_details_screen.dart`.
**Keep:** `centerTitle: true`, `leadingWidth`, `titleSpacing`, `title`, `leading`, `bottom`, `actions`. Do NOT add
`leadingWidth` / `titleSpacing` to the theme; that would move titles on screens that don't set them. Result: zero visual change.

---

## Step 4: Duplicated widgets → one shared widget each

### 4.1 `AppCard`: the repeated white card
The decoration `color: AppColors.surface` + `BorderRadius.circular(16)` + `BoxShadow(color: AppColors.shadowCard, blurRadius: 16, offset: Offset(0, 4))`
is written by hand many times.
**Create** `lib/apps/core/widgets/app_card.dart`:
```dart
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.onTap});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  // build: DecoratedBox(shadow + radius 16) > Material(color: AppColors.surface, borderRadius 16)
  //        > (onTap == null ? Padding(child) : InkWell(onTap, borderRadius 16, child: Padding(child)))
}
```
**Replace** only the sites whose radius = 16, blur = 16, offset = (0,4), and color = `shadowCard` (pass `padding` when it is not 16):
`patient_appointment_details_screen.dart:185-197, 256-268, 423-435`, `booking_review_screen.dart:144-156, 236-248`,
`admin_appointment_details_screen.dart:438-461` (`_DetailsCard`, padding 14, so delete the class), `patient_settings_screen.dart:132-144`.
`admin_settings_screen.dart:183-208` (`_SettingsCard`): replace with `AppCard(padding: EdgeInsets.zero, …)`. Its children already
have their own `InkWell` / `ListTile`, so keep them and delete `_SettingsCard`.
For any other card (e.g. `doctor_availability_screen.dart _AvailabilityCard`, `rate_doctor_screen.dart`, `admin_doctor_details.dart`,
`popular_doctor_section.dart`): replace it ONLY if all 4 values are identical. Otherwise leave it and list it in your report.

### 4.2 `_formatDayLabel` (2 copies) + weekday names (2 copies)
- `doctor_booking_screen.dart:90-112` and `date_selector_list.dart:27-49` are the same function.
  Keep ONE public top-level function `String formatBookingDayLabel(BuildContext context, DateTime date)` in `date_selector_list.dart`.
  Delete the copy in `doctor_booking_screen.dart` and call the shared one.
- Both copies build "Tomorrow" with `tr.tomorrow[0].toUpperCase()…`. Change `"tomorrow": "tomorrow"` in `en.json` to `"Tomorrow"`.
  First grep every `tr.tomorrow` / `context.tr.tomorrow` use; if another place needs the lowercase word, STOP and report.
  Then delete the manual capitalization.
- Weekday names: in `lib/apps/core/models/doctor_availability.dart` add
  `static String weekdayName(int weekday, String locale, {bool short = true}) { final d = DateTime(2026, 9, 27 + weekday); return (short ? DateFormat.E(locale) : DateFormat.EEEE(locale)).format(d); }`
  (2026-09-28 is a Monday). In `formatSummary` (`:64-107`), use it and delete the `enDays` / `arDays` maps and the `try/catch`
  (keep `'Not set'` and `' min'` as they are). Pass `locale ?? 'en'`.
  In `doctor_availability_screen.dart:80-99`, delete `_formatDayName` and call
  `DoctorAvailability.weekdayName(weekday, context.localeCode, short: false)`.

### 4.3 Booking review vs patient appointment details: 3 exact copies
- `_InfoRow` (`booking_review_screen.dart:187-217`) is the same widget as `_DetailRow` (`patient_appointment_details_screen.dart:377-407`).
  → **create** `lib/apps/core/widgets/appointment_detail_row.dart` (`AppointmentDetailRow`, same code). Delete both private classes.
- `_BookingInfoCard` (`booking_review_screen.dart:131-185`) is the same widget as the "Booking Details Card" block (`patient_appointment_details_screen.dart:256-310`).
  → **create** `lib/apps/core/widgets/appointment_summary_card.dart`:
  `AppointmentSummaryCard({required String date, required String time, required String fee, List<Widget> extraRows = const []})`,
  built with `AppCard` + 3 `AppointmentDetailRow` + the same `Divider`s. The patient details "cancelled by" row is passed in `extraRows`
  (each extra row gets the same `12 / Divider / 12` spacing in front). Use it in both screens.
- `_ClinicLocationCard` (`booking_review_screen.dart:219-282`) is the same widget as `_LiveClinicLocationCard` (`patient_appointment_details_screen.dart:409-472`).
  → **create** `lib/apps/core/widgets/clinic_location_card.dart`: `ClinicLocationCard({required ClinicModel? clinic})`, with the same
  body, but WITHOUT the `StreamBuilder` (the caller passes the current clinic). Each screen wraps it in its existing
  `StreamBuilder<ClinicModel?>`, until Step 5.2 moves the stream into a Cubit. Delete both private classes.
  It imports `ClinicLocationMap`. Move `lib/apps/features/patient/doctor_details/presentation/widgets/clinic_location_map.dart`
  to `lib/apps/core/widgets/clinic_location_map.dart` and fix its imports (it is now used by 3 features).
- Do **not** touch `ClinicLocationSection` in `doctor_details_sections.dart` (different design).
- Move `lib/apps/features/patient/appointments/presentation/widgets/appointment_status_chip.dart` to `lib/apps/core/widgets/`
  (admin imports it from the patient feature: `admin_appointment_details_screen.dart:19`). Fix the imports. No code change.

### 4.4 Confirm dialogs: one function
- `lib/apps/core/widgets/app_logout_dialog.dart` `showLogoutConfirmDialog` is a copy of `showAppConfirmDialog` (`app_confirm_dialog.dart`).
  Add 2 optional params to `showAppConfirmDialog`: `TextStyle? titleStyle` (default `context.semiBold16TextMain`) and
  `TextStyle? cancelTextStyle` (default `context.medium14TextSecondary`). Then make `showLogoutConfirmDialog` one call:
  `showAppConfirmDialog(context, title: context.tr.logOutConfirmTitle, message: context.tr.logOutConfirmMessage, confirmLabel: context.tr.ok, titleStyle: context.bold24TextMain, cancelTextStyle: context.semiBold14)`.
  The logout dialog's cancel button is currently the default `AppTextButton` style, which is `semiBold14` in primary color. Pass
  `cancelTextStyle: context.semiBold14`, and make `showAppConfirmDialog` give the cancel button `foregroundColor: AppColors.primary`
  only when `cancelTextStyle` is passed. Verify the logout dialog looks the same as before.
- Replace the hand-built `showDialog(... AlertDialog(...))` with `showAppConfirmDialog(...)` (same title, message, confirm label, confirm color) in:
  `patient_appointments_screen.dart:48-75` (`confirmColor: AppColors.error`), `patient_appointment_details_screen.dart:87-113`
  (`confirmColor: AppColors.error`), `admin_doctor_details.dart:81-102` (`confirmColor: targetActive ? AppColors.primary : AppColors.error`),
  and `admin_doctors_screen.dart:~76-100` (read it, then copy its title/message/label/color). `showAppConfirmDialog` returns `bool`,
  so change `confirmed == true` to `confirmed`.

### 4.5 Favorite heart: 3 copies
The heart (`Icons.favorite_rounded` / `favorite_border_rounded`, color `AppColors.favorite` / `AppColors.disabled`) is built in
`doctor_profile_card.dart:356-372`, `find_doctors_widgets.dart:76-89`, and `popular_doctor_section.dart:~118-150`.
**Create** `lib/apps/core/widgets/favorite_heart_icon.dart`: `FavoriteHeartIcon({required bool isFavorite, required double size})`, which
returns just the `Icon`. Use it inside each existing `GestureDetector` / container. Keep each card's own tap area, padding, size
(20 / 22 / 16), and the Popular card's white circle. Only the duplicated icon logic moves.

### 4.6 Image picker: 3 copies
`edit_profile_screen.dart:98-118`, `admin_profile_screen.dart:126-144`, `create_doctor_screen.dart:86-104`.
**Create** `lib/apps/core/utils/image_pick.dart`:
```dart
/// Throws on picker failure; returns null when the user cancels.
Future<XFile?> pickGalleryImage({double maxWidth = 1024, double maxHeight = 1024, int imageQuality = 85}) =>
    ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight, imageQuality: imageQuality);
```
Each screen calls it with its current values (`create_doctor` uses `maxWidth: 1600`, no maxHeight → pass `maxHeight: null`; make
the params nullable `double?`). Keep each screen's `readAsBytes` + `setState`. **Every screen catches once and shows
`pickImageError`** (`admin_profile_screen` currently swallows it with `catch (_) {}`; fix that here).
Delete `create_doctor_screen.dart:39 _imagePicker` field if unused.

---

## Step 5: Layers & DI (screens must not call services / `FirebaseAuth`, no `?? getIt`, no `isRegistered`)

Target pattern (already used in the project): the route provides the Cubit with `BlocProvider(create: (_) => getIt<X>()...)`,
and the screen only uses `context.read<X>()` / `BlocBuilder`. For actions, the existing project pattern is "Cubit method throws,
screen does `try { await cubit.x(); showSuccess } catch (e) { showError(AppException.from(e).message) }`"
(see `admin_appointments_screen.dart:102-142`). Reuse that pattern.

### 5.1 Admin Appointments: double Cubit
`AdminAppointmentsRoute` (`routes.dart:286-291`) already provides `AdminAppointmentsCubit..init()`, but
`admin_appointments_screen.dart:60-79` creates a SECOND one. That means 2 Firestore subscriptions.
**Do:** delete the screen's `BlocProvider`, `widget.cubit` / `widget.repository` params, and the `getIt` import. `build` returns
`_AdminAppointmentsView(...)` directly. Update `test/features/admin/appointments/admin_appointments_test.dart` to wrap the screen in
`BlocProvider<AdminAppointmentsCubit>.value(value: cubit, child: …)`.

### 5.2 Patient + Admin appointment details: one shared Cubit
Both screens take `ClinicService?` / `AppointmentService?` / `SpecialtyService?` with `?? getIt` (`patient_appointment_details_screen.dart:46-51`,
`admin_appointment_details_screen.dart:44-49`) and call them directly.
**Create:**
- `lib/apps/features/common/appointment_details/data/repositories/appointment_details_repository.dart`:
  `abstract interface class AppointmentDetailsRepository { Future<String?> fetchSpecialtyName(String? specialtyId); Stream<ClinicModel?> watchClinic(); Future<void> cancel(AppointmentModel a, CancelledBy by); Future<void> markCompleted(String id); }`
  plus `AppointmentDetailsRepositoryImpl` using `SpecialtyService.fetchActiveSpecialties()` (same matching as the screens do today),
  `ClinicService.streamClinic()`, `AppointmentService.cancel(...)`, and `AppointmentService.markCompleted(...)`.
- `lib/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_cubit.dart` + `appointment_details_state.dart`:
  the state holds `String? specialtyName` and `ClinicModel? clinic`.
  `init(AppointmentModel a)` loads the specialty name and subscribes to `watchClinic()` (cancel it in `close()`).
  `Future<void> cancel(AppointmentModel a, CancelledBy by)` and `Future<void> markCompleted(String id)` just await the repository (they throw on error).
- Register the repository (`registerLazySingleton`) and the Cubit (`registerFactory`) in `lib/apps/core/di/injection.dart`.
- `routes.dart`: `PatientAppointmentDetailsRoute` and `AdminAppointmentDetailsRoute` wrap the screen in
  `BlocProvider(create: (_) => getIt<AppointmentDetailsCubit>()..init(appt), child: …)`.
**Change both screens:** delete the 3 service params, the getters, `_loadSpecialty`, `didUpdateWidget`, and the `_clinicStream` field. Read
`specialtyName` / `clinic` from `BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>`. Pass `clinic` to `ClinicLocationCard`
(patient). Admin keeps its `_InfoBlock` for the address, now fed from `state.clinic`. Cancel / mark-completed call the Cubit
inside the existing try/catch. Keep `_isCancelling` / `_isMarkingCompleted` local `setState` as today. Keep the UI the same.
**Tests:** update `test/features/patient/appointments/patient_appointment_details_screen_test.dart` and
`test/features/admin/appointments/admin_appointment_details_test.dart` to provide the Cubit (with a fake repository in `test/helpers/test_fakes.dart`).

### 5.3 Admin Doctor Details + Doctor Availability: Cubit built inside the screen
- `admin_doctor_details.dart:22-50`: `AdminDoctorDetailsCubit(initialDoctor: doctor, doctorService: doctorService ?? getIt<AdminDoctorService>())`.
- `doctor_availability_screen.dart:34-56`: builds `DoctorAvailabilityRepositoryImpl(doctorService: getIt<AdminDoctorService>())` in the UI,
  although `DoctorAvailabilityCubit` is registered in DI (`injection.dart:251-255`) and never used.
**Do:**
1. `injection.dart`: register `getIt.registerFactoryParam<AdminDoctorDetailsCubit, AdminDoctorModel, void>((doctor, _) => AdminDoctorDetailsCubit(initialDoctor: doctor, doctorService: getIt<AdminDoctorService>()))`.
   Change the existing `DoctorAvailabilityCubit` registration to
   `registerFactoryParam<DoctorAvailabilityCubit, DoctorAvailability?, void>((availability, _) => DoctorAvailabilityCubit(repository: getIt<DoctorAvailabilityRepository>(), initialAvailability: availability))`.
   (`registerFactoryParam` is built into `get_it`.)
2. `routes.dart`: `AdminDoctorDetailsRoute.build` → `BlocProvider(create: (_) => getIt<AdminDoctorDetailsCubit>(param1: $extra), child: AdminDoctorDetails(doctor: $extra))`.
   `DoctorAvailabilityRoute.build` → `BlocProvider(create: (_) => getIt<DoctorAvailabilityCubit>(param1: $extra.availability), child: DoctorAvailabilityScreen(doctor: $extra))`.
3. Both screens: delete the `cubit` / `doctorService` / `repository` params and the in-screen `BlocProvider`. `build` returns the
   private view directly. Delete unused imports (`injection.dart`, `admin_doctor_service.dart`).
4. Update `test/features/admin/doctor_details/admin_doctor_details_test.dart`, `test/features/admin/availability/doctor_availability_test.dart`,
   and `test/core/di/injection_test.dart`.
Do NOT change what `AdminDoctorDetailsCubit` calls internally (out of scope).

### 5.4 Admin Profile: `isRegistered`, `FirebaseAuth.instance`, `uid ?? 'admin'`
`admin_profile_screen.dart:51-57` (`?? getIt` + `(auth ?? getIt<FirebaseAuth>())`), and `:169-172`
(`getIt.isRegistered<FirebaseAuth>() ? getIt<FirebaseAuth>() : FirebaseAuth.instance` and `uid ?? 'admin'`, which can write to the wrong document).
**Do:**
1. `AdminProfileRepository`: add `String? get currentUid;` and implement it as `auth.currentUser?.uid` (the impl already has `auth`).
2. `AdminProfileCubit`: add `Future<void> loadCurrentProfile()`, which reads `repository.currentUid` and does nothing if it is null (then calls the
   existing `loadProfile`). Change `saveProfileAndClinic` to read the uid from `repository.currentUid` instead of a `uid` param.
   If the uid is null, emit the failure state with `AdminProfileFailure.unknown` (from Step 2.2) and do not write anything.
3. `routes.dart` `AdminProfileRoute.build` → `BlocProvider(create: (_) => getIt<AdminProfileCubit>()..loadCurrentProfile(), child: const AdminProfileScreen())`.
4. `admin_profile_screen.dart`: delete the `cubit` / `repository` / `uploadService` / `auth` params, the in-screen `BlocProvider`,
   the uid code in `_save`, and the `getIt` / `firebase_auth` imports.
5. Update `test/features/admin/profile/admin_profile_test.dart`.

### 5.5 Patient Settings + Edit Profile: repository / upload / `FirebaseAuth` called from the screen
- `patient_settings_screen.dart:21-61`: `profileRepository ?? getIt`, `auth ?? getIt<FirebaseAuth>()`, `StreamBuilder` on the repository.
- `edit_profile_screen.dart:58-64,~125-185`: `ProfileRepository`, `CloudinaryUploadService`, `FirebaseAuth` with `?? getIt`; it uploads and calls
  `user.updateDisplayName` / `updatePhotoURL` itself.
**Do:**
1. `AuthService` / `AuthRepository` / `AuthCubit`: add `bool get hasPasswordProvider`, which returns
   `currentUser?.providerData.any((p) => p.providerId == EmailAuthProvider.PROVIDER_ID) ?? false`, and
   `Future<void> updateDisplayNameAndPhoto(String name, String? photoUrl)`, which wraps the two `User` calls exactly as `edit_profile_screen.dart:168-171` does.
2. `ProfileRepository` (+ impl; inject `CloudinaryUploadService` and `AuthService` in DI): add
   `Future<void> saveProfile({required String uid, required String name, required String phone, DateTime? dob, String? gender, String? currentPhotoUrl, Uint8List? newImageBytes, String? newImageName})`,
   which moves the body of `edit_profile_screen.dart _save` (upload → `updateProfile` → `updateDisplayNameAndPhoto`) without changing behavior.
3. `ProfileCubit`: add `Future<void> saveProfile(...)` (passes through, throws on error), `Future<void> setNotifications(bool v)`,
   and `Future<void> setLanguage(String code)` (each calls `repository.updateProfile` for the current uid from `authRepository.currentUser`).
4. `routes.dart`: `EditProfileRoute` → `BlocProvider(create: (_) => getIt<ProfileCubit>()..init(initialProfile: $extra), child: EditProfileScreen(profile: $extra))`.
   `PatientSettingsRoute` → `MultiBlocProvider` with the existing `AuthCubit` + `getIt<ProfileCubit>()..init()`.
5. `edit_profile_screen.dart`: delete the 3 params + getters. Initial name/email/photo fall back to `widget.profile` only. `_save` calls
   `context.read<ProfileCubit>().saveProfile(...)` inside the existing try/catch/finally.
6. `patient_settings_screen.dart`: delete the 2 params + getters + `_currentUser`. Read the profile from
   `BlocBuilder<ProfileCubit, ProfileState>` (`ProfileLoaded(:final profile)`) instead of the `StreamBuilder`. Delete `_hasLoadedProfile`
   and the field assignments inside the builder. `_notificationsEnabled` is initialized once from the first `ProfileLoaded` in a
   `BlocListener`. `_hasPasswordProvider` → `context.read<AuthCubit>().hasPasswordProvider`. Toggle / language call the Cubit.
   Name/email fallbacks use only the profile + `tr.patientRoleTitle`.
7. Update `test/features/patient/profile/patient_settings_screen_test.dart`, `edit_profile_screen_test.dart`, `profile_cubit_test.dart`, and `test/core/di/injection_test.dart`.

---

## Step 6: Swallowed errors `catch (_)`

After Steps 1–5, these `catch (_)` are already gone: `doctor_availability_screen.dart:72,87`, `admin_doctor_details.dart:62`,
`admin_profile_screen.dart:143,160`, `rate_doctor_screen.dart:73`, `profile_screen.dart:78`, `edit_profile_screen.dart:194`,
`doctor_availability.dart:91`, `patient_appointment_details_screen.dart:82`, `admin_appointment_details_screen.dart:82`.
Verify with:
```bash
rg -n "catch \(_\)" lib
```
Fix the rest exactly like this. **Behavior and UI must stay the same; only stop hiding the error:**

| Where | Change |
|---|---|
| `booking_cubit.dart:87, 137, 226, 295` | `catch (_)` → `catch (error, stackTrace)` + `addError(error, stackTrace);` as the first line. Keep the existing fallback `emit`/`return`/`continue`. |
| `patient_appointments_cubit.dart:37`, `admin_appointments_cubit.dart:25` | same: `catch (error, stackTrace) { addError(error, stackTrace); }` |
| new `AppointmentDetailsCubit` specialty load (Step 5.2) | same: `addError`, leave `specialtyName` null |
| `rate_doctor_repository.dart:52` | delete the `try/catch` (let it throw). In the Cubit method that calls `getSpecialtyName` (`rate_doctor_cubit.dart`), wrap the call in `try { … } catch (error, stackTrace) { addError(error, stackTrace); }` and keep the specialty empty, the same UI as today. |
| `edit_profile_screen.dart:114`, `create_doctor_screen.dart:101,134` | NOT swallowed (they show a snackbar). Leave them. |

Do not add `addError` anywhere else.

---

## Step 7 (HIGH RISK, do last): `AdminDoctorModel` / `AdminDoctorService` duplicate `DoctorModel` / `DoctorService`

`AdminDoctorModel` (`lib/apps/features/admin/doctors/data/models/admin_doctor_model.dart`) has the same fields as `DoctorModel`
(`lib/apps/core/models/doctor_model.dart`) plus `lastModified`, and even has `toDoctorModel()`. `AdminDoctorService` and
`DoctorService` both parse the `doctors` collection.

**Before starting, STOP and check one difference:** `DoctorModel.fromFirestore` **throws** `FormatException` when a name or specialty
is missing, but `AdminDoctorModel.fromFirestore` returns `''`. Search the tests (`test/features/admin/admin_doctor_service_test.dart`,
`test/apps/features/admin/doctors/data/service/admin_doctor_service_test.dart`) for a case with missing name/specialty. If one exists,
**stop and report to Tarek**. Do not change the parsing rules of `DoctorModel`.

**Do:**
1. `DoctorModel`: add `final DateTime? lastModified;` (ctor param, `copyWith`, and `fromFirestore` parses `data['updatedAt'] ?? data['createdAt']`
   as a `Timestamp`, the same code as `admin_doctor_model.dart:89-92`). Nothing else changes in `DoctorModel`.
2. Move every method of `AdminDoctorService` (`streamDoctors`, `streamDoctor`, `createDoctor`, `updateDoctor`, `setActive`, `updateAvailability`,
   `_nextDoctorId`, `_cleanUrl`, and the top-level `newDoctorData`) into `lib/apps/core/services/doctor_service.dart`, parsing with
   `DoctorModel.fromFirestore`. Keep each method's logic and the sort by `lastModified` the same.
3. Delete `admin_doctor_service.dart` and `admin_doctor_model.dart`. Replace `AdminDoctorModel` → `DoctorModel` and `AdminDoctorService` → `DoctorService`
   everywhere (`routes.dart`, `injection.dart`, `admin_doctors_repository.dart`, `create_doctor_repository.dart`, `doctor_availability_repository.dart`,
   `admin_doctor_details_cubit.dart`, `admin_doctor_details.dart`, `doctor_availability_screen.dart`, `create_doctor_screen.dart`,
   `admin_doctors_screen.dart`, `admin_doctors_widgets.dart`, `admin_doctors_cubit.dart`, `admin_doctors_state.dart`, and the
   `registerFactoryParam` types from Step 5.3). Delete `toDoctorModel()` calls (the object already is a `DoctorModel`).
   **The `//CR` lines in `admin_doctor_service.dart:7-27` would be deleted with the file. Stop and ask Tarek before deleting that file (rule 5).**
4. Remove the `AdminDoctorService` registration from DI.
5. Move / merge the admin service tests into a `DoctorService` test and update `test/helpers/test_fakes.dart`, `admin_cubits_test.dart`,
   `admin_doctor_details_test.dart`, `doctor_availability_test.dart`, `admin_doctors_screen_test.dart`, `route_providers_lifecycle_test.dart`,
   and `injection_test.dart`.

---

## Final self-check (before you say "done")
- `flutter analyze` = 0 issues, `flutter test` = all pass.
- These searches return nothing (or only the allowed lines named above):
  ```bash
  rg -n "\?\? getIt<|isRegistered|FirebaseAuth\.instance|'admin'\)|catch \(_\)" lib
  ```
  ```bash
  rg -n "ScaffoldMessenger\.of\(context\)\.showSnackBar|AlertDialog\(|_popScreen|toStringAsFixed\(0\)|'male'|'password'|requires-recent-login" lib/apps/features
  ```
  The only allowed hit is the single Firebase-code comparison inside `admin_profile_cubit.dart` (Step 2.2).
- `git diff --stat` touches only files named in this plan (plus the new files it creates, tests, translations, and generated output).
- Report: per step, files changed and anything skipped (with the reason).
