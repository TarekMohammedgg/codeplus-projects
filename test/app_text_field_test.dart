import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/widgets/auth_text_field.dart';
import 'test_app.dart';

void main() {
  group('AppTextField', () {
    testWidgets('renders hint text and accepts text input via controller', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppTextField(
              controller: controller,
              hintText: 'Enter your name',
            ),
          ),
        ),
      );

      expect(find.text('Enter your name'), findsOneWidget);

      await tester.enterText(find.byType(AppTextField), 'John Doe');
      expect(controller.text, 'John Doe');
    });

    testWidgets('renders prefix icon when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: AppTextField(
              prefixIcon: Icons.email_outlined,
              hintText: 'Email',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('toggles password visibility when isPassword is true', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController(text: 'secret123');

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppTextField(
              controller: controller,
              isPassword: true,
              hintText: 'Password',
            ),
          ),
        ),
      );

      // Initially obscureText is true, so visibility_outlined icon is shown
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap suffix icon button to show password
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Now visibility_off_outlined icon is shown
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('displays validation error message when validated', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: Form(
              key: formKey,
              child: AppTextField(
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Field is required'), findsOneWidget);
    });

    testWidgets('triggers onChanged and onFieldSubmitted callbacks', (
      WidgetTester tester,
    ) async {
      String changedValue = '';
      String submittedValue = '';

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppTextField(
              onChanged: (val) => changedValue = val,
              onFieldSubmitted: (val) => submittedValue = val,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(AppTextField), 'Hello World');
      expect(changedValue, 'Hello World');

      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submittedValue, 'Hello World');
    });
  });

  group('AuthTextField delegation', () {
    testWidgets(
      'renders properly with prefix icon and delegates to AppTextField',
      (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestApp(
            Scaffold(
              body: AuthTextField(
                controller: controller,
                prefixIcon: Icons.lock_outline,
                hintText: 'Auth Password',
                isPassword: true,
              ),
            ),
          ),
        );

        expect(find.byType(AppTextField), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.text('Auth Password'), findsOneWidget);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      },
    );
  });
}
