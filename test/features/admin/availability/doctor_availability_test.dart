import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/features/admin/availability/data/repositories/doctor_availability_repository.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_state.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/screens/doctor_availability_screen.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

class _FakeDoctorAvailabilityRepository extends Fake
    implements DoctorAvailabilityRepository {
  final savedAvailabilities = <(String, DoctorAvailability)>[];
  bool shouldThrow = false;

  @override
  Future<void> updateAvailability(
    String doctorId,
    DoctorAvailability availability,
  ) async {
    if (shouldThrow) {
      throw Exception('Failed to update availability');
    }
    savedAvailabilities.add((doctorId, availability));
  }
}

void main() {
  const testDoctor = DoctorModel(
    id: 'doc_1',
    name: 'Dr. Gregory House',
    specialty: 'Diagnostic Medicine',
    consultationFee: 100,
    isActive: true,
  );

  group('DoctorAvailabilityState & Cubit', () {
    test('initial state defaults to Mon-Fri 09:00-17:00 30 min', () {
      final state = const DoctorAvailabilityState();
      expect(state.workingDays, {1, 2, 3, 4, 5});
      expect(state.startMinutes, 540);
      expect(state.endMinutes, 1020);
      expect(state.slotMinutes, 30);
      expect(state.slotsPerDay, 16);
      expect(state.isValid, isTrue);
    });

    test('prefills from existing DoctorAvailability', () {
      const availability = DoctorAvailability(
        workingDays: [1, 3, 5],
        startMinutes: 600,
        endMinutes: 900,
        slotMinutes: 60,
      );
      final state = DoctorAvailabilityState.fromAvailability(availability);
      expect(state.workingDays, {1, 3, 5});
      expect(state.startMinutes, 600);
      expect(state.endMinutes, 900);
      expect(state.slotMinutes, 60);
      expect(state.slotsPerDay, 5);
      expect(state.isValid, isTrue);
    });

    test('toggleDay adds and removes days correctly', () {
      final repo = _FakeDoctorAvailabilityRepository();
      final cubit = DoctorAvailabilityCubit(repository: repo);

      cubit.toggleDay(6);
      expect(cubit.state.workingDays.contains(6), isTrue);

      cubit.toggleDay(6);
      expect(cubit.state.workingDays.contains(6), isFalse);
    });

    test('validates working days cannot be empty', () {
      final repo = _FakeDoctorAvailabilityRepository();
      final cubit = DoctorAvailabilityCubit(repository: repo);

      cubit.setWorkingDays({});
      expect(cubit.state.isWorkingDaysValid, isFalse);
      expect(cubit.state.isValid, isFalse);
      expect(
        cubit.state.validationError,
        AvailabilityValidationError.emptyDays,
      );
    });

    test('validates start must be before end', () {
      final repo = _FakeDoctorAvailabilityRepository();
      final cubit = DoctorAvailabilityCubit(repository: repo);

      cubit.setStartMinutes(1020);
      cubit.setEndMinutes(540);
      expect(cubit.state.isTimeRangeValid, isFalse);
      expect(cubit.state.isValid, isFalse);
      expect(
        cubit.state.validationError,
        AvailabilityValidationError.invalidTimeRange,
      );
    });

    test('validates slot must fit in time range', () {
      final repo = _FakeDoctorAvailabilityRepository();
      final cubit = DoctorAvailabilityCubit(repository: repo);

      cubit.setStartMinutes(540);
      cubit.setEndMinutes(550);
      cubit.setSlotMinutes(30);
      expect(cubit.state.isSlotFitsValid, isFalse);
      expect(cubit.state.isValid, isFalse);
      expect(
        cubit.state.validationError,
        AvailabilityValidationError.slotTooLong,
      );
    });

    test(
      'saveAvailability fails when invalid without calling repository',
      () async {
        final repo = _FakeDoctorAvailabilityRepository();
        final cubit = DoctorAvailabilityCubit(repository: repo);

        cubit.setStartMinutes(1000);
        cubit.setEndMinutes(800);

        final result = await cubit.saveAvailability('doc_1');
        expect(result, isFalse);
        expect(cubit.state.status, DoctorAvailabilityStatus.failure);
        expect(repo.savedAvailabilities, isEmpty);
      },
    );

    test('saveAvailability succeeds when valid and calls repository', () async {
      final repo = _FakeDoctorAvailabilityRepository();
      final cubit = DoctorAvailabilityCubit(repository: repo);

      final result = await cubit.saveAvailability('doc_1');
      expect(result, isTrue);
      expect(cubit.state.status, DoctorAvailabilityStatus.success);
      expect(repo.savedAvailabilities.length, 1);
      final (docId, saved) = repo.savedAvailabilities.first;
      expect(docId, 'doc_1');
      expect(saved.workingDays, [1, 2, 3, 4, 5]);
      expect(saved.startMinutes, 540);
      expect(saved.endMinutes, 1020);
      expect(saved.slotMinutes, 30);
    });
  });

  group('DoctorAvailabilityScreen Widget Tests', () {
    testWidgets('renders all controls with prefilled defaults', (
      WidgetTester tester,
    ) async {
      final repo = _FakeDoctorAvailabilityRepository();
      final cubit = DoctorAvailabilityCubit(repository: repo);

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<DoctorAvailabilityCubit>.value(
            value: cubit,
            child: DoctorAvailabilityScreen(doctor: testDoctor),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.doctorAvailability), findsOneWidget);
      expect(find.text('Dr. Gregory House'), findsOneWidget);
      expect(find.text('Diagnostic Medicine'), findsOneWidget);
      expect(find.text(tr.workingDays), findsOneWidget);
      expect(find.text(tr.workingHours), findsOneWidget);
      expect(find.text(tr.slotDuration), findsOneWidget);
      expect(find.byKey(const Key('availability_save_button')), findsOneWidget);

      for (var day = 1; day <= 7; day++) {
        expect(find.byKey(Key('availability_day_$day')), findsOneWidget);
      }

      expect(
        find.byKey(const Key('availability_preview_card')),
        findsOneWidget,
      );
      expect(find.text(tr.slotsPerDay(count: 16)), findsOneWidget);
    });

    testWidgets('toggling days updates cubit state', (
      WidgetTester tester,
    ) async {
      final repo = _FakeDoctorAvailabilityRepository();
      final cubit = DoctorAvailabilityCubit(repository: repo);

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<DoctorAvailabilityCubit>.value(
            value: cubit,
            child: DoctorAvailabilityScreen(doctor: testDoctor),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('availability_day_6')));
      await tester.pumpAndSettle();
      expect(cubit.state.workingDays.contains(6), isTrue);

      await tester.tap(find.byKey(const Key('availability_day_1')));
      await tester.pumpAndSettle();
      expect(cubit.state.workingDays.contains(1), isFalse);
    });

    testWidgets(
      'MANDATORY: an invalid range (start >= end) blocks Save and shows SnackBar error',
      (WidgetTester tester) async {
        final repo = _FakeDoctorAvailabilityRepository();
        final cubit = DoctorAvailabilityCubit(repository: repo);

        await tester.pumpWidget(
          buildTestApp(
            BlocProvider<DoctorAvailabilityCubit>.value(
              value: cubit,
              child: DoctorAvailabilityScreen(doctor: testDoctor),
            ),
          ),
        );
        await tester.pumpAndSettle();

        cubit.setStartMinutes(1020);
        cubit.setEndMinutes(540);
        await tester.pumpAndSettle();

        final saveBtn = find.byKey(const Key('availability_save_button'));
        await tester.ensureVisible(saveBtn);
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        expect(repo.savedAvailabilities, isEmpty);

        expect(find.text(tr.errorStartMustBeBeforeEnd), findsOneWidget);
      },
    );

    testWidgets('empty working days blocks Save and shows SnackBar error', (
      WidgetTester tester,
    ) async {
      final repo = _FakeDoctorAvailabilityRepository();
      final cubit = DoctorAvailabilityCubit(repository: repo);

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<DoctorAvailabilityCubit>.value(
            value: cubit,
            child: DoctorAvailabilityScreen(doctor: testDoctor),
          ),
        ),
      );
      await tester.pumpAndSettle();

      cubit.setWorkingDays({});
      await tester.pumpAndSettle();

      final saveBtn = find.byKey(const Key('availability_save_button'));
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(repo.savedAvailabilities, isEmpty);
      expect(find.text(tr.errorSelectAtLeastOneDay), findsOneWidget);
    });

    testWidgets(
      'successful Save calls repository and displays success SnackBar',
      (WidgetTester tester) async {
        final repo = _FakeDoctorAvailabilityRepository();
        final cubit = DoctorAvailabilityCubit(repository: repo);

        await tester.pumpWidget(
          buildTestApp(
            BlocProvider<DoctorAvailabilityCubit>.value(
              value: cubit,
              child: DoctorAvailabilityScreen(doctor: testDoctor),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final saveBtn = find.byKey(const Key('availability_save_button'));
        await tester.ensureVisible(saveBtn);
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        expect(repo.savedAvailabilities.length, 1);
        expect(find.text(tr.availabilityUpdatedSuccess), findsOneWidget);
      },
    );
  });
}
