import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/data/repositories/doctor_details_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  DoctorDetailsCubit({required this.repository})
    : super(const DoctorDetailsInitial());

  final DoctorDetailsRepository repository;
  StreamSubscription<ClinicModel?>? _clinicSubscription;

  Future<void> load(String doctorId) async {
    if (state is DoctorDetailsLoading) return;

    emit(const DoctorDetailsLoading());
    await _clinicSubscription?.cancel();
    try {
      final reviews = await repository.fetchRecentReviews(doctorId);
      if (isClosed) return;
      _clinicSubscription = repository.watchClinic().listen(
        (clinic) {
          if (!isClosed) {
            emit(DoctorDetailsSuccess(reviews: reviews, clinic: clinic));
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          addError(error, stackTrace);
          if (!isClosed) {
            emit(DoctorDetailsFailure(errorMessage: error.toString()));
          }
        },
      );
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(DoctorDetailsFailure(errorMessage: error.toString()));
    }
  }

  @override
  Future<void> close() {
    _clinicSubscription?.cancel();
    return super.close();
  }
}
