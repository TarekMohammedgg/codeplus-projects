import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

class BookingDraft {
  const BookingDraft({required this.doctor, required this.startAt});

  final DoctorModel doctor;
  final DateTime startAt;
}
