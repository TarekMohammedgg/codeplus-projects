import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/screens/booking_review_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

class _FakeClinicService implements ClinicService {
  _FakeClinicService(this._controller);
  final StreamController<ClinicModel?> _controller;

  @override
  Stream<ClinicModel?> streamClinic() => _controller.stream;

  @override
  Future<ClinicModel?> fetchClinic() async => null;

  @override
  Future<void> updateClinic({
    required String addressAr,
    required String addressEn,
    required LatLng location,
  }) async {}
}

void main() {
  final testDoctor = const DoctorModel(
    id: 'doc_review_1',
    name: 'Dr. Sarah Connor',
    specialty: 'Cardiologist',
    consultationFee: 50.0,
    rating: 4.8,
    reviewsCount: 15,
  );

  final testDraft = BookingDraft(
    doctor: testDoctor,
    startAt: DateTime(2026, 10, 15, 10, 30),
  );

  setUp(() {
    ensureTestServiceLocator();
  });

  testWidgets(
    'BookingReviewScreen renders doctor card, booking info, and confirm button',
    (WidgetTester tester) async {
      final clinicController = StreamController<ClinicModel?>.broadcast();
      addTearDown(clinicController.close);
      final fakeService = _FakeClinicService(clinicController);

      await tester.pumpWidget(
        buildTestApp(
          BookingReviewScreen(
            draft: testDraft,
            clinicService: fakeService,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DoctorProfileCard), findsOneWidget);
      expect(find.text('Dr. Sarah Connor'), findsOneWidget);
      expect(find.text('Cardiologist'), findsOneWidget);
      expect(find.text('\$50.00'), findsWidgets);

      expect(find.text(tr.bookingReview), findsOneWidget);
      expect(find.text(tr.appointmentDate), findsOneWidget);
      expect(find.text(tr.appointmentTime), findsOneWidget);
      expect(find.text(tr.consultationFee), findsOneWidget);

      expect(find.byType(AppPrimaryButton), findsOneWidget);
      expect(find.text(tr.confirmBooking), findsOneWidget);
    },
  );

  testWidgets(
    'BookingReviewScreen displays clinic address and reacts to clinic stream updates',
    (WidgetTester tester) async {
      final clinicController = StreamController<ClinicModel?>.broadcast();
      addTearDown(clinicController.close);
      final fakeService = _FakeClinicService(clinicController);

      await tester.pumpWidget(
        buildTestApp(
          BookingReviewScreen(
            draft: testDraft,
            clinicService: fakeService,
          ),
        ),
      );
      await tester.pump();

      // Initially null -> shows clinicLocationNotSet
      expect(find.text(tr.clinicLocationNotSet), findsOneWidget);

      // Emit clinic update
      clinicController.add(
        const ClinicModel(
          addressAr: 'شارع التحرير، القاهرة',
          addressEn: '123 Medical Plaza, Suite 400',
          location: LatLng(30.0444, 31.2357),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('123 Medical Plaza, Suite 400'), findsOneWidget);
      expect(find.text(tr.clinicLocationNotSet), findsNothing);
    },
  );

  testWidgets('Tapping confirm button triggers onConfirm callback', (
    WidgetTester tester,
  ) async {
    final clinicController = StreamController<ClinicModel?>.broadcast();
    addTearDown(clinicController.close);
    final fakeService = _FakeClinicService(clinicController);
    var confirmed = false;

    await tester.pumpWidget(
      buildTestApp(
        BookingReviewScreen(
          draft: testDraft,
          clinicService: fakeService,
          onConfirm: () async {
            confirmed = true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppPrimaryButton));
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
  });
}
