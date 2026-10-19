import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/controller/cubit/admin_doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/screens/admin_doctor_details.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/screens/admin_profile_screen.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/screens/admin_appointments_screen.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/screens/admin_appointment_details_screen.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/screens/doctor_availability_screen.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/screens/create_doctor_screen.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/screens/admin_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/admin/settings/presentation/screens/admin_settings_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/edit_profile_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/login_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/signup_screen.dart';
import 'package:doctor_hunt/apps/features/common/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/data/models/user_role.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/presentation/screens/role_selection_screen.dart';
import 'package:doctor_hunt/apps/features/common/shell/presentation/screens/admin_shell.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/common/shell/presentation/screens/patient_shell.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/controller/cubit/patient_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/screens/patient_appointment_details_screen.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/screens/patient_appointments_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/screens/booking_review_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/screens/doctor_booking_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/screens/patient_doctor_details_screen.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/screens/patient_home_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/change_password_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/change_password_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/edit_profile_screen.dart';
import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/patient_settings_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/privacy_policy_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/profile_screen.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/presentation/controller/cubit/rate_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/presentation/screens/rate_doctor_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<OnboardingRoute>(path: AppRoutePaths.onboarding)
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OnboardingScreen(preferencesService: getIt<AppPreferencesService>());
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

@TypedGoRoute<RoleSelectionRoute>(path: AppRoutePaths.roleSelection)
class RoleSelectionRoute extends GoRouteData with $RoleSelectionRoute {
  const RoleSelectionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RoleSelectionScreen();
  }
}

@TypedStatefulShellRoute<PatientShellRoute>(
  branches: [
    TypedStatefulShellBranch<PatientHomeBranch>(
      routes: [TypedGoRoute<HomeRoute>(path: AppRoutePaths.home)],
    ),
    TypedStatefulShellBranch<PatientFavoritesBranch>(
      routes: [TypedGoRoute<FavoritesRoute>(path: AppRoutePaths.favorites)],
    ),
    TypedStatefulShellBranch<PatientAppointmentsBranch>(
      routes: [
        TypedGoRoute<PatientAppointmentsRoute>(
          path: AppRoutePaths.appointments,
        ),
      ],
    ),
    TypedStatefulShellBranch<PatientSettingsBranch>(
      routes: [
        TypedGoRoute<PatientSettingsRoute>(path: AppRoutePaths.patientSettings),
      ],
    ),
  ],
)
class PatientShellRoute extends StatefulShellRouteData {
  const PatientShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (_) => getIt<ProfileCubit>()..init(),
        ),
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
      ],
      child: PatientShell(navigationShell: navigationShell),
    );
  }
}

class PatientHomeBranch extends StatefulShellBranchData {
  const PatientHomeBranch();
}

class PatientFavoritesBranch extends StatefulShellBranchData {
  const PatientFavoritesBranch();
}

class PatientAppointmentsBranch extends StatefulShellBranchData {
  const PatientAppointmentsBranch();
}

class PatientSettingsBranch extends StatefulShellBranchData {
  const PatientSettingsBranch();
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>(),
      child: HomeScreen(user: getIt<AuthRepository>().sessionUser),
    );
  }
}

class PatientAppointmentsRoute extends GoRouteData
    with $PatientAppointmentsRoute {
  const PatientAppointmentsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<PatientAppointmentsCubit>(
      create: (_) => getIt<PatientAppointmentsCubit>()..init(),
      child: const PatientAppointmentsScreen(),
    );
  }
}

class FavoritesRoute extends GoRouteData with $FavoritesRoute {
  const FavoritesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<FindDoctorsCubit>(
      create: (_) => getIt<FindDoctorsCubit>(),
      child: const FindDoctorsScreen(favoritesOnly: true),
    );
  }
}

/// Settings tab; [ProfileCubit] and [AuthCubit] come from [PatientShellRoute].
class PatientSettingsRoute extends GoRouteData with $PatientSettingsRoute {
  const PatientSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PatientSettingsScreen();
  }
}

