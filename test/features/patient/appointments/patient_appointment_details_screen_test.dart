import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/data/repositories/appointment_details_repository.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_cubit.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/screens/patient_appointment_details_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

class _FakeClinicService extends Fake implements ClinicService {
  _FakeClinicService({this.clinic});

  final ClinicModel? clinic;

  @override
  Stream<ClinicModel?> streamClinic() => Stream.value(clinic);
}

class _FakeSpecialtyService extends Fake implements SpecialtyService {
  _FakeSpecialtyService({this.specialties = const []});

  final List<SpecialtyModel> specialties;

  @override
  Future<String?> fetchSpecialtyName(String? specialtyId) async => specialties
      .where((specialty) => specialty.id == specialtyId)
      .firstOrNull
      ?.localizedName;
}

class _FakeAppointmentService extends Fake implements AppointmentService {
  final updates = StreamController<AppointmentModel?>.broadcast();

  @override
  Stream<AppointmentModel?> streamAppointment(String id) => updates.stream;

  AppointmentModel? cancelledAppointment;
  CancelledBy? lastCancelledBy;

  @override
  Future<void> cancel(
    AppointmentModel appointment, {
    required CancelledBy cancelledBy,
  }) async {
    cancelledAppointment = appointment;
    lastCancelledBy = cancelledBy;
  }
}

