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

    return HomeData(doctors: doctors, specialties: specialties);
  }
}
