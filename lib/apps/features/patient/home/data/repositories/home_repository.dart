import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/models/home_data.dart';
import 'package:doctor_hunt/apps/features/common/specialty/data/service/specialty_service.dart';

abstract interface class HomeRepository {
  Future<HomeData> fetchHomeData();
}

class FirebaseHomeRepository implements HomeRepository {
  FirebaseHomeRepository({
    required this.doctorService,
    required this.specialtyService,
  });

  final DoctorService doctorService;
  final SpecialtyService specialtyService;

  @override
  Future<HomeData> fetchHomeData() async {
    final doctors = await doctorService.fetchDoctors();
    final specialties = await specialtyService.fetchActiveSpecialties();

    return HomeData(doctors: doctors, specialties: specialties);
  }
}
