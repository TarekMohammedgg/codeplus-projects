import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/review_service.dart';

abstract interface class DoctorDetailsRepository {
  /// Newest first.
  Future<List<ReviewModel>> fetchRecentReviews(String doctorId);

  /// The one clinic location shown for every doctor; null until the admin
  /// sets it.
  Future<ClinicModel?> fetchClinic();
}

class FirebaseDoctorDetailsRepository implements DoctorDetailsRepository {
  FirebaseDoctorDetailsRepository({
    required this.reviewService,
    required this.clinicService,
  });

  final ReviewService reviewService;
  final ClinicService clinicService;

  @override
  Future<List<ReviewModel>> fetchRecentReviews(String doctorId) =>
      reviewService.fetchRecentReviews(doctorId);

  @override
  Future<ClinicModel?> fetchClinic() => clinicService.fetchClinic();
}
