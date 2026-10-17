import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/data/repositories/rate_doctor_repository.dart';
import 'rate_doctor_state.dart';

export 'rate_doctor_state.dart';

class RateDoctorCubit extends Cubit<RateDoctorState> {
  RateDoctorCubit({required this.repository}) : super(const RateDoctorState());

  final RateDoctorRepository repository;

  void setRating(int rating) {
    if (rating < 1 || rating > 5) return;
    emit(
      state.copyWith(
        rating: rating,
        status: state.status == RateDoctorStatus.failure
            ? RateDoctorStatus.initial
            : state.status,
        error: null,
      ),
    );
  }

  void setComment(String comment) {
    emit(state.copyWith(comment: comment));
  }

  Future<void> loadSpecialty(String? specialtyId) async {
    try {
      final name = await repository.getSpecialtyName(specialtyId);
      if (!isClosed && name != null) {
        emit(state.copyWith(specialtyName: name));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> submitReview(AppointmentModel appointment) async {
    if (appointment.status != AppointmentStatus.completed ||
        appointment.isReviewed) {
      emit(
        state.copyWith(
          status: RateDoctorStatus.failure,
          error: appointment.isReviewed
              ? AppErrorCode.alreadyReviewed
              : AppErrorCode.appointmentNotCompleted,
        ),
      );
      return;
    }

    if (state.rating < 1 || state.rating > 5) {
      emit(
        state.copyWith(
          status: RateDoctorStatus.failure,
          error: AppErrorCode.ratingRequired,
        ),
      );
      return;
    }

    emit(state.copyWith(status: RateDoctorStatus.submitting));

    try {
      await repository.submitReview(
        appointment: appointment,
        rating: state.rating,
        comment: state.comment,
      );
      if (!isClosed) {
        emit(state.copyWith(status: RateDoctorStatus.success));
      }
    } catch (e) {
      if (!isClosed) {
        final ex = AppException.from(e);
        emit(state.copyWith(status: RateDoctorStatus.failure, error: ex.code));
      }
    }
  }
}
