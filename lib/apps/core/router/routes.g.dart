// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $onboardingRoute,
  $loginRoute,
  $signupRoute,
  $roleSelectionRoute,
  $patientShellRoute,
  $adminShellRoute,
  $findDoctorsRoute,
  $createDoctorRoute,
  $adminProfileRoute,
  $adminDoctorDetailsRoute,
  $adminAppointmentDetailsRoute,
  $doctorAvailabilityRoute,
  $doctorDetailsRoute,
  $selectTimeRoute,
  $bookingReviewRoute,
  $editProfileRoute,
  $patientSettingsRoute,
  $changePasswordRoute,
  $privacyPolicyRoute,
  $patientAppointmentDetailsRoute,
  $patientRateDoctorRoute,
];

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $OnboardingRoute._fromState,
);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) =>
      LoginRoute(state.extra as UserRole?);

  LoginRoute get _self => this as LoginRoute;

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $signupRoute => GoRouteData.$route(
  path: '/signup',
  hasOverriddenOnExit: false,
  factory: $SignupRoute._fromState,
);

mixin $SignupRoute on GoRouteData {
  static SignupRoute _fromState(GoRouterState state) => const SignupRoute();

  @override
  String get location => GoRouteData.$location('/signup');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $roleSelectionRoute => GoRouteData.$route(
  path: '/role-selection',
  hasOverriddenOnExit: false,
  factory: $RoleSelectionRoute._fromState,
);

mixin $RoleSelectionRoute on GoRouteData {
  static RoleSelectionRoute _fromState(GoRouterState state) =>
      const RoleSelectionRoute();

  @override
  String get location => GoRouteData.$location('/role-selection');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $patientShellRoute => StatefulShellRouteData.$route(
  factory: $PatientShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/favorites',
          hasOverriddenOnExit: false,
          factory: $FavoritesRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/appointments',
          hasOverriddenOnExit: false,
          factory: $PatientAppointmentsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          hasOverriddenOnExit: false,
          factory: $ProfileRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $PatientShellRouteExtension on PatientShellRoute {
  static PatientShellRoute _fromState(GoRouterState state) =>
      const PatientShellRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FavoritesRoute on GoRouteData {
  static FavoritesRoute _fromState(GoRouterState state) =>
      const FavoritesRoute();

  @override
  String get location => GoRouteData.$location('/favorites');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PatientAppointmentsRoute on GoRouteData {
  static PatientAppointmentsRoute _fromState(GoRouterState state) =>
      const PatientAppointmentsRoute();

  @override
  String get location => GoRouteData.$location('/appointments');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $adminShellRoute => StatefulShellRouteData.$route(
  factory: $AdminShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/admin/doctors',
          hasOverriddenOnExit: false,
          factory: $AdminDoctorsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/admin/appointments',
          hasOverriddenOnExit: false,
          factory: $AdminAppointmentsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/admin/settings',
          hasOverriddenOnExit: false,
          factory: $AdminSettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AdminShellRouteExtension on AdminShellRoute {
  static AdminShellRoute _fromState(GoRouterState state) =>
      const AdminShellRoute();
}

mixin $AdminDoctorsRoute on GoRouteData {
  static AdminDoctorsRoute _fromState(GoRouterState state) =>
      const AdminDoctorsRoute();

  @override
  String get location => GoRouteData.$location('/admin/doctors');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdminAppointmentsRoute on GoRouteData {
  static AdminAppointmentsRoute _fromState(GoRouterState state) =>
      const AdminAppointmentsRoute();

  @override
  String get location => GoRouteData.$location('/admin/appointments');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdminSettingsRoute on GoRouteData {
  static AdminSettingsRoute _fromState(GoRouterState state) =>
      const AdminSettingsRoute();

  @override
  String get location => GoRouteData.$location('/admin/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $findDoctorsRoute => GoRouteData.$route(
  path: '/doctors',
  hasOverriddenOnExit: false,
  factory: $FindDoctorsRoute._fromState,
);

mixin $FindDoctorsRoute on GoRouteData {
  static FindDoctorsRoute _fromState(GoRouterState state) => FindDoctorsRoute(
    q: state.uri.queryParameters['q'],
    specialtyId: state.uri.queryParameters['specialty-id'],
    sort: _$convertMapValue(
      'sort',
      state.uri.queryParameters,
      _$DoctorSortEnumMap._$fromName,
    ),
    focus:
        _$convertMapValue(
          'focus',
          state.uri.queryParameters,
          _$boolConverter,
        ) ??
        false,
  );

  FindDoctorsRoute get _self => this as FindDoctorsRoute;

  @override
  String get location => GoRouteData.$location(
    '/doctors',
    queryParams: {
      if (_self.q != null) 'q': _self.q,
      if (_self.specialtyId != null) 'specialty-id': _self.specialtyId,
      if (_self.sort != null) 'sort': _$DoctorSortEnumMap[_self.sort!],
      if (_self.focus != false) 'focus': _self.focus.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

const _$DoctorSortEnumMap = {
  DoctorSort.popular: 'popular',
  DoctorSort.topRated: 'top-rated',
};

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}

RouteBase get $createDoctorRoute => GoRouteData.$route(
  path: '/admin/doctors/create',
  hasOverriddenOnExit: false,
  factory: $CreateDoctorRoute._fromState,
);

mixin $CreateDoctorRoute on GoRouteData {
  static CreateDoctorRoute _fromState(GoRouterState state) =>
      CreateDoctorRoute(state.extra as DoctorModel?);

  CreateDoctorRoute get _self => this as CreateDoctorRoute;

  @override
  String get location => GoRouteData.$location('/admin/doctors/create');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $adminProfileRoute => GoRouteData.$route(
  path: '/admin/profile',
  hasOverriddenOnExit: false,
  factory: $AdminProfileRoute._fromState,
);

mixin $AdminProfileRoute on GoRouteData {
  static AdminProfileRoute _fromState(GoRouterState state) =>
      const AdminProfileRoute();

  @override
  String get location => GoRouteData.$location('/admin/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $adminDoctorDetailsRoute => GoRouteData.$route(
  path: '/admin/doctors/details',
  hasOverriddenOnExit: false,
  factory: $AdminDoctorDetailsRoute._fromState,
);

mixin $AdminDoctorDetailsRoute on GoRouteData {
  static AdminDoctorDetailsRoute _fromState(GoRouterState state) =>
      AdminDoctorDetailsRoute(state.extra as DoctorModel);

  AdminDoctorDetailsRoute get _self => this as AdminDoctorDetailsRoute;

  @override
  String get location => GoRouteData.$location('/admin/doctors/details');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $adminAppointmentDetailsRoute => GoRouteData.$route(
  path: '/admin/appointments/details',
  hasOverriddenOnExit: false,
  factory: $AdminAppointmentDetailsRoute._fromState,
);

mixin $AdminAppointmentDetailsRoute on GoRouteData {
  static AdminAppointmentDetailsRoute _fromState(GoRouterState state) =>
      AdminAppointmentDetailsRoute(state.extra as AppointmentModel);

  AdminAppointmentDetailsRoute get _self =>
      this as AdminAppointmentDetailsRoute;

  @override
  String get location => GoRouteData.$location('/admin/appointments/details');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $doctorAvailabilityRoute => GoRouteData.$route(
  path: '/admin/doctors/availability',
  hasOverriddenOnExit: false,
  factory: $DoctorAvailabilityRoute._fromState,
);

mixin $DoctorAvailabilityRoute on GoRouteData {
  static DoctorAvailabilityRoute _fromState(GoRouterState state) =>
      DoctorAvailabilityRoute(state.extra as DoctorModel);

  DoctorAvailabilityRoute get _self => this as DoctorAvailabilityRoute;

  @override
  String get location => GoRouteData.$location('/admin/doctors/availability');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $doctorDetailsRoute => GoRouteData.$route(
  path: '/doctor-details',
  hasOverriddenOnExit: false,
  factory: $DoctorDetailsRoute._fromState,
);

mixin $DoctorDetailsRoute on GoRouteData {
  static DoctorDetailsRoute _fromState(GoRouterState state) =>
      DoctorDetailsRoute(state.extra as DoctorModel);

  DoctorDetailsRoute get _self => this as DoctorDetailsRoute;

  @override
  String get location => GoRouteData.$location('/doctor-details');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $selectTimeRoute => GoRouteData.$route(
  path: '/select-time',
  hasOverriddenOnExit: false,
  factory: $SelectTimeRoute._fromState,
);

mixin $SelectTimeRoute on GoRouteData {
  static SelectTimeRoute _fromState(GoRouterState state) =>
      SelectTimeRoute(state.extra as DoctorModel);

  SelectTimeRoute get _self => this as SelectTimeRoute;

  @override
  String get location => GoRouteData.$location('/select-time');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $bookingReviewRoute => GoRouteData.$route(
  path: '/booking/review',
  hasOverriddenOnExit: false,
  factory: $BookingReviewRoute._fromState,
);

mixin $BookingReviewRoute on GoRouteData {
  static BookingReviewRoute _fromState(GoRouterState state) =>
      BookingReviewRoute(state.extra as BookingDraft);

  BookingReviewRoute get _self => this as BookingReviewRoute;

  @override
  String get location => GoRouteData.$location('/booking/review');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $editProfileRoute => GoRouteData.$route(
  path: '/profile/edit',
  hasOverriddenOnExit: false,
  factory: $EditProfileRoute._fromState,
);

mixin $EditProfileRoute on GoRouteData {
  static EditProfileRoute _fromState(GoRouterState state) =>
      EditProfileRoute(state.extra as UserProfileModel?);

  EditProfileRoute get _self => this as EditProfileRoute;

  @override
  String get location => GoRouteData.$location('/profile/edit');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $patientSettingsRoute => GoRouteData.$route(
  path: '/settings',
  hasOverriddenOnExit: false,
  factory: $PatientSettingsRoute._fromState,
);

mixin $PatientSettingsRoute on GoRouteData {
  static PatientSettingsRoute _fromState(GoRouterState state) =>
      const PatientSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $changePasswordRoute => GoRouteData.$route(
  path: '/settings/change-password',
  hasOverriddenOnExit: false,
  factory: $ChangePasswordRoute._fromState,
);

mixin $ChangePasswordRoute on GoRouteData {
  static ChangePasswordRoute _fromState(GoRouterState state) =>
      const ChangePasswordRoute();

  @override
  String get location => GoRouteData.$location('/settings/change-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $privacyPolicyRoute => GoRouteData.$route(
  path: '/settings/privacy-policy',
  hasOverriddenOnExit: false,
  factory: $PrivacyPolicyRoute._fromState,
);

mixin $PrivacyPolicyRoute on GoRouteData {
  static PrivacyPolicyRoute _fromState(GoRouterState state) =>
      const PrivacyPolicyRoute();

  @override
  String get location => GoRouteData.$location('/settings/privacy-policy');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $patientAppointmentDetailsRoute => GoRouteData.$route(
  path: '/appointments/details',
  hasOverriddenOnExit: false,
  factory: $PatientAppointmentDetailsRoute._fromState,
);

mixin $PatientAppointmentDetailsRoute on GoRouteData {
  static PatientAppointmentDetailsRoute _fromState(GoRouterState state) =>
      PatientAppointmentDetailsRoute(state.extra as AppointmentModel);

  PatientAppointmentDetailsRoute get _self =>
      this as PatientAppointmentDetailsRoute;

  @override
  String get location => GoRouteData.$location('/appointments/details');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $patientRateDoctorRoute => GoRouteData.$route(
  path: '/appointments/rate',
  hasOverriddenOnExit: false,
  factory: $PatientRateDoctorRoute._fromState,
);

mixin $PatientRateDoctorRoute on GoRouteData {
  static PatientRateDoctorRoute _fromState(GoRouterState state) =>
      PatientRateDoctorRoute(state.extra as AppointmentModel);

  PatientRateDoctorRoute get _self => this as PatientRateDoctorRoute;

  @override
  String get location => GoRouteData.$location('/appointments/rate');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}
