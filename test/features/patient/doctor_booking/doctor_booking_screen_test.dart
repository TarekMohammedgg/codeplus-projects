import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/screens/doctor_booking_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/date_selector_list.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/no_slots_available_section.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

class _FakeBookingRepository implements BookingRepository {
  _FakeBookingRepository({this.booked = const []});
  final List<DateTime> booked;

  @override
  Future<Set<DateTime>> fetchBookedStarts(
    String doctorId,
    DateTime day,
  ) async {
    return booked
        .where(
          (b) => b.year == day.year && b.month == day.month && b.day == day.day,
        )
        .toSet();
  }
}

void main() {
  final availability = DoctorAvailability(
    workingDays: const [1, 2, 3, 4, 5, 6, 7],
    startMinutes: 9 * 60, // 09:00
    endMinutes: 17 * 60, // 17:00
    slotMinutes: 60,
  );

  final testDoctorWithAvail = DoctorModel(
    id: 'test_doc_1',
    name: 'Dr. Test Specialist',
    specialty: 'Cardiologist',
    consultationFee: 35.0,
    availability: availability,
  );

  final testDoctorNoAvail = const DoctorModel(
    id: 'test_doc_2',
    name: 'Dr. No Avail',
    specialty: 'Cardiologist',
  );

  setUp(() {
    ensureTestServiceLocator();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<BookingRepository>(
      () => _FakeBookingRepository(),
    );
    getIt.allowReassignment = false;
  });

  testWidgets('Doctor without availability shows doctorNoAvailableTimes', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      buildTestApp(DoctorBookingScreen(doctor: testDoctorNoAvail)),
    );
    await tester.pumpAndSettle();

    expect(find.text(tr.doctorNoAvailableTimes), findsOneWidget);
    expect(find.byType(DateSelectorList), findsNothing);
  });

  testWidgets(
    'Doctor with availability renders DoctorProfileCard, DateSelectorList and slots',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final now = DateTime.now();
      final todayAt8Am = DateTime(now.year, now.month, now.day, 8, 0);

      await tester.pumpWidget(
        buildTestApp(
          DoctorBookingScreen(
            doctor: testDoctorWithAvail,
            initialTime: todayAt8Am,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.selectTime), findsOneWidget);
      expect(find.byType(DoctorProfileCard), findsOneWidget);
      expect(find.text('Dr. Test Specialist'), findsOneWidget);
      expect(find.byType(DateSelectorList), findsOneWidget);
      expect(find.byType(TimeSlotsSection), findsWidgets);
    },
  );

  testWidgets('Slot selection enables Next button and navigation proceeds', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final now = DateTime.now();
    final todayAt8Am = DateTime(now.year, now.month, now.day, 8, 0);

    final router = GoRouter(
      initialLocation: '/booking',
      routes: [
        GoRoute(
          path: '/booking',
          builder: (context, state) => DoctorBookingScreen(
            doctor: testDoctorWithAvail,
            initialTime: todayAt8Am,
          ),
        ),
        GoRoute(
          path: '/booking-review',
          builder: (context, state) =>
              const Scaffold(body: Text('Booking Review Screen')),
        ),
      ],
    );

    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pumpAndSettle();

    // Find the Next button
    final nextButtonFinder = find.widgetWithText(AppPrimaryButton, tr.next);
    expect(nextButtonFinder, findsOneWidget);

    // Initially next button is disabled
    final nextButtonBefore = tester.widget<AppPrimaryButton>(nextButtonFinder);
    expect(nextButtonBefore.onPressed, isNull);

    // Tap the first slot chip inside TimeSlotsSection
    final firstSlotFinder = find
        .descendant(
          of: find.byType(TimeSlotsSection).first,
          matching: find.byType(InkWell),
        )
        .first;
    await tester.tap(firstSlotFinder);
    await tester.pumpAndSettle();

    // Button is now enabled
    final nextButtonAfter = tester.widget<AppPrimaryButton>(nextButtonFinder);
    expect(nextButtonAfter.onPressed, isNotNull);

    // Tap Next and verify navigation to booking review screen
    await tester.tap(nextButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Booking Review Screen'), findsOneWidget);
  });

  testWidgets('Fully booked day displays NoSlotsAvailableSection', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final now = DateTime.now();
    final todayAt8Am = DateTime(now.year, now.month, now.day, 8, 0);

    // Generate all slots for today so it's fully booked
    final allSlotsToday = List.generate(
      8,
      (i) => DateTime(now.year, now.month, now.day, 9 + i),
    );

    getIt.allowReassignment = true;
    getIt.registerLazySingleton<BookingRepository>(
      () => _FakeBookingRepository(booked: allSlotsToday),
    );
    getIt.allowReassignment = false;

    await tester.pumpWidget(
      buildTestApp(
        DoctorBookingScreen(
          doctor: testDoctorWithAvail,
          initialTime: todayAt8Am,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NoSlotsAvailableSection), findsOneWidget);
  });
}
