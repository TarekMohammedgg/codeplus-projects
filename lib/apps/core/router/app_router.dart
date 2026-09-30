import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';

import 'routes.dart';

class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable([FirebaseAuth? auth]) {
    final firebaseAuth = auth ?? getIt<FirebaseAuth>();
    _subscription = firebaseAuth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

Future<String?> appRouterRedirect(
  BuildContext context,
  GoRouterState state, {
  AuthRepository? authRepository,
}) async {
  final authRepo = authRepository ?? getIt<AuthRepository>();
  final user = authRepo.currentUser;
  final loc = state.matchedLocation;

  final isPublic =
      loc == AppRoutePaths.onboarding ||
      loc == AppRoutePaths.roleSelection ||
      loc == AppRoutePaths.login ||
      loc == AppRoutePaths.signup;

  if (user == null) {
    return isPublic ? null : const RoleSelectionRoute().location;
  }

  final isOnboardingOrRole =
      loc == AppRoutePaths.onboarding || loc == AppRoutePaths.roleSelection;
  if (isOnboardingOrRole) {
    final isAdmin = await authRepo.isCurrentUserAdmin();
    return isAdmin ? AppRoutePaths.adminDoctors : AppRoutePaths.home;
  }

  if (loc.startsWith('/admin')) {
    final isAdmin = await authRepo.isCurrentUserAdmin();
    if (!isAdmin) {
      return AppRoutePaths.home;
    }
  }

  return null;
}

abstract final class AppRouter {
  static GoRouter? _router;

  static GoRouter get router => _router ??= createRouter();

  @visibleForTesting
  static void resetForTesting() {
    _router?.dispose();
    _router = null;
  }

  static GoRouter createRouter({
    AuthRepository? authRepository,
    FirebaseAuth? firebaseAuth,
    String? initialLocation,
    List<RouteBase>? routes,
  }) {
    return GoRouter(
      initialLocation: initialLocation ?? const OnboardingRoute().location,
      overridePlatformDefaultLocation: true,
      routes: routes ?? $appRoutes,
      refreshListenable: AuthRefreshListenable(firebaseAuth),
      redirect: (context, state) =>
          appRouterRedirect(context, state, authRepository: authRepository),
    );
  }
}
