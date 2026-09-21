# Standardize Reusable Button Widgets & Resolve All CR Comments

This plan addresses all instances of the code review comment `//CR use primary widget (any reuse widget)` across the codebase. Raw Flutter buttons (`TextButton` and `OutlinedButton`) with custom/duplicated inline styles will be replaced with reusable, standardized design system components (`AppPrimaryButton.outlined` / `AppOutlinedButton` and `AppTextButton`), and existing `AppIconButton` will be applied where appropriate.

## User Review Required

> [!NOTE]
> All proposed changes maintain 100% backward visual fidelity, responsive sizing, existing callbacks, and behavior. All addressed `//CR` comments will be marked with `// Solved` consistent with the codebase convention.

## Proposed Changes

### Core Reusable Widgets Layer

#### [NEW] [app_text_button.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/core/widgets/app_text_button.dart)
- Create `AppTextButton`, a standardized reusable text button widget supporting:
  - `label`, `onPressed`, `textStyle`, `foregroundColor`, `padding`
  - Optional leading `icon` and `iconSize`
  - Optional `isLoading` state (rendering mini progress indicator)
  - Layout controls: `tapTargetSize`, `minimumSize`, `alignment`

#### [MODIFY] [app_primary_button.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/core/widgets/app_primary_button.dart)
- Extend `AppPrimaryButton` with a named constructor `AppPrimaryButton.outlined` (and `AppOutlinedButton` companion) supporting:
  - `borderColor`, `borderWidth`, `borderSide`
  - Proper `OutlinedButton` rendering with matching loading state, icon, and sizing
  - Maintains complete backward compatibility for existing `AppPrimaryButton` usages

---

### Features & Presentation Layer (Resolving `//CR` comments)

#### [MODIFY] [admin_settings_screen.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/admin/settings/presentation/screens/admin_settings_screen.dart)
- Replace raw `OutlinedButton.icon` logout button with `AppPrimaryButton.outlined(icon: Icons.logout_rounded, label: tr.logOut, foregroundColor: AppColors.error, borderColor: AppColors.error, isLoading: isLoggingOut, onPressed: ...)`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [no_slots_available_section.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/patient/doctor_booking/presentation/widgets/no_slots_available_section.dart)
- Replace raw `OutlinedButton` "Contact Clinic" with `AppPrimaryButton.outlined(label: context.tr.contactClinic, width: 306, height: 54, borderRadius: BorderRadius.circular(8), borderColor: AppColors.primary.withValues(alpha: 0.5), textStyle: context.bold16Primary, onPressed: onContactClinicTap)`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [thank_you_dialog.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/patient/doctor_booking/presentation/widgets/thank_you_dialog.dart)
- Replace raw `TextButton` "Edit Your Appointment" with `AppTextButton(label: tr.editYourAppointment, foregroundColor: AppColors.textSecondary, textStyle: context.medium14TextSecondary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), onPressed: ...)`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [admin_doctors_screen.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/admin/doctors/presentation/screens/admin_doctors_screen.dart)
- Replace dialog action `TextButton`s (Cancel and Delete) with `AppTextButton`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [create_doctor_widgets.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/admin/create_doctor/presentation/widgets/create_doctor_widgets.dart)
- Replace `TextButton.icon` for removing image with `AppTextButton(icon: Icons.close_rounded, label: tr.removeImage, onPressed: onClear)`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [custom_snack_bar.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/core/extensions/custom_snack_bar.dart)
- Replace raw snackbar action `TextButton` with `AppTextButton`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [onboarding_screen.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/common/onboarding/presentation/screens/onboarding_screen.dart)
- Replace raw `TextButton` "Skip" with `AppTextButton(label: tr.skip, onPressed: onSkip)`.
- Replace raw `IconButton` "Next" with standardized `AppIconButton` (size 58, primary background, circular border).
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [login_screen.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/common/auth/presentation/screens/login_screen.dart)
- Replace raw `TextButton` for "Forgot Password" and "Join Us" in `_SignUpFooter` with `AppTextButton`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [otp_verification_screen.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/common/auth/presentation/screens/otp_verification_screen.dart)
- Replace raw `TextButton` for "Resend Code" with `AppTextButton` (with built-in loading state and active/inactive styling).
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [reset_password_screen.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/common/auth/presentation/screens/reset_password_screen.dart)
- Replace raw `TextButton` "Sign In" in footer with `AppTextButton`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

#### [MODIFY] [signup_screen.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/lib/apps/features/common/auth/presentation/screens/signup_screen.dart)
- Replace raw `TextButton` "Sign In" in `_LoginFooter` with `AppTextButton`.
- Mark `//CR use primary widget (any reuse widget)` with `// Solved`.

---

### Verification Plan

#### Automated Tests
- Create [app_text_button_test.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/test/core/widgets/app_text_button_test.dart) covering:
  - Renders label and triggers tap callback
  - Loading state disables interaction and displays indicator
  - Custom textStyle, foregroundColor, padding, and icon rendering
- Add tests to [app_primary_button_test.dart](file:///d:/Programming/mobile-development/flutter_projects/codeplus-projects/test/core/widgets/app_primary_button_test.dart) covering:
  - `AppPrimaryButton.outlined` rendering and callbacks
- Run `flutter test` across all unit/widget tests.
- Run `flutter analyze` to ensure 0 lints/errors.

#### Manual Verification
- Verify that every occurrence of `//CR use primary widget (any reuse widget)` is cleanly resolved and marked `// Solved`.
