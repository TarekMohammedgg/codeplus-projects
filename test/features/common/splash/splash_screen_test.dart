import 'package:doctor_hunt/apps/features/common/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/router/app_router.dart';
import '../../../helpers/test_app.dart';

void main() {
  setUp(() {
    ensureTestServiceLocator();
    AppRouter.resetForTesting();
  });

  testWidgets('app starts on onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestRouterApp(AppRouter.router));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
