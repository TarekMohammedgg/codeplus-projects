import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/widgets/app_empty_state.dart';
import 'package:doctor_hunt/generated/app_image.dart';

void main() {
  testWidgets('AppEmptyState renders title and empty state image', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppEmptyState(title: 'No Data Available')),
      ),
    );

    expect(find.text('No Data Available'), findsOneWidget);
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    final imageWidget = tester.widget<Image>(imageFinder);
    expect(imageWidget.image, isA<AssetImage>());
    final assetImage = imageWidget.image as AssetImage;
    expect(assetImage.assetName, Assets.assetsEmptyState);
  });

  testWidgets(
    'AppEmptyState renders subtitle and action widget when provided',
    (WidgetTester tester) async {
      var actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEmptyState(
              title: 'Empty List',
              subtitle: 'Try adding new items.',
              action: ElevatedButton(
                onPressed: () => actionTapped = true,
                child: const Text('Add Item'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Empty List'), findsOneWidget);
      expect(find.text('Try adding new items.'), findsOneWidget);
      expect(find.text('Add Item'), findsOneWidget);

      await tester.tap(find.text('Add Item'));
      await tester.pump();

      expect(actionTapped, isTrue);
    },
  );
}
