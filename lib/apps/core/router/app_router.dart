import 'package:go_router/go_router.dart';

import 'routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: const OnboardingRoute().location,
    overridePlatformDefaultLocation: true,
    routes: $appRoutes,
  );
}
