import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/screens/patient_doctor_details_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/doctor_location_map.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets('DoctorDetailsScreen renders the doctor profile card', (
    WidgetTester tester,
  ) async {
    // arrange
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // act
    await tester.pumpWidget(
      buildTestApp(DoctorDetailsScreen(doctor: DoctorModel.placeholder())),
    );

    // assert
    expect(find.byType(DoctorProfileCard), findsOneWidget);
  });

  testWidgets('DoctorLocationMap renders a map with one marker', (
    WidgetTester tester,
  ) async {
    // act
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: DoctorLocationMap(location: LatLng(30.0444, 31.2357)),
        ),
      ),
    );

    // assert
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(TileLayer), findsOneWidget);
    expect(find.byType(MarkerLayer), findsOneWidget);
    expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
  });
}
