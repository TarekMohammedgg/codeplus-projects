import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/router/app_router.dart';
import 'package:doctor_hunt/apps/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'test_app.dart';

void main() {
  testWidgets('app starts on onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestRouterApp(AppRouter.router));

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
