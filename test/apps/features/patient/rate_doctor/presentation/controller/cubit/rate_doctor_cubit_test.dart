import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/data/repositories/rate_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/presentation/controller/cubit/rate_doctor_cubit.dart';

class _MockRateDoctorRepository implements RateDoctorRepository {
  bool submitCalled = false;
  AppointmentModel? submittedAppointment;
  int? submittedRating;
  String? submittedComment;
  Exception? errorToThrow;
  String? specialtyNameToReturn = 'Cardiology';

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
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
  }

  @override
  Future<String?> getSpecialtyName(String? specialtyId) async {
    return specialtyNameToReturn;
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
    doctorNameAr: 'د. مجدي يعقوب',
    doctorNameEn: 'Dr. Magdi Yacoub',
    startAt: DateTime(2026, 9, 15, 10, 30),
    slotId: 'slot_1',
    status: status,
    isReviewed: isReviewed,
    specialtyId: 'spec_1',
    fee: 100,
  );
}

void main() {
  late _MockRateDoctorRepository mockRepo;
  late RateDoctorCubit cubit;

  setUp(() {
    mockRepo = _MockRateDoctorRepository();
    cubit = RateDoctorCubit(repository: mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('RateDoctorCubit', () {
    test('initial state has default values', () {
      expect(cubit.state.status, RateDoctorStatus.initial);
      expect(cubit.state.rating, 0);
      expect(cubit.state.comment, '');
      expect(cubit.state.canSubmit, isFalse);
    });

    test('setRating updates rating and enables canSubmit for 1..5', () {
      cubit.setRating(4);
      expect(cubit.state.rating, 4);
      expect(cubit.state.canSubmit, isTrue);

      cubit.setRating(0);
      expect(cubit.state.rating, 4);

      cubit.setRating(6);
      expect(cubit.state.rating, 4);
    });

    test('setComment updates comment', () {
      cubit.setComment('Great experience!');
      expect(cubit.state.comment, 'Great experience!');
    });

    test('loadSpecialty updates specialtyName', () async {
      await cubit.loadSpecialty('spec_1');
      expect(cubit.state.specialtyName, 'Cardiology');
    });

    test('submitReview rejects if appointment is not completed', () async {
      final appt = _buildTestAppointment(status: AppointmentStatus.upcoming);
      cubit.setRating(5);

      await cubit.submitReview(appt);

      expect(cubit.state.status, RateDoctorStatus.failure);
      expect(mockRepo.submitCalled, isFalse);
    });

    test('submitReview rejects if appointment is already reviewed', () async {
      final appt = _buildTestAppointment(
        status: AppointmentStatus.completed,
        isReviewed: true,
      );
      cubit.setRating(5);

      await cubit.submitReview(appt);

      expect(cubit.state.status, RateDoctorStatus.failure);
      expect(mockRepo.submitCalled, isFalse);
    });

    test(
      'submitReview rejects if rating is not selected (rating == 0)',
      () async {
        final appt = _buildTestAppointment();

        await cubit.submitReview(appt);

        expect(cubit.state.status, RateDoctorStatus.failure);
        expect(mockRepo.submitCalled, isFalse);
      },
    );

    test(
      'submitReview submits review successfully and emits success',
      () async {
        final appt = _buildTestAppointment();
        cubit.setRating(5);
        cubit.setComment('Excellent doctor!');

        await cubit.submitReview(appt);

        expect(cubit.state.status, RateDoctorStatus.success);
        expect(mockRepo.submitCalled, isTrue);
        expect(mockRepo.submittedRating, 5);
        expect(mockRepo.submittedComment, 'Excellent doctor!');
        expect(mockRepo.submittedAppointment?.id, 'appt_123');
      },
    );

    test('submitReview emits failure on repository error', () async {
      final appt = _buildTestAppointment();
      cubit.setRating(4);
      mockRepo.errorToThrow = Exception('Network error');

      await cubit.submitReview(appt);

      expect(cubit.state.status, RateDoctorStatus.failure);
      expect(cubit.state.error, isNotNull);
    });
  });
}
