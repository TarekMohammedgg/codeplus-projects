import 'package:flutter_test/flutter_test.dart';
import 'package:medora/main.dart';

void main() {
  testWidgets('MedoraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MedoraApp());
    expect(find.byType(MedoraApp), findsOneWidget);
  });
}
