import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeSuccess extends HomeState {
  HomeSuccess({
    required List<DoctorModel> popularDoctors,
    required List<DoctorModel> topRatedDoctors,
    required List<SpecialtyModel> specialties,
  }) : popularDoctors = List.unmodifiable(popularDoctors),
       topRatedDoctors = List.unmodifiable(topRatedDoctors),
       specialties = List.unmodifiable(specialties);

  final List<DoctorModel> popularDoctors;
  final List<DoctorModel> topRatedDoctors;
  final List<SpecialtyModel> specialties;
}

final class HomeFailure extends HomeState {
  const HomeFailure();
}
