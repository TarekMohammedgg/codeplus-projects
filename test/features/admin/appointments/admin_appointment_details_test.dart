import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/data/repositories/appointment_details_repository.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_cubit.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/screens/admin_appointment_details_screen.dart';

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
  AppointmentModel? cancelledAppointment;
  CancelledBy? lastCancelledBy;
  String? markedCompletedAppointmentId;
  bool shouldThrow = false;

  @override
  Future<void> cancel(
    AppointmentModel appointment, {
    required CancelledBy cancelledBy,
  }) async {
    if (shouldThrow) throw const AppException(message: 'Cancel failed');
    cancelledAppointment = appointment;
    lastCancelledBy = cancelledBy;
  }

  @override
  Future<void> markCompleted(String appointmentId) async {
    if (shouldThrow) throw const AppException(message: 'Mark completed failed');
    markedCompletedAppointmentId = appointmentId;
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
  String patientName = 'Jane Doe',
  String patientPhone = '01011112222',
  String patientEmail = 'jane@example.com',
}) {
  return AppointmentModel(
    id: id,
    patientId: 'patient_123',
    patientName: patientName,
    patientEmail: patientEmail,
    patientPhone: patientPhone,
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
  final testDate = DateTime(2026, 11, 20, 14, 0);

  final testClinic = const ClinicModel(
    addressAr: 'شارع التحرير، القاهرة',
    addressEn: 'Tahrir Street, Cairo',
    location: LatLng(30.0444, 31.2357),
  );

  final testSpecialties = [
    const SpecialtyModel(
      id: 'spec_cardio',
      nameAr: 'قلب وأوعية دموية',
      nameEn: 'Cardiology',
    ),
  ];

  group('AdminAppointmentDetailsScreen', () {
    testWidgets(
      'renders doctor summary, embedded patient info, and clinic details',
      (tester) async {
        final appt = _buildTestAppt(
          id: 'appt_1',
          status: AppointmentStatus.upcoming,
          startAt: testDate,
          specialtyId: 'spec_cardio',
          patientName: 'John Patient',
          patientPhone: '+201099887766',
          patientEmail: 'patient@hospital.org',
        );

        final clinicService = _FakeClinicService(clinic: testClinic);
        final specialtyService = _FakeSpecialtyService(
          specialties: testSpecialties,
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

        expect(find.text('Appointment Details'), findsOneWidget);
        expect(find.text('Dr. Gregory House'), findsOneWidget);
        expect(find.text('Cardiology'), findsOneWidget);
        expect(find.text('\$50.00'), findsWidgets);

        expect(find.text('Patient Information'), findsOneWidget);
        expect(find.text('John Patient'), findsOneWidget);
        expect(find.text('+201099887766'), findsOneWidget);
        expect(find.text('patient@hospital.org'), findsOneWidget);

        expect(find.text('Clinic Location'), findsOneWidget);
        expect(find.text('Tahrir Street, Cairo'), findsOneWidget);

        expect(
          find.byKey(const Key('admin_mark_completed_button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('admin_cancel_appointment_button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'mark completed button triggers confirmation and completes appointment',
      (tester) async {
        final appt = _buildTestAppt(
          id: 'appt_mark_1',
          status: AppointmentStatus.upcoming,
          startAt: testDate,
        );

        final appointmentService = _FakeAppointmentService();

        await tester.pumpWidget(
          buildTestApp(
            _detailsScreen(
              appointment: appt,
              clinicService: _FakeClinicService(clinic: testClinic),
              specialtyService: _FakeSpecialtyService(),
              appointmentService: appointmentService,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('admin_mark_completed_button')));
        await tester.pumpAndSettle();

        expect(find.text('Mark Appointment Completed'), findsOneWidget);
        expect(
          find.text(
            'Are you sure you want to mark this appointment as completed?',
          ),
          findsOneWidget,
        );

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(appointmentService.markedCompletedAppointmentId, 'appt_mark_1');
        expect(
          find.text('Appointment marked as completed successfully'),
          findsOneWidget,
        );
      },
    );

    testWidgets('mark completed cancellation in dialog aborts action', (
      tester,
    ) async {
      final appt = _buildTestAppt(
        id: 'appt_mark_2',
        status: AppointmentStatus.upcoming,
        startAt: testDate,
      );

      final appointmentService = _FakeAppointmentService();

      await tester.pumpWidget(
        buildTestApp(
          _detailsScreen(
            appointment: appt,
            clinicService: _FakeClinicService(clinic: testClinic),
            specialtyService: _FakeSpecialtyService(),
            appointmentService: appointmentService,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('admin_mark_completed_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(appointmentService.markedCompletedAppointmentId, isNull);
    });

    testWidgets(
      'cancel button triggers confirmation and cancels appointment with admin role',
      (tester) async {
        final appt = _buildTestAppt(
          id: 'appt_cancel_1',
          status: AppointmentStatus.upcoming,
          startAt: testDate,
        );

        final appointmentService = _FakeAppointmentService();

        await tester.pumpWidget(
          buildTestApp(
            _detailsScreen(
              appointment: appt,
              clinicService: _FakeClinicService(clinic: testClinic),
              specialtyService: _FakeSpecialtyService(),
              appointmentService: appointmentService,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('admin_cancel_appointment_button')),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cancel Appointment'), findsWidgets);
        expect(
          find.text('Are you sure you want to cancel this appointment?'),
          findsOneWidget,
        );

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(appointmentService.cancelledAppointment?.id, 'appt_cancel_1');
        expect(appointmentService.lastCancelledBy, CancelledBy.admin);
        expect(find.text('Appointment cancelled successfully'), findsOneWidget);
      },
    );

    testWidgets('service error shows error snackbar', (tester) async {
      final appt = _buildTestAppt(
        id: 'appt_error_1',
        status: AppointmentStatus.upcoming,
        startAt: testDate,
      );

      final appointmentService = _FakeAppointmentService()..shouldThrow = true;

      await tester.pumpWidget(
        buildTestApp(
          _detailsScreen(
            appointment: appt,
            clinicService: _FakeClinicService(clinic: testClinic),
            specialtyService: _FakeSpecialtyService(),
            appointmentService: appointmentService,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('admin_mark_completed_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Mark completed failed'), findsOneWidget);
    });

    testWidgets('completed appointment is view only', (tester) async {
      final appt = _buildTestAppt(
        id: 'appt_comp_1',
        status: AppointmentStatus.completed,
        startAt: testDate,
      );

      await tester.pumpWidget(
        buildTestApp(
          _detailsScreen(
            appointment: appt,
            clinicService: _FakeClinicService(clinic: testClinic),
            specialtyService: _FakeSpecialtyService(),
            appointmentService: _FakeAppointmentService(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('admin_mark_completed_button')),
        findsNothing,
      );
      expect(
        find.byKey(const Key('admin_cancel_appointment_button')),
        findsNothing,
      );
    });

    testWidgets(
      'cancelled appointment shows cancellation attribution and is view only',
      (tester) async {
        final appt = _buildTestAppt(
          id: 'appt_canc_1',
          status: AppointmentStatus.cancelled,
          startAt: testDate,
          cancelledBy: CancelledBy.patient,
        );

        await tester.pumpWidget(
          buildTestApp(
            _detailsScreen(
              appointment: appt,
              clinicService: _FakeClinicService(clinic: testClinic),
              specialtyService: _FakeSpecialtyService(),
              appointmentService: _FakeAppointmentService(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cancelled by patient'), findsOneWidget);
        expect(
          find.byKey(const Key('admin_mark_completed_button')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('admin_cancel_appointment_button')),
          findsNothing,
        );
      },
    );
  });
}

Widget _detailsScreen({
  required AppointmentModel appointment,
  ClinicService? clinicService,
  SpecialtyService? specialtyService,
  AppointmentService? appointmentService,
}) {
  return BlocProvider<AppointmentDetailsCubit>(
    create: (_) => AppointmentDetailsCubit(
      repository: AppointmentDetailsRepositoryImpl(
        clinicService: clinicService ?? _FakeClinicService(),
        specialtyService: specialtyService ?? _FakeSpecialtyService(),
        appointmentService: appointmentService ?? _FakeAppointmentService(),
      ),
    )..init(appointment),
    child: AdminAppointmentDetailsScreen(appointment: appointment),
  );
}
