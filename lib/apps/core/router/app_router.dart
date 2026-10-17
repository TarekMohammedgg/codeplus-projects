import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';

import 'routes.dart';

class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(FirebaseAuth auth) {
    _subscription = auth.authStateChanges().listen((_) {
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
  required AuthRepository authRepository,
  required AppPreferencesService preferencesService,
}) async {
  final authRepo = authRepository;
  final user = authRepo.currentUser;
  final loc = state.matchedLocation;
  final hasSeenOnboarding = preferencesService.hasSeenOnboarding;

  final isPublic =
      loc == AppRoutePaths.onboarding ||
      loc == AppRoutePaths.roleSelection ||
      loc == AppRoutePaths.login ||
      loc == AppRoutePaths.signup;

  if (user == null) {
    if (loc == AppRoutePaths.onboarding && hasSeenOnboarding) {
      return const RoleSelectionRoute().location;
    }
    return isPublic ? null : const RoleSelectionRoute().location;
  }

  final isOnboardingOrRole =
      loc == AppRoutePaths.onboarding || loc == AppRoutePaths.roleSelection;
  final isAuthScreen =
      loc == AppRoutePaths.login || loc == AppRoutePaths.signup;
  if (isAuthScreen) return null;

  final isAdmin = await authRepo.isCurrentUserAdmin();
  final home = isAdmin ? AppRoutePaths.adminDoctors : AppRoutePaths.home;
  if (isOnboardingOrRole) return home;
  if (isAdmin != loc.startsWith('/admin')) return home;

  return null;
}

abstract final class AppRouter {
  static GoRouter? _router;

  static GoRouter get router => _router ??= createRouter(
    authRepository: getIt<AuthRepository>(),
    firebaseAuth: getIt<FirebaseAuth>(),
    preferencesService: getIt<AppPreferencesService>(),
  );

  @visibleForTesting
  static void resetForTesting() {
    _router?.dispose();
    _router = null;
  }

  static GoRouter createRouter({
    required AuthRepository authRepository,
    required FirebaseAuth firebaseAuth,
    required AppPreferencesService preferencesService,
    String? initialLocation,
    List<RouteBase>? routes,
  }) {
    final defaultInitial = authRepository.currentUser != null
        ? AppRoutePaths.home
        : (preferencesService.hasSeenOnboarding
              ? const RoleSelectionRoute().location
              : const OnboardingRoute().location);

    return GoRouter(
      initialLocation: initialLocation ?? defaultInitial,
      overridePlatformDefaultLocation: true,
      routes: routes ?? $appRoutes,
      refreshListenable: AuthRefreshListenable(firebaseAuth),
      redirect: (context, state) => appRouterRedirect(
        context,
        state,
        authRepository: authRepository,
        preferencesService: preferencesService,
      ),
    );
  }
}