AppointmentModel _buildTestAppt({
  required String id,
  required AppointmentStatus status,
  required DateTime startAt,
  CancelledBy? cancelledBy,
  bool isReviewed = false,
  String doctorName = 'Dr. Gregory House',
  String? specialtyId,
}) {
  return AppointmentModel(
    id: id,
    patientId: 'patient_123',
    patientName: 'Jane Doe',
    patientEmail: 'jane@example.com',
    patientPhone: '01011112222',
    doctorId: 'doctor_123',
    doctorNameAr: doctorName,
    doctorNameEn: doctorName,
    startAt: startAt,
    slotId: 'slot_$id',
    status: status,
    cancelledBy: cancelledBy,
    isReviewed: isReviewed,
    fee: 50,
    specialtyId: specialtyId,
  );
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    ensureTestServiceLocator();
  });

  group('PatientAppointmentDetailsScreen', () {
    testWidgets('renders doctor info, booking info, and live clinic location', (
      WidgetTester tester,
    ) async {
      final appt = _buildTestAppt(
        id: 'appt_1',
        status: AppointmentStatus.upcoming,
        startAt: DateTime.now().add(const Duration(days: 7)),
        specialtyId: 'spec_cardio',
      );
      final fakeClinic = const ClinicModel(
        addressAr: 'شارع التحرير',
        addressEn: '123 Tahrir St, Cairo',
        location: LatLng(30.0444, 31.2357),
      );
      final clinicService = _FakeClinicService(clinic: fakeClinic);
      final specialtyService = _FakeSpecialtyService(
        specialties: const [
          SpecialtyModel(
            id: 'spec_cardio',
            nameAr: 'قلب',
            nameEn: 'Cardiology',
            iconKey: 'favorite',
            sortOrder: 1,
          ),
        ],
      );
      final appointmentService = _FakeAppointmentService();

      await tester.pumpWidget(
        buildTestApp(
          _detailsScreen(
            appointment: appt,
            clinicService: clinicService,
            specialtyService: specialtyService,
            appointmentService: appointmentService,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.appointmentDetails), findsOneWidget);
      expect(find.text('Dr. Gregory House'), findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('\$50.00'), findsWidgets);
      expect(find.text(tr.clinicLocation), findsOneWidget);
      expect(find.text('123 Tahrir St, Cairo'), findsOneWidget);
      expect(find.text(tr.cancelAppointment), findsOneWidget);
    });

    testWidgets('shows clinic location not set when missing', (
      WidgetTester tester,
    ) async {
      final appt = _buildTestAppt(
        id: 'appt_1',
        status: AppointmentStatus.upcoming,
        startAt: DateTime.now().add(const Duration(days: 7)),
      );
      final clinicService = _FakeClinicService(clinic: null);
      final appointmentService = _FakeAppointmentService();

      await tester.pumpWidget(
        buildTestApp(
          _detailsScreen(
            appointment: appt,
            clinicService: clinicService,
            appointmentService: appointmentService,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.clinicLocationNotSet), findsOneWidget);
    });

    testWidgets('Upcoming: cancel button shows confirm dialog and cancels', (
      WidgetTester tester,
    ) async {
      final appt = _buildTestAppt(
        id: 'appt_cancel',
        status: AppointmentStatus.upcoming,
        startAt: DateTime.now().add(const Duration(days: 7)),
      );
      final clinicService = _FakeClinicService();
      final appointmentService = _FakeAppointmentService();

      await tester.pumpWidget(
        buildTestApp(
          _detailsScreen(
            appointment: appt,
            clinicService: clinicService,
            appointmentService: appointmentService,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('details_cancel_button')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(tr.cancelAppointmentTitle),
        ),
        findsOneWidget,
      );
      expect(find.text(tr.cancelAppointmentMessage), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, tr.confirm));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(appointmentService.cancelledAppointment?.id, 'appt_cancel');
      expect(appointmentService.lastCancelledBy, CancelledBy.patient);
    });

    testWidgets(
      'Completed: unreviewed shows Rate Doctor, reviewed shows Reviewed',
      (WidgetTester tester) async {
        final apptUnreviewed = _buildTestAppt(
          id: 'appt_unreviewed',
          status: AppointmentStatus.completed,
          startAt: DateTime(2026, 9, 1, 10, 0),
          isReviewed: false,
        );
        final clinicService = _FakeClinicService();
        final appointmentService = _FakeAppointmentService();

        await tester.pumpWidget(
          buildTestApp(
            _detailsScreen(
              appointment: apptUnreviewed,
              clinicService: clinicService,
              appointmentService: appointmentService,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('details_rate_doctor_button')),
          findsOneWidget,
        );
        expect(find.text(tr.rateDoctor), findsOneWidget);

        final apptReviewed = _buildTestAppt(
          id: 'appt_reviewed',
          status: AppointmentStatus.completed,
          startAt: DateTime(2026, 9, 1, 10, 0),
          isReviewed: true,
        );

        await tester.pumpWidget(
          buildTestApp(
            _detailsScreen(
              appointment: apptReviewed,
              clinicService: clinicService,
              appointmentService: appointmentService,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(tr.reviewed), findsOneWidget);
        expect(
          find.byKey(const Key('details_rate_doctor_button')),
          findsNothing,
        );
      },
    );

    testWidgets('live update hides Rate Doctor once the review is saved', (
      WidgetTester tester,
    ) async {
      final appointment = _buildTestAppt(
        id: 'appt_live',
        status: AppointmentStatus.completed,
        startAt: DateTime(2026, 9, 1, 10, 0),
      );
      final appointmentService = _FakeAppointmentService();

      await tester.pumpWidget(
        buildTestApp(
          _detailsScreen(
            appointment: appointment,
            clinicService: _FakeClinicService(),
            appointmentService: appointmentService,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('details_rate_doctor_button')),
        findsOneWidget,
      );

      appointmentService.updates.add(
        _buildTestAppt(
          id: 'appt_live',
          status: AppointmentStatus.completed,
          startAt: DateTime(2026, 9, 1, 10, 0),
          isReviewed: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('details_rate_doctor_button')), findsNothing);
      expect(find.text(tr.reviewed), findsOneWidget);
    });

    testWidgets('Cancelled: shows cancelledBy text and no action button', (
      WidgetTester tester,
    ) async {
      final apptCancelled = _buildTestAppt(
        id: 'appt_canc',
        status: AppointmentStatus.cancelled,
        startAt: DateTime(2026, 8, 1, 10, 0),
        cancelledBy: CancelledBy.patient,
      );
      final clinicService = _FakeClinicService();
      final appointmentService = _FakeAppointmentService();

      await tester.pumpWidget(
        buildTestApp(
          _detailsScreen(
            appointment: apptCancelled,
            clinicService: clinicService,
            appointmentService: appointmentService,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.cancelledByYou), findsOneWidget);
      expect(find.byKey(const Key('details_cancel_button')), findsNothing);
      expect(find.byKey(const Key('details_rate_doctor_button')), findsNothing);
    });
  });
}

Widget _detailsScreen({
  required AppointmentModel appointment,
  ClinicService? clinicService,
  SpecialtyService? specialtyService,
  AppointmentService? appointmentService,
}) {
  return BlocProvider<AppointmentDetailsCubit>(
    key: ValueKey(appointment.id),
    create: (_) => AppointmentDetailsCubit(
      repository: AppointmentDetailsRepositoryImpl(
        clinicService: clinicService ?? _FakeClinicService(),
        specialtyService: specialtyService ?? _FakeSpecialtyService(),
        appointmentService: appointmentService ?? _FakeAppointmentService(),
      ),
      appointment: appointment,
    )..init(),
    child: const PatientAppointmentDetailsScreen(),
  );
}
