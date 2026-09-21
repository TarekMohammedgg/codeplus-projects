import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';

class HomeService {
  HomeService({
    required DoctorService doctorService,
    // ignore: prefer_initializing_formals
  }) : _doctorService = doctorService;

  final DoctorService _doctorService;

  Future<List<DoctorModel>> fetchHomeDoctors() =>
      _doctorService.fetchActiveDoctors();
}
