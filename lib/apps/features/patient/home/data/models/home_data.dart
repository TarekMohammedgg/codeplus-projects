import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

class HomeData {
  const HomeData({
    required this.popularDoctors,
    required this.topRatedDoctors,
    required this.specialties,
  });

  final List<DoctorModel> popularDoctors;

  final List<DoctorModel> topRatedDoctors;
  final List<SpecialtyModel> specialties;
}
