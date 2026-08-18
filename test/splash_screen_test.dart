import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medora/apps/core/router/app_router.dart';
import 'package:medora/apps/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('app starts on onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.router));

    expect(find.byType(OnBoardingPage), findsOneWidget);
  });
}
