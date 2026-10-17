import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_list_skeleton.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/data/repositories/admin_appointments_repository.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_state.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/screens/admin_appointments_screen.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/widgets/admin_appointment_card.dart';

import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

class _FakeAdminAppointmentsRepository implements AdminAppointmentsRepository {
  final StreamController<List<AppointmentModel>> streamController =
      StreamController<List<AppointmentModel>>.broadcast();

  List<SpecialtyModel> specialtiesToReturn = [
    const SpecialtyModel(id: 'spec_1', nameAr: 'قلب', nameEn: 'Cardiology'),
  ];

  @override
  Stream<List<AppointmentModel>> streamAppointments() =>
      streamController.stream;

  @override
  Future<List<SpecialtyModel>> getSpecialties() async => specialtiesToReturn;

  Map<String, String> photos = const {};
  Object? photoError;
  final photoRequests = <Set<String>>[];

  @override
  Future<Map<String, String>> fetchPatientPhotos(Set<String> patientIds) async {
    photoRequests.add(patientIds);
    if (photoError != null) throw photoError!;
    return photos;
  }

  final List<String> cancelled = [];
  final List<String> completed = [];

  @override
  Future<void> cancel(AppointmentModel appointment) async =>
      cancelled.add(appointment.id);

  @override
  Future<void> markCompleted(String appointmentId) async =>
      completed.add(appointmentId);

  void dispose() {
    streamController.close();
  }
}

