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
}
