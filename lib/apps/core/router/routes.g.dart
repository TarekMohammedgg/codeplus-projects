// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $onboardingRoute,
  $loginRoute,
  $signupRoute,
  $otpVerificationRoute,
  $resetPasswordRoute,
  $roleSelectionRoute,
  $adminLoginRoute,
  $adminDoctorsRoute,
  $createDoctorRoute,
  $adminSettingsRoute,
  $homeRoute,
  $findDoctorsRoute,
  $doctorDetailsRoute,
  $favouriteDoctorsRoute,
  $selectTimeRoute,
  $profileRoute,
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
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

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

RouteBase get $otpVerificationRoute => GoRouteData.$route(
  path: '/otp-verification',
  hasOverriddenOnExit: false,
  factory: $OtpVerificationRoute._fromState,
);

mixin $OtpVerificationRoute on GoRouteData {
  static OtpVerificationRoute _fromState(GoRouterState state) =>
      OtpVerificationRoute(state.extra as String?);

  OtpVerificationRoute get _self => this as OtpVerificationRoute;

  @override
  String get location => GoRouteData.$location('/otp-verification');

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

RouteBase get $resetPasswordRoute => GoRouteData.$route(
  path: '/reset-password',
  hasOverriddenOnExit: false,
  factory: $ResetPasswordRoute._fromState,
);

mixin $ResetPasswordRoute on GoRouteData {
  static ResetPasswordRoute _fromState(GoRouterState state) =>
      const ResetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/reset-password');

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

RouteBase get $adminLoginRoute => GoRouteData.$route(
  path: '/admin-login',
  hasOverriddenOnExit: false,
  factory: $AdminLoginRoute._fromState,
);

mixin $AdminLoginRoute on GoRouteData {
  static AdminLoginRoute _fromState(GoRouterState state) =>
      const AdminLoginRoute();

  @override
  String get location => GoRouteData.$location('/admin-login');

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

RouteBase get $adminDoctorsRoute => GoRouteData.$route(
  path: '/admin/doctors',
  hasOverriddenOnExit: false,
  factory: $AdminDoctorsRoute._fromState,
);

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

RouteBase get $createDoctorRoute => GoRouteData.$route(
  path: '/admin/doctors/create',
  hasOverriddenOnExit: false,
  factory: $CreateDoctorRoute._fromState,
);

mixin $CreateDoctorRoute on GoRouteData {
  static CreateDoctorRoute _fromState(GoRouterState state) =>
      CreateDoctorRoute(state.extra as AdminDoctorModel?);

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

RouteBase get $adminSettingsRoute => GoRouteData.$route(
  path: '/admin/settings',
  hasOverriddenOnExit: false,
  factory: $AdminSettingsRoute._fromState,
);

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

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/home',
  hasOverriddenOnExit: false,
  factory: $HomeRoute._fromState,
);

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

RouteBase get $findDoctorsRoute => GoRouteData.$route(
  path: '/find-doctors',
  hasOverriddenOnExit: false,
  factory: $FindDoctorsRoute._fromState,
);

mixin $FindDoctorsRoute on GoRouteData {
  static FindDoctorsRoute _fromState(GoRouterState state) =>
      const FindDoctorsRoute();

  @override
  String get location => GoRouteData.$location('/find-doctors');

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

RouteBase get $doctorDetailsRoute => GoRouteData.$route(
  path: '/doctor-details',
  hasOverriddenOnExit: false,
  factory: $DoctorDetailsRoute._fromState,
);

mixin $DoctorDetailsRoute on GoRouteData {
  static DoctorDetailsRoute _fromState(GoRouterState state) =>
      DoctorDetailsRoute(state.extra as DoctorModel?);

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

RouteBase get $favouriteDoctorsRoute => GoRouteData.$route(
  path: '/favourite-doctors',
  hasOverriddenOnExit: false,
  factory: $FavouriteDoctorsRoute._fromState,
);

mixin $FavouriteDoctorsRoute on GoRouteData {
  static FavouriteDoctorsRoute _fromState(GoRouterState state) =>
      const FavouriteDoctorsRoute();

  @override
  String get location => GoRouteData.$location('/favourite-doctors');

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

RouteBase get $selectTimeRoute => GoRouteData.$route(
  path: '/select-time',
  hasOverriddenOnExit: false,
  factory: $SelectTimeRoute._fromState,
);

mixin $SelectTimeRoute on GoRouteData {
  static SelectTimeRoute _fromState(GoRouterState state) =>
      SelectTimeRoute(state.extra as DoctorModel?);

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

RouteBase get $profileRoute => GoRouteData.$route(
  path: '/profile',
  hasOverriddenOnExit: false,
  factory: $ProfileRoute._fromState,
);

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) =>
      ProfileRoute(state.extra as UserProfileModel?);

  ProfileRoute get _self => this as ProfileRoute;

  @override
  String get location => GoRouteData.$location('/profile');

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
