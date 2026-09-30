import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/controller/cubit/admin_doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/screens/admin_doctor_details.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

class _FakeAdminDoctorService extends Fake implements AdminDoctorService {
  _FakeAdminDoctorService({Stream<AdminDoctorModel?>? stream})
    : _stream = stream ?? const Stream.empty();

  final Stream<AdminDoctorModel?> _stream;
  final activeChanges = <(String, bool)>[];

  @override
  Stream<AdminDoctorModel?> streamDoctor(String id) => _stream;

  @override
  Future<void> setActive(String id, bool isActive) async {
    activeChanges.add((id, isActive));
  }
}

void main() {
  group('AdminDoctorDetails', () {
    testWidgets(
      'renders doctor summary, fee, rating, and not set availability',
      (WidgetTester tester) async {
        const doctor = AdminDoctorModel(
          id: 'doc_1',
          name: 'Dr. Gregory House',
          specialty: 'Diagnostic Medicine',
          consultationFee: 75,
          isActive: true,
          rating: 4.9,
          reviewsCount: 42,
        );
        final service = _FakeAdminDoctorService();
        final cubit = AdminDoctorDetailsCubit(
          initialDoctor: doctor,
          doctorService: service,
        );

        await tester.pumpWidget(
          buildTestApp(AdminDoctorDetails(doctor: doctor, cubit: cubit)),
        );
        await tester.pumpAndSettle();

        expect(find.text(tr.doctorDetails), findsOneWidget);
        expect(find.text('Dr. Gregory House'), findsOneWidget);
        expect(find.text('Diagnostic Medicine'), findsOneWidget);
        expect(find.text('\$75'), findsOneWidget);
        expect(find.text('4.9'), findsOneWidget);
        expect(find.text('(42 ${tr.reviews})'), findsOneWidget);
        expect(find.text(tr.activeLabel), findsWidgets);
        expect(find.text(tr.notSet), findsOneWidget);
        expect(
          find.byKey(const Key('admin_doctor_edit_button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('admin_doctor_availability_button')),
          findsOneWidget,
        );

        await cubit.close();
      },
    );

    testWidgets('shows formatted availability when availability is present', (
      WidgetTester tester,
    ) async {
      const doctor = AdminDoctorModel(
        id: 'doc_2',
        name: 'Dr. James Wilson',
        specialty: 'Oncology',
        consultationFee: 90,
        isActive: true,
        availability: DoctorAvailability(
          workingDays: [1, 2, 3],
          startMinutes: 540,
          endMinutes: 1020,
          slotMinutes: 30,
        ),
      );
      final service = _FakeAdminDoctorService();
      final cubit = AdminDoctorDetailsCubit(
        initialDoctor: doctor,
        doctorService: service,
      );

      await tester.pumpWidget(
        buildTestApp(AdminDoctorDetails(doctor: doctor, cubit: cubit)),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('09:00–17:00'), findsOneWidget);
      expect(find.textContaining('30 min'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('status switch shows dialog and toggles active state', (
      WidgetTester tester,
    ) async {
      const doctor = AdminDoctorModel(
        id: 'doc_toggle',
        name: 'Dr. Lisa Cuddy',
        specialty: 'Administration',
        isActive: true,
      );
      final service = _FakeAdminDoctorService();
      final cubit = AdminDoctorDetailsCubit(
        initialDoctor: doctor,
        doctorService: service,
      );

      await tester.pumpWidget(
        buildTestApp(AdminDoctorDetails(doctor: doctor, cubit: cubit)),
      );
      await tester.pumpAndSettle();

      // Tap status switch to deactivate
      final switchFinder = find.byKey(const Key('admin_doctor_status_switch'));
      await tester.ensureVisible(switchFinder);
      await tester.pumpAndSettle();
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(tr.deactivateDoctorTitle),
        ),
        findsWidgets,
      );
      expect(find.text(tr.confirmDeactivateDoctor), findsOneWidget);

      // Confirm deactivation
      await tester.tap(
        find.widgetWithText(AppTextButton, tr.deactivateDoctorTitle),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(service.activeChanges, [('doc_toggle', false)]);
      expect(cubit.state.doctor.isActive, false);

      await cubit.close();
    });
  });
}
