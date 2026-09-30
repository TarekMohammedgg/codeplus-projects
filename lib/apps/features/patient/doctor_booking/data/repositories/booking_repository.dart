import 'package:doctor_hunt/apps/core/services/appointment_service.dart';

abstract interface class BookingRepository {
  Future<Set<DateTime>> fetchBookedStarts(String doctorId, DateTime day);
}

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({required this.appointmentService});

  final AppointmentService appointmentService;

  @override
  Future<Set<DateTime>> fetchBookedStarts(String doctorId, DateTime day) {
    return appointmentService.fetchBookedStarts(doctorId, day);
  }
}
