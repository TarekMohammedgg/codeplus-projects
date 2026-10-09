import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';
import 'package:doctor_hunt/apps/features/common/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:doctor_hunt/apps/features/common/onboarding/data/onboarding_data.dart';
import 'package:doctor_hunt/apps/features/common/onboarding/data/models/onboarding_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

void main() {
  testWidgets('OnboardingScreen renders Doctor Hunt UI properly', (
    WidgetTester tester,
  ) async {
    final pages = onboardingPages();
    final prefs = FakeSharedPreferences();
    final service = AppPreferencesService(preferences: prefs);

    await tester.pumpWidget(
      buildTestApp(OnboardingScreen(preferencesService: service)),
    );

    expect(find.text(tr.skip), findsOneWidget);

    expect(find.text(tr.onboardingTitle1), findsOneWidget);
    expect(find.text(tr.onboardingSubtitle1), findsOneWidget);
    expect(find.byType(SmoothPageIndicator), findsOneWidget);
    expect(find.byType(SafeArea), findsNothing);

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.fit, BoxFit.contain);
    expect(image.alignment, Alignment.centerLeft);

    expect(pages.first.imageAlignment, OnboardingImageAlignment.left);
    expect(pages[1].imageAlignment, OnboardingImageAlignment.right);
    expect(pages.last.imageAlignment, OnboardingImageAlignment.left);
  });

  testWidgets('OnboardingScreen onSkip sets hasSeenOnboarding to true', (
    WidgetTester tester,
  ) async {
    final prefs = FakeSharedPreferences();
    final service = AppPreferencesService(preferences: prefs);

    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => OnboardingScreen(preferencesService: service),
        ),
        GoRoute(path: '/role-selection', builder: (_, _) => const Scaffold()),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.skip));
    await tester.pumpAndSettle();

    expect(service.hasSeenOnboarding, isTrue);
  });
}
