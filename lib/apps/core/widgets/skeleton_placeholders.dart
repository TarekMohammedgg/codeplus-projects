import 'package:skeletonizer/skeletonizer.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';

/// Fake core models that only give skeleton loading states their shape.

AppointmentModel skeletonAppointment() => AppointmentModel(
  id: '',
  patientId: '',
  patientName: BoneMock.name,
  patientEmail: BoneMock.email,
  patientPhone: BoneMock.phone,
  doctorId: '',
  doctorNameAr: BoneMock.fullName,
  doctorNameEn: BoneMock.fullName,
  startAt: DateTime.now(),
  slotId: '',
  status: AppointmentStatus.upcoming,
);

ReviewModel skeletonReview() => ReviewModel(
  appointmentId: '',
  patientId: '',
  patientName: BoneMock.name,
  doctorId: '',
  rating: 5,
  comment: BoneMock.subtitle,
  createdAt: DateTime.now(),
);
