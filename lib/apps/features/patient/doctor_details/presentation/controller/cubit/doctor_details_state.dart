import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';

sealed class DoctorDetailsState {
  const DoctorDetailsState();
}

final class DoctorDetailsInitial extends DoctorDetailsState {
  const DoctorDetailsInitial();
}

final class DoctorDetailsLoading extends DoctorDetailsState {
  const DoctorDetailsLoading();
}

final class DoctorDetailsSuccess extends DoctorDetailsState {
  DoctorDetailsSuccess({required List<ReviewModel> reviews, this.clinic})
    : reviews = List.unmodifiable(reviews);

  final List<ReviewModel> reviews;
  final ClinicModel? clinic;
}

final class DoctorDetailsFailure extends DoctorDetailsState {
  const DoctorDetailsFailure({required this.errorMessage});

  final String errorMessage;
}
