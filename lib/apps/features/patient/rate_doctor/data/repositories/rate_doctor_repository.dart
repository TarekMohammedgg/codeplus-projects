import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/services/review_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

abstract class RateDoctorRepository {
  Future<void> submitReview({
    required AppointmentModel appointment,
    required int rating,
    String comment = '',
  });

  Future<String?> getSpecialtyName(String? specialtyId);
}

class RateDoctorRepositoryImpl implements RateDoctorRepository {
  const RateDoctorRepositoryImpl({
    required this.reviewService,
    required this.specialtyService,
  });

  final ReviewService reviewService;
  final SpecialtyService specialtyService;

  @override
  Future<void> submitReview({
    required AppointmentModel appointment,
    required int rating,
    String comment = '',
  }) {
    return reviewService.submitReview(
      appointment: appointment,
      rating: rating,
      patientName: appointment.patientName,
      comment: comment.trim(),
    );
  }

  @override
  Future<String?> getSpecialtyName(String? specialtyId) =>
      specialtyService.fetchSpecialtyName(specialtyId);
}
