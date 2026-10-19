import 'package:doctor_hunt/apps/core/errors/app_exception.dart';

enum RateDoctorStatus { initial, submitting, success, failure }

class RateDoctorState {
  const RateDoctorState({
    this.status = RateDoctorStatus.initial,
    this.rating = 0,
    this.comment = '',
    this.specialtyName,
    this.error,
  });

  final RateDoctorStatus status;
  final int rating;
  final String comment;
  final String? specialtyName;
  final AppErrorCode? error;

  bool get canSubmit =>
      rating >= 1 && rating <= 5 && status != RateDoctorStatus.submitting;

  RateDoctorState copyWith({
    RateDoctorStatus? status,
    int? rating,
    String? comment,
    String? specialtyName,
    AppErrorCode? error,
  }) {
    return RateDoctorState(
      status: status ?? this.status,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      specialtyName: specialtyName ?? this.specialtyName,
      error: error,
    );
  }
}
