import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/data/repositories/rate_doctor_repository.dart';

enum RateDoctorStatus { initial, submitting, success, failure }

class RateDoctorState {
  const RateDoctorState({
    this.status = RateDoctorStatus.initial,
    this.rating = 0,
    this.comment = '',
    this.specialtyName,
    this.errorMessage,
  });

  final RateDoctorStatus status;
  final int rating;
  final String comment;
  final String? specialtyName;
  final String? errorMessage;

  bool get canSubmit =>
      rating >= 1 && rating <= 5 && status != RateDoctorStatus.submitting;

  RateDoctorState copyWith({
    RateDoctorStatus? status,
    int? rating,
    String? comment,
    String? specialtyName,
    String? errorMessage,
  }) {
    return RateDoctorState(
      status: status ?? this.status,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      specialtyName: specialtyName ?? this.specialtyName,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RateDoctorState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          rating == other.rating &&
          comment == other.comment &&
          specialtyName == other.specialtyName &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      Object.hash(status, rating, comment, specialtyName, errorMessage);
}

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
        errorMessage: null,
      ),
    );
  }

  void setComment(String comment) {
    emit(state.copyWith(comment: comment));
  }

  Future<void> loadSpecialty(String? specialtyId) async {
    final name = await repository.getSpecialtyName(specialtyId);
    if (!isClosed && name != null) {
      emit(state.copyWith(specialtyName: name));
    }
  }

  Future<void> submitReview(AppointmentModel appointment) async {
    if (appointment.status != AppointmentStatus.completed ||
        appointment.isReviewed) {
      emit(
        state.copyWith(
          status: RateDoctorStatus.failure,
          errorMessage: 'Only completed, unreviewed appointments can be rated.',
        ),
      );
      return;
    }

    if (state.rating < 1 || state.rating > 5) {
      emit(
        state.copyWith(
          status: RateDoctorStatus.failure,
          errorMessage: 'Please select a rating from 1 to 5 stars.',
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
        emit(
          state.copyWith(
            status: RateDoctorStatus.failure,
            errorMessage: ex.message,
          ),
        );
      }
    }
  }
}