void main() {
  final testDateTime = DateTime.now().subtract(const Duration(hours: 3));

  final sampleUpcoming = AppointmentModel(
    id: 'appt_1',
    patientId: 'patient_1',
    patientName: 'Jane Patient',
    patientPhone: '+123456789',
    patientEmail: 'jane@example.com',
    doctorId: 'doc_1',
    doctorNameAr: 'د. جون دو',
    doctorNameEn: 'Dr. John Doe',
    specialtyId: 'spec_1',
    startAt: testDateTime,
    slotId: '202610151030',
    fee: 100,
    status: AppointmentStatus.upcoming,
    isReviewed: false,
    createdAt: testDateTime.subtract(const Duration(days: 1)),
  );

  final sampleCompleted = AppointmentModel(
    id: 'appt_2',
    patientId: 'patient_2',
    patientName: 'Bob Smith',
    patientPhone: '+123456780',
    patientEmail: 'bob@example.com',
    doctorId: 'doc_1',
    doctorNameAr: 'د. جون دو',
    doctorNameEn: 'Dr. John Doe',
    specialtyId: 'spec_1',
    startAt: testDateTime.subtract(const Duration(days: 2)),
    slotId: '202610131030',
    fee: 120,
    status: AppointmentStatus.completed,
    isReviewed: true,
    createdAt: testDateTime.subtract(const Duration(days: 3)),
  );

  final sampleCancelled = AppointmentModel(
    id: 'appt_3',
    patientId: 'patient_3',
    patientName: 'Alice Green',
    patientPhone: '+123456781',
    patientEmail: 'alice@example.com',
    doctorId: 'doc_2',
    doctorNameAr: 'د. سارة كونور',
    doctorNameEn: 'Dr. Sarah Connor',
    specialtyId: 'spec_1',
    startAt: testDateTime.add(const Duration(days: 1)),
    slotId: '202610161030',
    fee: 150,
    status: AppointmentStatus.cancelled,
    isReviewed: false,
    createdAt: testDateTime.subtract(const Duration(hours: 12)),
  );

  final List<AppointmentModel> allAppointments = [
    sampleUpcoming,
    sampleCompleted,
    sampleCancelled,
  ];

  group('Pure filterAppointmentsByTab', () {
    test('all returns all appointments', () {
      final result = filterAppointmentsByTab(
        allAppointments,
        AdminAppointmentTab.all,
      );
      expect(result.length, 3);
      expect(result, containsAll(allAppointments));
    });

    test('upcoming returns only upcoming appointments', () {
      final result = filterAppointmentsByTab(
        allAppointments,
        AdminAppointmentTab.upcoming,
      );
      expect(result.length, 1);
      expect(result.first.id, 'appt_1');
    });

    test('completed returns only completed appointments', () {
      final result = filterAppointmentsByTab(
        allAppointments,
        AdminAppointmentTab.completed,
      );
      expect(result.length, 1);
      expect(result.first.id, 'appt_2');
    });

    test('cancelled returns only cancelled appointments', () {
      final result = filterAppointmentsByTab(
        allAppointments,
        AdminAppointmentTab.cancelled,
      );
      expect(result.length, 1);
      expect(result.first.id, 'appt_3');
    });
  });

  group('AdminAppointmentsCubit', () {
    late _FakeAdminAppointmentsRepository repo;
    late AdminAppointmentsCubit cubit;

    setUp(() {
      repo = _FakeAdminAppointmentsRepository();
      cubit = AdminAppointmentsCubit(repository: repo);
    });

    tearDown(() async {
      await cubit.close();
      repo.dispose();
    });

    test(
      'init loads specialties and emits loaded appointments from stream',
      () async {
        await cubit.init();
        repo.streamController.add(allAppointments);

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(cubit.state.status, AdminAppointmentsStatus.loaded);
        expect(cubit.state.appointments.length, 3);
        expect(cubit.state.specialties.containsKey('spec_1'), isTrue);
        expect(cubit.state.currentAppointments.length, 3);
      },
    );

    test('loads patient photos in one request per new patient', () async {
      // arrange
      repo.photos = {'patient_1': 'https://example.com/p1.png'};
      await cubit.init();

      // act
      repo.streamController.add(allAppointments);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      repo.streamController.add(allAppointments);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // assert
      expect(repo.photoRequests, [
        {'patient_1', 'patient_2', 'patient_3'},
      ]);
      expect(cubit.state.patientPhotos, {
        'patient_1': 'https://example.com/p1.png',
      });
    });

    test(
      'photo failure keeps the list and retries on the next update',
      () async {
        // arrange
        repo.photoError = StateError('offline');
        await cubit.init();
        repo.streamController.add(allAppointments);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        repo.photoError = null;

        // act
        repo.streamController.add(allAppointments);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // assert
        expect(cubit.state.status, AdminAppointmentsStatus.loaded);
        expect(cubit.state.appointments, hasLength(3));
        expect(repo.photoRequests, hasLength(2));
      },
    );

    test(
      'selectTab changes active tab and filters currentAppointments',
      () async {
        await cubit.init();
        repo.streamController.add(allAppointments);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        cubit.selectTab(AdminAppointmentTab.upcoming);
        expect(cubit.state.selectedTab, AdminAppointmentTab.upcoming);
        expect(cubit.state.currentAppointments.length, 1);
        expect(cubit.state.currentAppointments.first.id, 'appt_1');

        cubit.selectTab(AdminAppointmentTab.completed);
        expect(cubit.state.selectedTab, AdminAppointmentTab.completed);
        expect(cubit.state.currentAppointments.length, 1);
        expect(cubit.state.currentAppointments.first.id, 'appt_2');

        cubit.selectTab(AdminAppointmentTab.cancelled);
        expect(cubit.state.selectedTab, AdminAppointmentTab.cancelled);
        expect(cubit.state.currentAppointments.length, 1);
        expect(cubit.state.currentAppointments.first.id, 'appt_3');

        cubit.selectTab(AdminAppointmentTab.all);
        expect(cubit.state.selectedTab, AdminAppointmentTab.all);
        expect(cubit.state.currentAppointments.length, 3);
      },
    );

    test('handles stream error properly', () async {
      await cubit.init();
      repo.streamController.addError(Exception('Network error'));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.status, AdminAppointmentsStatus.failure);
      expect(cubit.state.errorMessage, isNotNull);
    });
  });

  group('AdminAppointmentsScreen widget', () {
    late _FakeAdminAppointmentsRepository repo;

    setUp(() {
      repo = _FakeAdminAppointmentsRepository();
    });

    tearDown(() {
      repo.dispose();
    });

    testWidgets('shows loading state initially', (tester) async {
      final cubit = AdminAppointmentsCubit(
        repository: repo,
        initialState: const AdminAppointmentsState(
          status: AdminAppointmentsStatus.loading,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminAppointmentsCubit>.value(
            value: cubit,
            child: const AdminAppointmentsScreen(),
          ),
        ),
      );

      expect(find.byType(AppListSkeleton), findsOneWidget);
      await cubit.close();
    });

    testWidgets('shows failure state with retry button', (tester) async {
      final cubit = AdminAppointmentsCubit(
        repository: repo,
        initialState: const AdminAppointmentsState(
          status: AdminAppointmentsStatus.failure,
          errorMessage: 'Something went wrong',
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminAppointmentsCubit>.value(
            value: cubit,
            child: const AdminAppointmentsScreen(),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      await cubit.close();
    });

    testWidgets('renders 4 tabs and displays appointments', (tester) async {
      final cubit = AdminAppointmentsCubit(
        repository: repo,
        initialState: AdminAppointmentsState(
          status: AdminAppointmentsStatus.loaded,
          appointments: allAppointments,
          selectedTab: AdminAppointmentTab.all,
          specialties: {
            'spec_1': const SpecialtyModel(
              id: 'spec_1',
              nameAr: 'قلب',
              nameEn: 'Cardiology',
            ),
          },
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminAppointmentsCubit>.value(
            value: cubit,
            child: const AdminAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Appointments'), findsWidgets);
      expect(find.widgetWithText(Tab, 'All'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Upcoming'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Completed'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Cancelled'), findsOneWidget);

      expect(find.byType(AdminAppointmentCard), findsNWidgets(3));
      expect(find.textContaining('Jane Patient'), findsOneWidget);
      expect(find.textContaining('Bob Smith'), findsOneWidget);
      expect(find.textContaining('Alice Green'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('switching tab filters the cards', (tester) async {
      final cubit = AdminAppointmentsCubit(
        repository: repo,
        initialState: AdminAppointmentsState(
          status: AdminAppointmentsStatus.loaded,
          appointments: allAppointments,
          selectedTab: AdminAppointmentTab.all,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminAppointmentsCubit>.value(
            value: cubit,
            child: const AdminAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminAppointmentCard), findsNWidgets(3));

      await tester.tap(find.widgetWithText(Tab, 'Upcoming'));
      await tester.pumpAndSettle();

      expect(cubit.state.selectedTab, AdminAppointmentTab.upcoming);
      expect(find.byType(AdminAppointmentCard), findsOneWidget);
      expect(find.textContaining('Jane Patient'), findsOneWidget);
      expect(find.textContaining('Bob Smith'), findsNothing);

      await tester.tap(find.widgetWithText(Tab, 'Completed'));
      await tester.pumpAndSettle();

      expect(cubit.state.selectedTab, AdminAppointmentTab.completed);
      expect(find.byType(AdminAppointmentCard), findsOneWidget);
      expect(find.textContaining('Bob Smith'), findsOneWidget);

      await tester.tap(find.widgetWithText(Tab, 'Cancelled'));
      await tester.pumpAndSettle();

      expect(cubit.state.selectedTab, AdminAppointmentTab.cancelled);
      expect(find.byType(AdminAppointmentCard), findsOneWidget);
      expect(find.textContaining('Alice Green'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('Mark as Completed confirms, then calls the repository', (
      tester,
    ) async {
      final tr = AppLocale.en.buildSync();
      final cubit = AdminAppointmentsCubit(
        repository: repo,
        initialState: AdminAppointmentsState(
          status: AdminAppointmentsStatus.loaded,
          appointments: allAppointments,
          selectedTab: AdminAppointmentTab.upcoming,
        ),
      );
      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminAppointmentsCubit>.value(
            value: cubit,
            child: const AdminAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('admin_complete_button_appt_1')));
      await tester.pumpAndSettle();

      await tester.tap(find.text(tr.confirm));
      await tester.pumpAndSettle();

      expect(repo.completed, ['appt_1']);
      await cubit.close();
    });

    testWidgets('shows empty state when no appointments exist', (tester) async {
      final cubit = AdminAppointmentsCubit(
        repository: repo,
        initialState: const AdminAppointmentsState(
          status: AdminAppointmentsStatus.loaded,
          appointments: [],
          selectedTab: AdminAppointmentTab.all,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminAppointmentsCubit>.value(
            value: cubit,
            child: const AdminAppointmentsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminAppointmentCard), findsNothing);
      expect(find.text('No appointments found'), findsOneWidget);

      await cubit.close();
    });
  });
}