@TypedStatefulShellRoute<AdminShellRoute>(
  branches: [
    TypedStatefulShellBranch<AdminDoctorsBranch>(
      routes: [
        TypedGoRoute<AdminDoctorsRoute>(path: AppRoutePaths.adminDoctors),
      ],
    ),
    TypedStatefulShellBranch<AdminAppointmentsBranch>(
      routes: [
        TypedGoRoute<AdminAppointmentsRoute>(
          path: AppRoutePaths.adminAppointments,
        ),
      ],
    ),
    TypedStatefulShellBranch<AdminSettingsBranch>(
      routes: [
        TypedGoRoute<AdminSettingsRoute>(path: AppRoutePaths.adminSettings),
      ],
    ),
  ],
)
class AdminShellRoute extends StatefulShellRouteData {
  const AdminShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return AdminShell(navigationShell: navigationShell);
  }
}

class AdminDoctorsBranch extends StatefulShellBranchData {
  const AdminDoctorsBranch();
}

class AdminAppointmentsBranch extends StatefulShellBranchData {
  const AdminAppointmentsBranch();
}

class AdminSettingsBranch extends StatefulShellBranchData {
  const AdminSettingsBranch();
}

class AdminDoctorsRoute extends GoRouteData with $AdminDoctorsRoute {
  const AdminDoctorsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AdminDoctorsCubit>(
      create: (_) => getIt<AdminDoctorsCubit>(),
      child: AdminDoctorsScreen(
        adminPhotoUrl: getIt<AuthRepository>().sessionUser?.photoUrl,
      ),
    );
  }
}

class AdminAppointmentsRoute extends GoRouteData with $AdminAppointmentsRoute {
  const AdminAppointmentsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AdminAppointmentsCubit>(
      create: (_) => getIt<AdminAppointmentsCubit>()..init(),
      child: AdminAppointmentsScreen(
        adminPhotoUrl: getIt<AuthRepository>().sessionUser?.photoUrl,
      ),
    );
  }
}

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

@TypedGoRoute<FindDoctorsRoute>(path: AppRoutePaths.doctors)
class FindDoctorsRoute extends GoRouteData with $FindDoctorsRoute {
  const FindDoctorsRoute({
    this.q,
    this.specialtyId,
    this.sort,
    this.focus = false,
  });

  final String? q;
  final String? specialtyId;
  final DoctorSort? sort;

  final bool focus;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<FindDoctorsCubit>(
      create: (_) => getIt<FindDoctorsCubit>(),
      child: FindDoctorsScreen(
        query: q,
        specialtyId: specialtyId,
        sort: sort,
        focusSearch: focus,
      ),
    );
  }
}

@TypedGoRoute<CreateDoctorRoute>(path: AppRoutePaths.createDoctor)
class CreateDoctorRoute extends GoRouteData with $CreateDoctorRoute {
  const CreateDoctorRoute([this.$extra]);

  final DoctorModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<CreateDoctorCubit>(
      create: (_) => getIt<CreateDoctorCubit>(),
      child: CreateDoctorScreen(doctor: $extra),
    );
  }
}

@TypedGoRoute<AdminProfileRoute>(path: AppRoutePaths.adminProfile)
class AdminProfileRoute extends GoRouteData with $AdminProfileRoute {
  const AdminProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AdminProfileCubit>(
      create: (_) => getIt<AdminProfileCubit>()..loadCurrentProfile(),
      child: const AdminProfileScreen(),
    );
  }
}

@TypedGoRoute<AdminDoctorDetailsRoute>(path: AppRoutePaths.adminDoctorDetails)
class AdminDoctorDetailsRoute extends GoRouteData
    with $AdminDoctorDetailsRoute {
  const AdminDoctorDetailsRoute(this.$extra);

  final DoctorModel $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AdminDoctorDetailsCubit>(
      create: (_) => getIt<AdminDoctorDetailsCubit>(param1: $extra),
      child: const AdminDoctorDetails(),
    );
  }
}

@TypedGoRoute<AdminAppointmentDetailsRoute>(
  path: AppRoutePaths.adminAppointmentDetails,
)
class AdminAppointmentDetailsRoute extends GoRouteData
    with $AdminAppointmentDetailsRoute {
  const AdminAppointmentDetailsRoute(this.$extra);

  final AppointmentModel $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AppointmentDetailsCubit>(
      create: (_) => getIt<AppointmentDetailsCubit>(param1: $extra)..init(),
      child: const AdminAppointmentDetailsScreen(),
    );
  }
}

