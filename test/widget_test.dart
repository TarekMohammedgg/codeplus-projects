import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/main.dart';
import 'test_app.dart';

void main() {
  testWidgets('DoctorHuntApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(const DoctorHuntApp()));
    expect(find.byType(DoctorHuntApp), findsOneWidget);
  });
}
