import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/controller/cubit/patient_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/screens/patient_appointments_screen.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/widgets/patient_appointment_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../../../../helpers/test_app.dart';
import '../../../../../../helpers/test_fakes.dart';

AppointmentModel _buildTestAppt({
  required String id,
  required AppointmentStatus status,
  required DateTime startAt,
  CancelledBy? cancelledBy,
  bool isReviewed = false,
  String doctorName = 'Dr. Sarah Connor',
}) {
  return AppointmentModel(
    id: id,
    patientId: 'patient_123',
    patientName: 'Jane Doe',
    patientEmail: 'jane@example.com',
    patientPhone: '01011112222',
    doctorId: 'doctor_abc',
    doctorNameAr: doctorName,
    doctorNameEn: doctorName,
    startAt: startAt,
    slotId: 'slot_$id',
    status: status,
    cancelledBy: cancelledBy,
    isReviewed: isReviewed,
    fee: 40,
  );
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    ensureTestServiceLocator();
  });

  group('PatientAppointmentsCubit', () {
    test('re-emits when only isReviewed changes after rating', () async {
      // arrange
      final completed = _buildTestAppt(
        id: 'appt_rated',
        status: AppointmentStatus.completed,
        startAt: DateTime.now().add(const Duration(days: 7)),
      );
      final repo = FakePatientAppointmentsRepository(appointments: [completed]);
      final cubit = PatientAppointmentsCubit(repository: repo);
      await cubit.init();
      await pumpEventQueue();

      // act
      repo.emitAppointments([
        _buildTestAppt(
          id: 'appt_rated',
          status: AppointmentStatus.completed,
          startAt: DateTime.now().add(const Duration(days: 7)),
          isReviewed: true,
        ),
      ]);
      await pumpEventQueue();

      // assert
      final loaded = cubit.state as PatientAppointmentsLoaded;
      expect(loaded.grouped.completed.single.isReviewed, isTrue);
      await cubit.close();
    });

    test('emits loaded state when appointments stream emits', () async {
      final appt = _buildTestAppt(
        id: 'appt_1',
        status: AppointmentStatus.upcoming,
        startAt: DateTime.now().add(const Duration(days: 7)),
      );
      final repo = FakePatientAppointmentsRepository(appointments: [appt]);
      final cubit = PatientAppointmentsCubit(repository: repo);

      await cubit.init();
      await pumpEventQueue();

      expect(cubit.state, isA<PatientAppointmentsLoaded>());
      final loaded = cubit.state as PatientAppointmentsLoaded;
      expect(loaded.grouped.upcoming.length, 1);
      expect(loaded.grouped.upcoming.first.id, 'appt_1');
      await cubit.close();
    });

    test('cancels appointment through repository', () async {
      final appt = _buildTestAppt(
        id: 'appt_1',
        status: AppointmentStatus.upcoming,
        startAt: DateTime.now().add(const Duration(days: 7)),
      );
      final repo = FakePatientAppointmentsRepository();
      final cubit = PatientAppointmentsCubit(repository: repo);

      await cubit.cancelAppointment(appt);
      expect(repo.cancelledAppointments, contains(appt));
      await cubit.close();
    });
  });

  group('PatientAppointmentsScreen', () {
    testWidgets('renders 3 tabs and the Figma back button', (
      WidgetTester tester,
    ) async {
      final repo = FakePatientAppointmentsRepository();
      final cubit = PatientAppointmentsCubit(repository: repo);
      await cubit.init();

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<PatientAppointmentsCubit>.value(
            value: cubit,
            child: const PatientAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.appointments), findsOneWidget);
      expect(find.text(tr.upcoming), findsOneWidget);
      expect(find.text(tr.completed), findsOneWidget);
      expect(find.text(tr.cancelled), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
      await cubit.close();
    });

    testWidgets('swiping the page moves the tab bar to the next tab', (
      WidgetTester tester,
    ) async {
      final cubit = PatientAppointmentsCubit(
        repository: FakePatientAppointmentsRepository(),
      );
      await cubit.init();
      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<PatientAppointmentsCubit>.value(
            value: cubit,
            child: const PatientAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.fling(
        find.byType(TabBarView),
        Offset(-tester.getSize(find.byType(TabBarView)).width * 0.6, 0),
        1000,
      );
      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller!.index, 1);
      await cubit.close();
    });

    testWidgets('Upcoming tab shows appointment card with cancel action', (
      WidgetTester tester,
    ) async {
      final appt = _buildTestAppt(
        id: 'upcoming_1',
        status: AppointmentStatus.upcoming,
        startAt: DateTime.now().add(const Duration(days: 7)),
      );
      final repo = FakePatientAppointmentsRepository(appointments: [appt]);
      final cubit = PatientAppointmentsCubit(repository: repo);
      await cubit.init();

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<PatientAppointmentsCubit>.value(
            value: cubit,
            child: const PatientAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PatientAppointmentCard), findsOneWidget);
      expect(find.text('Dr. Sarah Connor'), findsOneWidget);
      expect(find.text(tr.cancelAppointment), findsOneWidget);
      expect(
        find.byKey(const Key('view_details_button_upcoming_1')),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const Key('cancel_appointment_button_upcoming_1')),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(tr.cancelAppointmentTitle),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(tr.cancelAppointmentMessage),
        ),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(TextButton, tr.confirm));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(repo.cancelledAppointments.length, 1);
      expect(repo.cancelledAppointments.first.id, 'upcoming_1');
      await cubit.close();
    });

    testWidgets('Completed tab shows Rate Doctor or Reviewed', (
      WidgetTester tester,
    ) async {
      final apptNotReviewed = _buildTestAppt(
        id: 'comp_not_reviewed',
        status: AppointmentStatus.completed,
        startAt: DateTime(2026, 9, 10, 10, 0),
        isReviewed: false,
        doctorName: 'Dr. Not Reviewed',
      );
      final apptReviewed = _buildTestAppt(
        id: 'comp_reviewed',
        status: AppointmentStatus.completed,
        startAt: DateTime(2026, 9, 12, 10, 0),
        isReviewed: true,
        doctorName: 'Dr. Reviewed',
      );

      final repo = FakePatientAppointmentsRepository(
        appointments: [apptNotReviewed, apptReviewed],
      );
      final cubit = PatientAppointmentsCubit(repository: repo);
      await cubit.init();

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<PatientAppointmentsCubit>.value(
            value: cubit,
            child: const PatientAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(tr.completed));
      await tester.pumpAndSettle();

      expect(find.text('Dr. Not Reviewed'), findsOneWidget);
      expect(find.text('Dr. Reviewed'), findsOneWidget);
      expect(find.text(tr.rateDoctor), findsOneWidget);
      expect(find.text(tr.tapToRateYourVisit), findsOneWidget);
      expect(find.text(tr.reviewed), findsOneWidget);
      await cubit.close();
    });

    testWidgets('Cancelled tab shows cancelledBy and no Rate button', (
      WidgetTester tester,
    ) async {
      final apptPatient = _buildTestAppt(
        id: 'canc_patient',
        status: AppointmentStatus.cancelled,
        startAt: DateTime(2026, 8, 1, 10, 0),
        cancelledBy: CancelledBy.patient,
        doctorName: 'Dr. Patient Cancelled',
      );
      final apptAdmin = _buildTestAppt(
        id: 'canc_admin',
        status: AppointmentStatus.cancelled,
        startAt: DateTime(2026, 8, 2, 10, 0),
        cancelledBy: CancelledBy.admin,
        doctorName: 'Dr. Clinic Cancelled',
      );

      final repo = FakePatientAppointmentsRepository(
        appointments: [apptPatient, apptAdmin],
      );
      final cubit = PatientAppointmentsCubit(repository: repo);
      await cubit.init();

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<PatientAppointmentsCubit>.value(
            value: cubit,
            child: const PatientAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(tr.cancelled));
      await tester.pumpAndSettle();

      expect(find.text('Dr. Patient Cancelled'), findsOneWidget);
      expect(find.text('Dr. Clinic Cancelled'), findsOneWidget);
      expect(find.text(tr.cancelledByYou), findsOneWidget);
      expect(find.text(tr.cancelledByClinic), findsOneWidget);
      expect(find.text(tr.rateDoctor), findsNothing);
      expect(find.text(tr.cancelAppointment), findsNothing);
      await cubit.close();
    });

    testWidgets('Empty state appears when no appointments in tab', (
      WidgetTester tester,
    ) async {
      final repo = FakePatientAppointmentsRepository(appointments: []);
      final cubit = PatientAppointmentsCubit(repository: repo);
      await cubit.init();

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<PatientAppointmentsCubit>.value(
            value: cubit,
            child: const PatientAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.noUpcomingAppointments), findsOneWidget);
      expect(find.text(tr.noAppointmentsDescription), findsOneWidget);
      await cubit.close();
    });
  });
}
