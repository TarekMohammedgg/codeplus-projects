import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/data/repositories/rate_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/presentation/cubit/rate_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/presentation/screens/rate_doctor_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

class _FakeRateDoctorRepository implements RateDoctorRepository {
  bool submitCalled = false;
  AppointmentModel? submittedAppointment;
  int? submittedRating;
  String? submittedComment;

  @override
  Future<void> submitReview({
    required AppointmentModel appointment,
    required int rating,
    String comment = '',
  }) async {
    submitCalled = true;
    submittedAppointment = appointment;
    submittedRating = rating;
    submittedComment = comment;
  }

  @override
  Future<String?> getSpecialtyName(String? specialtyId) async {
    return 'Cardiology';
  }
}

AppointmentModel _buildTestAppointment({
  AppointmentStatus status = AppointmentStatus.completed,
  bool isReviewed = false,
}) {
  return AppointmentModel(
    id: 'appt_123',
    patientId: 'patient_1',
    patientName: 'Jane Doe',
    patientEmail: 'jane@example.com',
    patientPhone: '+1234567890',
    doctorId: 'doc_1',
    doctorNameAr: 'د. غريغوري هاوس',
    doctorNameEn: 'Dr. Gregory House',
    startAt: DateTime(2026, 9, 15, 10, 30),
    slotId: 'slot_1',
    status: status,
    isReviewed: isReviewed,
    specialtyId: 'spec_1',
    fee: 100,
  );
}

void main() {
  late _FakeRateDoctorRepository fakeRepo;
  late RateDoctorCubit cubit;

  setUp(() {
    fakeRepo = _FakeRateDoctorRepository();
    cubit = RateDoctorCubit(repository: fakeRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('RateDoctorScreen', () {
    testWidgets(
      'renders doctor summary, stars, comment field, and disabled submit button initially',
      (WidgetTester tester) async {
        final appt = _buildTestAppointment();

        await tester.pumpWidget(
          buildTestApp(
            BlocProvider<RateDoctorCubit>.value(
              value: cubit,
              child: RateDoctorScreen(appointment: appt),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(tr.rateDoctorTitle), findsOneWidget);
        expect(find.text('Dr. Gregory House'), findsOneWidget);
        expect(find.byKey(const Key('star_1')), findsOneWidget);
        expect(find.byKey(const Key('star_5')), findsOneWidget);
        expect(
          find.byKey(const Key('rate_doctor_comment_field')),
          findsOneWidget,
        );

        final submitFinder = find.byKey(const Key('rate_doctor_submit_button'));
        expect(submitFinder, findsOneWidget);

        final button = tester.widget<ElevatedButton>(
          find.descendant(
            of: submitFinder,
            matching: find.byType(ElevatedButton),
          ),
        );
        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'tapping star enables submit button and selecting stars updates rating',
      (WidgetTester tester) async {
        final appt = _buildTestAppointment();

        await tester.pumpWidget(
          buildTestApp(
            BlocProvider<RateDoctorCubit>.value(
              value: cubit,
              child: RateDoctorScreen(appointment: appt),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('star_4')));
        await tester.pumpAndSettle();

        expect(cubit.state.rating, 4);

        final submitFinder = find.byKey(const Key('rate_doctor_submit_button'));
        final button = tester.widget<ElevatedButton>(
          find.descendant(
            of: submitFinder,
            matching: find.byType(ElevatedButton),
          ),
        );
        expect(button.onPressed, isNotNull);
      },
    );

    testWidgets(
      'entering comment and tapping submit calls submitReview on cubit',
      (WidgetTester tester) async {
        final appt = _buildTestAppointment();

        await tester.pumpWidget(
          buildTestApp(
            BlocProvider<RateDoctorCubit>.value(
              value: cubit,
              child: RateDoctorScreen(appointment: appt),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('star_5')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('rate_doctor_comment_field')),
          'Amazing care, thank you!',
        );
        await tester.pumpAndSettle();

        expect(cubit.state.comment, 'Amazing care, thank you!');

        await tester.tap(find.byKey(const Key('rate_doctor_submit_button')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(fakeRepo.submitCalled, isTrue);
        expect(fakeRepo.submittedRating, 5);
        expect(fakeRepo.submittedComment, 'Amazing care, thank you!');
      },
    );

    testWidgets('shows guard message when appointment is not completed', (
      WidgetTester tester,
    ) async {
      final upcomingAppt = _buildTestAppointment(
        status: AppointmentStatus.upcoming,
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<RateDoctorCubit>.value(
            value: cubit,
            child: RateDoctorScreen(appointment: upcomingAppt),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.appointmentNotCompleted), findsOneWidget);
      expect(find.byKey(const Key('star_1')), findsNothing);
    });

    testWidgets('shows guard message when appointment is already reviewed', (
      WidgetTester tester,
    ) async {
      final reviewedAppt = _buildTestAppointment(
        status: AppointmentStatus.completed,
        isReviewed: true,
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<RateDoctorCubit>.value(
            value: cubit,
            child: RateDoctorScreen(appointment: reviewedAppt),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.alreadyReviewed), findsOneWidget);
      expect(find.byKey(const Key('star_1')), findsNothing);
    });
  });
}
