import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/screens/booking_review_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/booking_success_dialog.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

void main() {
  const testDoctor = DoctorModel(
    id: 'doc_review_1',
    nameEn: 'Dr. Sarah Connor',
    specialtyEn: 'Cardiologist',
    consultationFee: 50.0,
    rating: 4.8,
    reviewsCount: 15,
  );
  final testDraft = BookingDraft(
    doctor: testDoctor,
    startAt: DateTime(2026, 10, 15, 10, 30),
  );
  final tr = AppLocale.en.buildSync();

  late FakeBookingRepository repository;
  bool? poppedWith;

  setUp(() {
    repository = FakeBookingRepository();
    poppedWith = null;
  });

  tearDown(() => repository.clinic.close());

  Future<GoRouter> pumpReview(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final router = GoRouter(
      initialLocation: '/slots',
      routes: [
        GoRoute(
          path: '/slots',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () async {
                poppedWith = await context.push<bool>('/review');
              },
              child: const Text('open review'),
            ),
          ),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => BlocProvider<BookingCubit>(
            create: (_) => BookingCubit(repository: repository),
            child: BookingReviewScreen(draft: testDraft),
          ),
        ),
        GoRoute(
          path: '/appointments',
          builder: (context, state) => const Scaffold(body: Text('mine')),
        ),
      ],
    );
    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open review'));
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('renders doctor, booking info and the live clinic location', (
    WidgetTester tester,
  ) async {
    await pumpReview(tester);
    expect(find.text(tr.clinicLocationNotSet), findsOneWidget);

    repository.clinic.add(
      const ClinicModel(
        addressAr: 'القاهرة',
        addressEn: '123 Medical Plaza',
        location: LatLng(30.0444, 31.2357),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DoctorProfileCard), findsOneWidget);
    expect(find.text(tr.appointmentDate), findsOneWidget);
    expect(find.text(tr.appointmentTime), findsOneWidget);
    expect(find.text(tr.consultationFee), findsOneWidget);
    expect(find.text('123 Medical Plaza'), findsOneWidget);
  });

  testWidgets(
    'confirm books the slot, shows success, Done opens appointments',
    (WidgetTester tester) async {
      final router = await pumpReview(tester);
      await tester.tap(find.text(tr.confirmBooking));
      await tester.pumpAndSettle();
      expect(repository.bookedDrafts.single.doctor.id, 'doc_review_1');
      expect(find.byType(BookingSuccessDialog), findsOneWidget);

      await tester.tap(find.text(tr.done));
      await tester.pumpAndSettle();

      expect(router.state.matchedLocation, '/appointments');
    },
  );

  testWidgets('slot taken shows the message and returns to reload slots', (
    WidgetTester tester,
  ) async {
    repository.bookError = const SlotAlreadyBookedException();
    await pumpReview(tester);

    await tester.tap(find.text(tr.confirmBooking));
    await tester.pumpAndSettle();

    expect(find.text(tr.slotAlreadyBooked), findsOneWidget);
    expect(find.byType(BookingReviewScreen), findsNothing);
    expect(poppedWith, isTrue);
  });
}