@TypedGoRoute<DoctorAvailabilityRoute>(path: AppRoutePaths.doctorAvailability)
class DoctorAvailabilityRoute extends GoRouteData
    with $DoctorAvailabilityRoute {
  const DoctorAvailabilityRoute(this.$extra);

  final DoctorModel $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<DoctorAvailabilityCubit>(
      create: (_) =>
          getIt<DoctorAvailabilityCubit>(param1: $extra.availability),
      child: DoctorAvailabilityScreen(doctor: $extra),
    );
  }
}

@TypedGoRoute<DoctorDetailsRoute>(path: AppRoutePaths.doctorDetails)
class DoctorDetailsRoute extends GoRouteData with $DoctorDetailsRoute {
  const DoctorDetailsRoute(this.$extra);

  final DoctorModel $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DoctorDetailsCubit>(
          create: (_) => getIt<DoctorDetailsCubit>(),
        ),
        BlocProvider<BookingCubit>(
          create: (_) => getIt<BookingCubit>()..init($extra),
        ),
      ],
      child: DoctorDetailsScreen(doctor: $extra),
    );
  }
}

@TypedGoRoute<SelectTimeRoute>(path: AppRoutePaths.selectTime)
class SelectTimeRoute extends GoRouteData with $SelectTimeRoute {
  const SelectTimeRoute(this.$extra);

  final DoctorModel $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<BookingCubit>(
      create: (_) => getIt<BookingCubit>()..init($extra),
      child: DoctorBookingScreen(doctor: $extra),
    );
  }
}

@TypedGoRoute<BookingReviewRoute>(path: AppRoutePaths.bookingReview)
class BookingReviewRoute extends GoRouteData with $BookingReviewRoute {
  const BookingReviewRoute(this.$extra);

  final BookingDraft $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<BookingCubit>(
      create: (_) => getIt<BookingCubit>(),
      child: BookingReviewScreen(draft: $extra),
    );
  }
}

@TypedGoRoute<EditProfileRoute>(path: AppRoutePaths.editProfile)
class EditProfileRoute extends GoRouteData with $EditProfileRoute {
  const EditProfileRoute([this.$extra]);

  final UserProfileModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<EditProfileCubit>(
      create: (_) => getIt<EditProfileCubit>(),
      child: EditProfileScreen(profile: $extra),
    );
  }
}

@TypedGoRoute<ProfileRoute>(path: AppRoutePaths.profile)
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>()..init(),
      child: const ProfileScreen(),
    );
  }
}

@TypedGoRoute<ChangePasswordRoute>(path: AppRoutePaths.changePassword)
class ChangePasswordRoute extends GoRouteData with $ChangePasswordRoute {
  const ChangePasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<ChangePasswordCubit>(
      create: (_) => getIt<ChangePasswordCubit>(),
      child: const ChangePasswordScreen(),
    );
  }
}

@TypedGoRoute<PrivacyPolicyRoute>(path: AppRoutePaths.privacyPolicy)
class PrivacyPolicyRoute extends GoRouteData with $PrivacyPolicyRoute {
  const PrivacyPolicyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PrivacyPolicyScreen();
  }
}

@TypedGoRoute<PatientAppointmentDetailsRoute>(
  path: AppRoutePaths.patientAppointmentDetails,
)
class PatientAppointmentDetailsRoute extends GoRouteData
    with $PatientAppointmentDetailsRoute {
  const PatientAppointmentDetailsRoute(this.$extra);

  final AppointmentModel $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<AppointmentDetailsCubit>(
      create: (_) => getIt<AppointmentDetailsCubit>(param1: $extra)..init(),
      child: const PatientAppointmentDetailsScreen(),
    );
  }
}

@TypedGoRoute<PatientRateDoctorRoute>(path: AppRoutePaths.rateDoctor)
class PatientRateDoctorRoute extends GoRouteData with $PatientRateDoctorRoute {
  const PatientRateDoctorRoute(this.$extra);

  final AppointmentModel $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider<RateDoctorCubit>(
      create: (_) =>
          getIt<RateDoctorCubit>()..loadSpecialty($extra.specialtyId),
      child: RateDoctorScreen(appointment: $extra),
    );
  }
}
