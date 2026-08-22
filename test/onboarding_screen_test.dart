import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:doctor_hunt/apps/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:doctor_hunt/apps/features/onboarding/data/onboarding_data.dart';
import 'package:doctor_hunt/apps/features/onboarding/data/models/onboarding_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets('OnboardingScreen renders Doctor Hunt UI properly', (
    WidgetTester tester,
  ) async {
    final t = AppLocale.en.buildSync();
    final pages = onboardingPages(t);

    await tester.pumpWidget(buildTestApp(const OnboardingScreen()));

    expect(find.text(t.skip), findsOneWidget);

    expect(find.text(t.onboardingTitle1), findsOneWidget);
    expect(find.text(t.onboardingSubtitle1), findsOneWidget);
    expect(find.byType(SmoothPageIndicator), findsOneWidget);
    expect(find.byType(SafeArea), findsNothing);

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.fit, BoxFit.contain);
    expect(image.alignment, Alignment.centerLeft);

    expect(pages.first.imageAlignment, OnboardingImageAlignment.left);
    expect(pages[1].imageAlignment, OnboardingImageAlignment.right);
    expect(pages.last.imageAlignment, OnboardingImageAlignment.left);
  });
}
