import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/data/doctors_data.dart';

import 'package:doctor_hunt/apps/features/doctors/presentation/screens/doctor_details_screen.dart';
import 'test_app.dart';

void main() {
  testWidgets('DoctorDetailsScreen renders DoctorLocationMap and FlutterMap', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final doctor = defaultDoctorDetails();

    await tester.pumpWidget(buildTestApp(DoctorDetailsScreen(doctor: doctor)));

    expect(find.byType(DoctorLocationMap), findsOneWidget);
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(TileLayer), findsOneWidget);
    expect(find.byType(MarkerLayer), findsOneWidget);
    expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
  });
}
