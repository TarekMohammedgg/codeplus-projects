import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';
import 'package:doctor_hunt/apps/features/common/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/presentation/screens/role_selection_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/router/app_router.dart';
import '../../../helpers/test_app.dart';

void main() {
  setUp(() {
    ensureTestServiceLocator();
    AppRouter.resetForTesting();
  });

  testWidgets('app starts on onboarding screen for new users', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestRouterApp(AppRouter.router));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets(
    'app starts on role selection screen when onboarding was already seen',
    (WidgetTester tester) async {
      await getIt<AppPreferencesService>().setHasSeenOnboarding(true);

      await tester.pumpWidget(buildTestRouterApp(AppRouter.router));
      await tester.pumpAndSettle();

      expect(find.byType(RoleSelectionScreen), findsOneWidget);
    },
  );
}
