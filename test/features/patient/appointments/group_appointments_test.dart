import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/controller/cubit/patient_appointments_state.dart';

AppointmentModel _buildAppt({
  required String id,
  required AppointmentStatus status,
  required DateTime startAt,
  CancelledBy? cancelledBy,
  bool isReviewed = false,
}) {
  return AppointmentModel(
    id: id,
    patientId: 'patient_1',
    patientName: 'John Patient',
    patientEmail: 'patient@example.com',
    patientPhone: '01012345678',
    doctorId: 'doctor_1',
    doctorNameAr: 'د. مجدي',
    doctorNameEn: 'Dr. Magdi',
    startAt: startAt,
    slotId: 'slot_$id',
    status: status,
    cancelledBy: cancelledBy,
    isReviewed: isReviewed,
  );
}

void main() {
  group('groupAppointmentsByStatus', () {
    test('returns empty lists for an empty input list', () {
      final grouped = groupAppointmentsByStatus([]);

      expect(grouped.upcoming, isEmpty);
      expect(grouped.completed, isEmpty);
      expect(grouped.cancelled, isEmpty);
    });

    test('groups appointments by status correctly', () {
      final now = DateTime(2026, 10, 1, 10, 0);
      final appointments = [
        _buildAppt(
          id: 'up_1',
          status: AppointmentStatus.upcoming,
          startAt: now,
        ),
        _buildAppt(
          id: 'comp_1',
          status: AppointmentStatus.completed,
          startAt: now,
        ),
        _buildAppt(
          id: 'canc_1',
          status: AppointmentStatus.cancelled,
          startAt: now,
        ),
      ];

      final grouped = groupAppointmentsByStatus(appointments);

      expect(grouped.upcoming.map((a) => a.id), ['up_1']);
      expect(grouped.completed.map((a) => a.id), ['comp_1']);
      expect(grouped.cancelled.map((a) => a.id), ['canc_1']);
    });

    test('sorts upcoming soonest first (ascending startAt)', () {
      final t1 = DateTime(2026, 10, 5, 10, 0);
      final t2 = DateTime(2026, 10, 2, 9, 0);
      final t3 = DateTime(2026, 10, 8, 14, 0);

      final appointments = [
        _buildAppt(
          id: 'up_later',
          status: AppointmentStatus.upcoming,
          startAt: t1,
        ),
        _buildAppt(
          id: 'up_soonest',
          status: AppointmentStatus.upcoming,
          startAt: t2,
        ),
        _buildAppt(
          id: 'up_latest',
          status: AppointmentStatus.upcoming,
          startAt: t3,
        ),
      ];

      final grouped = groupAppointmentsByStatus(appointments);

      expect(grouped.upcoming.map((a) => a.id), [
        'up_soonest',
        'up_later',
        'up_latest',
      ]);
    });

    test('sorts completed latest first (descending startAt)', () {
      final t1 = DateTime(2026, 9, 1, 10, 0);
      final t2 = DateTime(2026, 9, 15, 14, 0);
      final t3 = DateTime(2026, 9, 10, 11, 0);

      final appointments = [
        _buildAppt(
          id: 'comp_oldest',
          status: AppointmentStatus.completed,
          startAt: t1,
        ),
        _buildAppt(
          id: 'comp_newest',
          status: AppointmentStatus.completed,
          startAt: t2,
        ),
        _buildAppt(
          id: 'comp_middle',
          status: AppointmentStatus.completed,
          startAt: t3,
        ),
      ];

      final grouped = groupAppointmentsByStatus(appointments);

      expect(grouped.completed.map((a) => a.id), [
        'comp_newest',
        'comp_middle',
        'comp_oldest',
      ]);
    });

    test('sorts cancelled latest first (descending startAt)', () {
      final t1 = DateTime(2026, 8, 5, 10, 0);
      final t2 = DateTime(2026, 8, 20, 12, 0);
      final t3 = DateTime(2026, 8, 12, 16, 0);

      final appointments = [
        _buildAppt(
          id: 'canc_oldest',
          status: AppointmentStatus.cancelled,
          startAt: t1,
        ),
        _buildAppt(
          id: 'canc_newest',
          status: AppointmentStatus.cancelled,
          startAt: t2,
        ),
        _buildAppt(
          id: 'canc_middle',
          status: AppointmentStatus.cancelled,
          startAt: t3,
        ),
      ];

      final grouped = groupAppointmentsByStatus(appointments);

      expect(grouped.cancelled.map((a) => a.id), [
        'canc_newest',
        'canc_middle',
        'canc_oldest',
      ]);
    });
  });
}
