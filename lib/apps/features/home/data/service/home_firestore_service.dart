import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';

Future<List<DoctorModel>> fetchHomeDoctors() async {
  return DoctorService().fetchHomeDoctors();
}
