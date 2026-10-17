import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('leading variant keeps the 30dp box inside an AppBar', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        Scaffold(appBar: AppBar(leading: const AppBackButton.leading())),
      ),
    );

    expect(
      tester.getSize(find.byType(AppIconButton)),
      const Size.square(AppBackButton.size),
    );
  });

  testWidgets('tapping without onTap pops the current route', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: AppBackButton()),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(AppBackButton), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });
}
