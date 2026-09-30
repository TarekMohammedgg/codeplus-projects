import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/services/review_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';

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
    required this.authService,
    required this.specialtyService,
  });

  final ReviewService reviewService;
  final AuthService authService;
  final SpecialtyService specialtyService;

  @override
  Future<void> submitReview({
    required AppointmentModel appointment,
    required int rating,
    String comment = '',
  }) async {
    final patientName = appointment.patientName.trim().isNotEmpty
        ? appointment.patientName.trim()
        : (authService.currentUser?.displayName ?? 'Patient');

    await reviewService.submitReview(
      appointment: appointment,
      rating: rating,
      patientName: patientName,
      comment: comment.trim(),
    );
  }

  @override
  Future<String?> getSpecialtyName(String? specialtyId) async {
    if (specialtyId == null || specialtyId.isEmpty) return null;
    try {
      final list = await specialtyService.fetchActiveSpecialties();
      final match = list.where((s) => s.id == specialtyId).firstOrNull;
      return match?.localizedName;
    } catch (_) {
      return null;
    }
  }
}
