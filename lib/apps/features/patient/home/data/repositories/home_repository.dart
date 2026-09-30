import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/service/home_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/models/home_data.dart';

abstract interface class HomeRepository {
  Future<HomeData> fetchHomeData();
}

class FirebaseHomeRepository implements HomeRepository {
  FirebaseHomeRepository({
    required this.homeService,
    required this.specialtyService,
  });

  final HomeService homeService;
  final SpecialtyService specialtyService;

  @override
  Future<HomeData> fetchHomeData() async {
    final doctors = await homeService.fetchHomeDoctors();
    final specialties = await specialtyService.fetchActiveSpecialties();

    return HomeData(
      popularDoctors: sortByPopularity(doctors),
      topRatedDoctors: sortByTopRated(doctors),
      specialties: specialties,
    );
  }
}

// Sorted in Dart (small clinic dataset), so Firestore needs no composite index.
List<DoctorModel> sortByPopularity(List<DoctorModel> doctors) =>
    [...doctors]..sort((a, b) {
      final byReviews = b.reviewsCount.compareTo(a.reviewsCount);
      return byReviews != 0 ? byReviews : b.rating.compareTo(a.rating);
    });

List<DoctorModel> sortByTopRated(List<DoctorModel> doctors) => [...doctors]
  ..sort((a, b) {
    final byRating = b.rating.compareTo(a.rating);
    return byRating != 0 ? byRating : b.reviewsCount.compareTo(a.reviewsCount);
  });
