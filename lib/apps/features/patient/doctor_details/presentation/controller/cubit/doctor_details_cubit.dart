import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/features/patient/doctor_details/data/repositories/doctor_details_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  DoctorDetailsCubit({required this.repository})
    : super(const DoctorDetailsInitial());

  final DoctorDetailsRepository repository;

  Future<void> load(String doctorId) async {
    if (state is DoctorDetailsLoading) return;

    emit(const DoctorDetailsLoading());
    try {
      final (reviews, clinic) = await (
        repository.fetchRecentReviews(doctorId),
        repository.fetchClinic(),
      ).wait;
      if (isClosed) return;
      emit(DoctorDetailsSuccess(reviews: reviews, clinic: clinic));
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(DoctorDetailsFailure(errorMessage: error.toString()));
    }
  }
}
