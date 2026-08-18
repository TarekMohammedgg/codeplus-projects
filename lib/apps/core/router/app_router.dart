import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:medora/generated/app_strings.dart';
import 'routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.onboarding,
    overridePlatformDefaultLocation: true,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnBoardingPage(),
      ),
      GoRoute(
        path: Routes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.otpVerification,
        builder: (context, state) {
          final phone = state.extra as String?;
          return OtpVerificationScreen(
            phoneNumber: phone ?? AppStrings.defaultPhoneNumber,
          );
        },
      ),
      GoRoute(
        path: Routes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
