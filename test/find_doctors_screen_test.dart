import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

List<DoctorModel> testFindDoctors() {
  return const [
    DoctorModel(
      id: 'doc_1',
      name: 'Dr. Shruti Kedia',
      specialty: 'Dentist',
      isFavorite: true,
    ),
    DoctorModel(
      id: 'doc_5',
      name: 'Dr. Fillerup Grab',
      specialty: 'Medicine Specialist',
      isFavorite: false,
    ),
  ];
}

void main() {
  testWidgets('FindDoctorsScreen renders search bar and doctor cards', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final tr = AppLocale.en.buildSync();
    await tester.pumpWidget(
      buildTestApp(FindDoctorsScreen(initialDoctors: testFindDoctors())),
    );
    await tester.pump();

    expect(find.text(tr.searchDoctorHint), findsOneWidget);
    expect(find.text('Dr. Shruti Kedia'), findsOneWidget);
    expect(find.text('Dr. Fillerup Grab'), findsOneWidget);
  });

  testWidgets('FindDoctorsScreen renders favorite icons statelessly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      buildTestApp(FindDoctorsScreen(initialDoctors: testFindDoctors())),
    );
    await tester.pump();

    expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
    expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
  });
}
