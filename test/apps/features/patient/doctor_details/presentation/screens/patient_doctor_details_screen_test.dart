import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/screens/patient_doctor_details_screen.dart';
import 'package:doctor_hunt/apps/core/widgets/clinic_location_map.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import '../../../../../../helpers/test_app.dart';
import '../../../../../../helpers/test_fakes.dart';

const _doctor = DoctorModel(
  id: 'doc-1',
  nameEn: 'Dr. Sara',
  specialtyEn: 'Dentist',
  rating: 4.7,
  reviewsCount: 24,
);

void main() {
  Future<void> pumpDetails(
    WidgetTester tester,
    FakeDoctorDetailsRepository repository, {
    DoctorModel doctor = _doctor,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      buildTestApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<DoctorDetailsCubit>(
              create: (_) => DoctorDetailsCubit(repository: repository),
            ),
            BlocProvider<BookingCubit>(
              create: (_) =>
                  BookingCubit(repository: FakeBookingRepository())
                    ..init(doctor),
            ),
          ],
          child: DoctorDetailsScreen(doctor: doctor),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows the profile card, rating summary and empty reviews', (
    WidgetTester tester,
  ) async {
    await pumpDetails(tester, FakeDoctorDetailsRepository());

    final tr = AppLocale.en.buildSync();
    expect(find.byType(DoctorProfileCard), findsOneWidget);
    expect(
      find.text(tr.ratingSummary(rating: '4.7', count: 24)),
      findsOneWidget,
    );
    expect(find.text(tr.noReviewsYet), findsOneWidget);
    expect(find.text(tr.clinicLocationNotSet), findsOneWidget);
  });

  testWidgets('shows recent reviews and the clinic address with a map', (
    WidgetTester tester,
  ) async {
    await pumpDetails(
      tester,
      FakeDoctorDetailsRepository(
        reviews: const [
          ReviewModel(
            appointmentId: 'appt-1',
            patientId: 'patient-1',
            patientName: 'Mona',
            doctorId: 'doc-1',
            rating: 5,
            comment: 'Great doctor',
          ),
        ],
        clinic: const ClinicModel(
          addressAr: 'القاهرة',
          addressEn: '12 Nile St, Cairo',
          location: LatLng(30.0444, 31.2357),
        ),
      ),
    );

    expect(find.text('Mona'), findsOneWidget);
    expect(find.text('Great doctor'), findsOneWidget);
    expect(find.text('12 Nile St, Cairo'), findsOneWidget);
    expect(find.byType(ClinicLocationMap), findsOneWidget);
  });

  testWidgets('ClinicLocationMap renders a map with one marker', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: ClinicLocationMap(location: LatLng(30.0444, 31.2357)),
        ),
      ),
    );

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(TileLayer), findsOneWidget);
    expect(find.byType(MarkerLayer), findsOneWidget);
    expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
  });

  testWidgets(
    'shows the next available slots when the doctor has availability',
    (WidgetTester tester) async {
      // arrange
      final doctor = DoctorModel(
        id: 'doc-1',
        nameEn: 'Dr. Sara',
        availability: DoctorAvailability(
          workingDays: const [1, 2, 3, 4, 5, 6, 7],
          startMinutes: 0,
          endMinutes: 24 * 60,
          slotMinutes: 60,
        ),
      );

      // act
      await pumpDetails(tester, FakeDoctorDetailsRepository(), doctor: doctor);

      // assert
      expect(
        find.text(AppLocale.en.buildSync().availableSlots),
        findsOneWidget,
      );
      expect(find.byType(TimeSlotsSection), findsOneWidget);
    },
  );

  testWidgets('shows the no available times message without availability', (
    WidgetTester tester,
  ) async {
    // act
    await pumpDetails(tester, FakeDoctorDetailsRepository());

    // assert
    expect(
      find.text(AppLocale.en.buildSync().doctorNoAvailableTimes),
      findsOneWidget,
    );
  });
}
