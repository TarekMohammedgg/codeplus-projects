import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/controller/cubit/admin_doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/screens/admin_doctor_details.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

void main() {
  group('AdminDoctorDetails', () {
    testWidgets(
      'renders doctor summary, fee, rating, and not set availability',
      (WidgetTester tester) async {
        const doctor = DoctorModel(
          id: 'doc_1',
          nameEn: 'Dr. Gregory House',
          specialtyEn: 'Diagnostic Medicine',
          consultationFee: 75,
          isActive: true,
          rating: 4.9,
          reviewsCount: 42,
        );
        final repository = FakeAdminDoctorsRepository();
        final cubit = AdminDoctorDetailsCubit(
          initialDoctor: doctor,
          repository: repository,
        );

        await tester.pumpWidget(
          buildTestApp(
            BlocProvider<AdminDoctorDetailsCubit>.value(
              value: cubit,
              child: const AdminDoctorDetails(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(tr.doctorDetails), findsOneWidget);
        expect(find.text('Dr. Gregory House'), findsOneWidget);
        expect(find.text('Diagnostic Medicine'), findsOneWidget);
        expect(find.text('\$75.00'), findsOneWidget);
        expect(
          find.text(tr.ratingSummary(rating: '4.9', count: 42)),
          findsOneWidget,
        );
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
      const doctor = DoctorModel(
        id: 'doc_2',
        nameEn: 'Dr. James Wilson',
        specialtyEn: 'Oncology',
        consultationFee: 90,
        isActive: true,
        availability: DoctorAvailability(
          workingDays: [1, 2, 3],
          startMinutes: 540,
          endMinutes: 1020,
          slotMinutes: 30,
        ),
      );
      final repository = FakeAdminDoctorsRepository();
      final cubit = AdminDoctorDetailsCubit(
        initialDoctor: doctor,
        repository: repository,
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminDoctorDetailsCubit>.value(
            value: cubit,
            child: const AdminDoctorDetails(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('09:00–17:00'), findsOneWidget);
      expect(find.textContaining('30 min'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('status menu shows dialog and toggles active state', (
      WidgetTester tester,
    ) async {
      const doctor = DoctorModel(
        id: 'doc_toggle',
        nameEn: 'Dr. Lisa Cuddy',
        specialtyEn: 'Administration',
        isActive: true,
      );
      final repository = FakeAdminDoctorsRepository();
      final cubit = AdminDoctorDetailsCubit(
        initialDoctor: doctor,
        repository: repository,
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminDoctorDetailsCubit>.value(
            value: cubit,
            child: const AdminDoctorDetails(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('admin_doctor_status_menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(tr.deactivateDoctorTitle));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(tr.deactivateDoctorTitle),
        ),
        findsWidgets,
      );
      expect(find.text(tr.deactivateDoctorConfirm), findsOneWidget);

      await tester.tap(find.widgetWithText(AppTextButton, tr.deactivate));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(repository.activeChanges, [('doc_toggle', false)]);
      expect(find.text(tr.doctorDeactivatedSuccess), findsOneWidget);

      await cubit.close();
    });

    testWidgets('failed status change shows no success message', (
      WidgetTester tester,
    ) async {
      // arrange
      const doctor = DoctorModel(id: 'doc_fail', nameEn: 'Dr. Fail');
      final cubit = AdminDoctorDetailsCubit(
        initialDoctor: doctor,
        repository: FakeAdminDoctorsRepository(
          setActiveError: StateError('offline'),
        ),
      );
      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminDoctorDetailsCubit>.value(
            value: cubit,
            child: const AdminDoctorDetails(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('admin_doctor_status_menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(tr.deactivateDoctorTitle));
      await tester.pumpAndSettle();

      // act
      await tester.tap(find.widgetWithText(AppTextButton, tr.deactivate));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // assert
      expect(find.text(tr.doctorDeactivatedSuccess), findsNothing);

      await cubit.close();
    });
  });
}
