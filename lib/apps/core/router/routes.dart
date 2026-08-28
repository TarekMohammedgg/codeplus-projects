import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/features/auth/presentation/screens/login_screen.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/signup_screen.dart';
import 'package:doctor_hunt/apps/core/data/doctors_data.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

import 'package:doctor_hunt/apps/features/doctors/presentation/screens/doctor_details_screen.dart';
import 'package:doctor_hunt/apps/features/doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/favourite_doctors/presentation/screens/favourite_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/home/presentation/screens/home_screen.dart';
import 'package:doctor_hunt/apps/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/screens/doctor_select_time_screen.dart';
import 'package:doctor_hunt/apps/features/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/profile/presentation/screens/profile_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

part 'routes.g.dart';

@TypedGoRoute<OnboardingRoute>(path: '/')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

@TypedGoRoute<SignupRoute>(path: '/signup')
class SignupRoute extends GoRouteData with $SignupRoute {
  const SignupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignupScreen();
  }
}

@TypedGoRoute<OtpVerificationRoute>(path: '/otp-verification')
class OtpVerificationRoute extends GoRouteData with $OtpVerificationRoute {
  const OtpVerificationRoute([this.$extra]);

  final String? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OtpVerificationScreen(phoneNumber: $extra ?? tr.defaultPhoneNumber);
  }
}

@TypedGoRoute<ResetPasswordRoute>(path: '/reset-password')
class ResetPasswordRoute extends GoRouteData with $ResetPasswordRoute {
  const ResetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ResetPasswordScreen();
  }
}

@TypedGoRoute<RoleSelectionRoute>(path: '/role-selection')
class RoleSelectionRoute extends GoRouteData with $RoleSelectionRoute {
  const RoleSelectionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RoleSelectionScreen();
  }
}

@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@TypedGoRoute<FindDoctorsRoute>(path: '/find-doctors')
class FindDoctorsRoute extends GoRouteData with $FindDoctorsRoute {
  const FindDoctorsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FindDoctorsScreen();
  }
}

@TypedGoRoute<DoctorDetailsRoute>(path: '/doctor-details')
class DoctorDetailsRoute extends GoRouteData with $DoctorDetailsRoute {
  const DoctorDetailsRoute([this.$extra]);

  final DoctorModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DoctorDetailsScreen(doctor: $extra ?? defaultDoctorDetails());
  }
}

@TypedGoRoute<FavouriteDoctorsRoute>(path: '/favourite-doctors')
class FavouriteDoctorsRoute extends GoRouteData with $FavouriteDoctorsRoute {
  const FavouriteDoctorsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FavouriteDoctorsScreen();
  }
}

@TypedGoRoute<SelectTimeRoute>(path: '/select-time')
class SelectTimeRoute extends GoRouteData with $SelectTimeRoute {
  const SelectTimeRoute([this.$extra]);

  final DoctorModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SelectTimeScreen(doctor: $extra ?? defaultDoctorDetails());
  }
}

@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute([this.$extra]);

  final UserProfileModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfileScreen(profile: $extra);
  }
}
