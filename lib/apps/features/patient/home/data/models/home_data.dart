import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

class HomeData {
  const HomeData({required this.doctors, required this.specialties});

  final List<DoctorModel> doctors;
  final List<SpecialtyModel> specialties;
}
