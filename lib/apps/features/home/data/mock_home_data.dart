import 'package:doctor_hunt/apps/features/home/data/doctors_home_data.dart'
    as home_data;
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';

abstract final class MockHomeData {
  static List<DoctorModel> liveDoctors() {
    return home_data.liveDoctors();
  }

  static List<DoctorCategoryItem> categories() {
    return home_data.categories();
  }

  static List<DoctorModel> popularDoctors() {
    return home_data.popularDoctors();
  }

  static List<DoctorModel> featuredDoctors() {
    return home_data.featuredDoctors();
  }
}
