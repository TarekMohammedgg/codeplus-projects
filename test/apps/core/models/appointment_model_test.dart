import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';

AppointmentModel _appointmentAt(DateTime startAt) {
  return AppointmentModel(
    id: 'appt_1',
    patientId: 'patient_1',
    patientName: 'Jane',
    patientEmail: 'jane@example.com',
    patientPhone: '01011112222',
    doctorId: 'doctor_1',
    doctorNameAr: 'د. أحمد',
    doctorNameEn: 'Dr. Ahmed',
    startAt: startAt,
    slotId: 'slot_1',
    status: AppointmentStatus.upcoming,
    isReviewed: false,
    fee: 50,
  );
}

void main() {
  group('AppointmentModel.hasStarted', () {
    test('is false for an appointment in the future', () {
      final appointment = _appointmentAt(
        DateTime.now().add(const Duration(hours: 1)),
      );

      final hasStarted = appointment.hasStarted;

      expect(hasStarted, isFalse);
    });

    test('is true once the appointment time has passed', () {
      final appointment = _appointmentAt(
        DateTime.now().subtract(const Duration(minutes: 1)),
      );

      final hasStarted = appointment.hasStarted;

      expect(hasStarted, isTrue);
    });
  });
}
