import 'package:doctor_hunt/apps/features/common/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/login_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/otp_verification_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/reset_password_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/signup_screen.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';

import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/screens/admin_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/admin/settings/presentation/screens/admin_settings_screen.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/data/models/user_role.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/presentation/screens/role_selection_screen.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/screens/create_doctor_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/screens/patient_doctor_details_screen.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/screens/favourite_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/screens/patient_home_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/screens/doctor_booking_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/profile_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

part 'routes.g.dart';

@TypedGoRoute<OnboardingRoute>(path: AppRoutePaths.onboarding)
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: AppRoutePaths.login)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute([this.$extra]);

  final UserRole? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: LoginScreen(role: $extra),
    );
  }
}

@TypedGoRoute<SignupRoute>(path: AppRoutePaths.signup)
class SignupRoute extends GoRouteData with $SignupRoute {
  const SignupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: const SignupScreen(),
    );
  }
}

@TypedGoRoute<OtpVerificationRoute>(path: AppRoutePaths.otpVerification)
class OtpVerificationRoute extends GoRouteData with $OtpVerificationRoute {
  const OtpVerificationRoute([this.$extra]);

  final String? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OtpVerificationScreen(phoneNumber: $extra ?? tr.defaultPhoneNumber);
  }
}

@TypedGoRoute<ResetPasswordRoute>(path: AppRoutePaths.resetPassword)
class ResetPasswordRoute extends GoRouteData with $ResetPasswordRoute {
  const ResetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: const ResetPasswordScreen(),
    );
  }
}

@TypedGoRoute<RoleSelectionRoute>(path: AppRoutePaths.roleSelection)
class RoleSelectionRoute extends GoRouteData with $RoleSelectionRoute {
  const RoleSelectionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RoleSelectionScreen();
  }
}

@TypedGoRoute<AdminDoctorsRoute>(path: AppRoutePaths.adminDoctors)
class AdminDoctorsRoute extends GoRouteData with $AdminDoctorsRoute {
  const AdminDoctorsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AdminDoctorsCubit>(
      create: (_) => getIt<AdminDoctorsCubit>(),
      child: const AdminDoctorsScreen(),
    );
  }
}

@TypedGoRoute<CreateDoctorRoute>(path: AppRoutePaths.createDoctor)
class CreateDoctorRoute extends GoRouteData with $CreateDoctorRoute {
  const CreateDoctorRoute([this.$extra]);

  final AdminDoctorModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<CreateDoctorCubit>(
      create: (_) => getIt<CreateDoctorCubit>(),
      child: CreateDoctorScreen(doctor: $extra),
    );
  }
}

@TypedGoRoute<AdminSettingsRoute>(path: AppRoutePaths.adminSettings)
class AdminSettingsRoute extends GoRouteData with $AdminSettingsRoute {
  const AdminSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: const AdminSettingsScreen(),
    );
  }
}

@TypedGoRoute<HomeRoute>(path: AppRoutePaths.home)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>(),
      child: HomeScreen(user: getIt<AuthRepository>().currentUser),
    );
  }
}

@TypedGoRoute<FindDoctorsRoute>(path: AppRoutePaths.findDoctors)
class FindDoctorsRoute extends GoRouteData with $FindDoctorsRoute {
  const FindDoctorsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<FindDoctorsCubit>(
      create: (_) => getIt<FindDoctorsCubit>(),
      child: const FindDoctorsScreen(),
    );
  }
}

@TypedGoRoute<DoctorDetailsRoute>(path: AppRoutePaths.doctorDetails)
class DoctorDetailsRoute extends GoRouteData with $DoctorDetailsRoute {
  const DoctorDetailsRoute([this.$extra]);

  final DoctorModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DoctorDetailsScreen(doctor: $extra ?? DoctorModel.placeholder());
  }
}

@TypedGoRoute<FavouriteDoctorsRoute>(path: AppRoutePaths.favouriteDoctors)
class FavouriteDoctorsRoute extends GoRouteData with $FavouriteDoctorsRoute {
  const FavouriteDoctorsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<FavouriteDoctorsCubit>(
      create: (_) => getIt<FavouriteDoctorsCubit>(),
      child: const FavouriteDoctorsScreen(),
    );
  }
}

@TypedGoRoute<SelectTimeRoute>(path: AppRoutePaths.selectTime)
class SelectTimeRoute extends GoRouteData with $SelectTimeRoute {
  const SelectTimeRoute([this.$extra]);

  final DoctorModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DoctorBookingScreen(doctor: $extra ?? DoctorModel.placeholder());
  }
}

@TypedGoRoute<ProfileRoute>(path: AppRoutePaths.profile)
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute([this.$extra]);

  final UserProfileModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: ProfileScreen(profile: $extra),
    );
  }
}
