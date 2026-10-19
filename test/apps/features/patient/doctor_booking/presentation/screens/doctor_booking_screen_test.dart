import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/screens/doctor_booking_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/date_selector_list.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/no_slots_available_section.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../../../../helpers/test_app.dart';
import '../../../../../../helpers/test_fakes.dart';

void main() {
  final availability = DoctorAvailability(
    workingDays: const [1, 2, 3, 4, 5, 6, 7],
    startMinutes: 9 * 60,
    endMinutes: 17 * 60,
    slotMinutes: 60,
  );

  final testDoctorWithAvail = DoctorModel(
    id: 'test_doc_1',
    nameEn: 'Dr. Test Specialist',
    specialtyEn: 'Cardiologist',
    consultationFee: 35.0,
    availability: availability,
  );

  final testDoctorNoAvail = const DoctorModel(
    id: 'test_doc_2',
    nameEn: 'Dr. No Avail',
    specialtyEn: 'Cardiologist',
  );

  setUp(() {
    ensureTestServiceLocator();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<BookingRepository>(
      () => FakeBookingRepository(),
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

    await tester.pumpWidget(buildTestApp(_bookingScreen(testDoctorNoAvail)));
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
        buildTestApp(_bookingScreen(testDoctorWithAvail, now: todayAt8Am)),
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
          builder: (context, state) =>
              _bookingScreen(testDoctorWithAvail, now: todayAt8Am),
        ),
        GoRoute(
          path: AppRoutePaths.bookingReview,
          builder: (context, state) =>
              const Scaffold(body: Text('Booking Review Screen')),
        ),
      ],
    );

    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pumpAndSettle();

    final confirmButtonFinder = find.widgetWithText(
      AppPrimaryButton,
      tr.confirm,
    );
    expect(confirmButtonFinder, findsOneWidget);

    final confirmButtonBefore = tester.widget<AppPrimaryButton>(
      confirmButtonFinder,
    );
    expect(confirmButtonBefore.onPressed, isNull);

    final firstSlotFinder = find
        .descendant(
          of: find.byType(TimeSlotsSection).first,
          matching: find.byType(InkWell),
        )
        .first;
    await tester.tap(firstSlotFinder);
    await tester.pumpAndSettle();

    final confirmButtonAfter = tester.widget<AppPrimaryButton>(
      confirmButtonFinder,
    );
    expect(confirmButtonAfter.onPressed, isNotNull);

    await tester.tap(confirmButtonFinder);
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

    final allSlotsToday = List.generate(
      8,
      (i) => DateTime(now.year, now.month, now.day, 9 + i),
    );

    getIt.allowReassignment = true;
    getIt.registerLazySingleton<BookingRepository>(
      () => FakeBookingRepository(booked: allSlotsToday),
    );
    getIt.allowReassignment = false;

    await tester.pumpWidget(
      buildTestApp(_bookingScreen(testDoctorWithAvail, now: todayAt8Am)),
    );
    await tester.pumpAndSettle();

    final tr = AppLocale.en.buildSync();
    expect(find.byType(NoSlotsAvailableSection), findsOneWidget);
    expect(find.text(tr.noSlotsAvailable), findsWidgets);
    expect(find.widgetWithText(AppPrimaryButton, tr.confirm), findsNothing);
  });

  testWidgets('DateSelectorList displays slots available on date cards', (
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

    await tester.pumpWidget(
      buildTestApp(_bookingScreen(testDoctorWithAvail, now: todayAt8Am)),
    );
    await tester.pumpAndSettle();

    expect(find.text(tr.slotsAvailable(count: 8)), findsWidgets);
  });

  testWidgets('Tapping favorite heart toggles favorite in FavoritesCubit', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final favoritesRepo = FakeFavoritesRepository();
    final favoritesCubit = FavoritesCubit(repository: favoritesRepo);
    addTearDown(() => favoritesCubit.close());
    favoritesRepo.userIds.add('patient-1');

    final now = DateTime.now();
    final todayAt8Am = DateTime(now.year, now.month, now.day, 8, 0);

    await tester.pumpWidget(
      buildTestApp(
        BlocProvider<FavoritesCubit>.value(
          value: favoritesCubit,
          child: _bookingScreen(testDoctorWithAvail, now: todayAt8Am),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(favoritesRepo.writes.isNotEmpty, isTrue);
  });
}

Widget _bookingScreen(DoctorModel doctor, {DateTime? now}) {
  return BlocProvider<BookingCubit>(
    create: (_) => getIt<BookingCubit>()..init(doctor, now: now),
    child: DoctorBookingScreen(doctor: doctor),
  );
}
