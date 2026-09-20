import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/common/specialty/data/models/specialty_model.dart';

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
    required List<DoctorModel> doctors,
    required List<SpecialtyModel> specialties,
  }) : doctors = List.unmodifiable(doctors),
       specialties = List.unmodifiable(specialties);

  final List<DoctorModel> doctors;
  final List<SpecialtyModel> specialties;
}

final class HomeFailure extends HomeState {
  const HomeFailure({required this.errorMessage});

  final String errorMessage;
}
