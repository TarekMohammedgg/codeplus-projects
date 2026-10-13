import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/review_service.dart';

abstract interface class DoctorDetailsRepository {
  Future<List<ReviewModel>> fetchRecentReviews(String doctorId);

  Stream<ClinicModel?> watchClinic();
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
  Stream<ClinicModel?> watchClinic() => clinicService.streamClinic();
}
