import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';

class AdminDoctorDetailsState {
  const AdminDoctorDetailsState({
    required this.doctor,
    this.isLoading = false,
    this.isTogglingActive = false,
    this.errorMessage,
  });

  final DoctorModel doctor;
  final bool isLoading;
  final bool isTogglingActive;
  final String? errorMessage;

  AdminDoctorDetailsState copyWith({
    DoctorModel? doctor,
    bool? isLoading,
    bool? isTogglingActive,
    String? errorMessage,
  }) {
    return AdminDoctorDetailsState(
      doctor: doctor ?? this.doctor,
      isLoading: isLoading ?? this.isLoading,
      isTogglingActive: isTogglingActive ?? this.isTogglingActive,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminDoctorDetailsState &&
          runtimeType == other.runtimeType &&
          doctor.id == other.doctor.id &&
          doctor.name == other.doctor.name &&
          doctor.isActive == other.doctor.isActive &&
          doctor.rating == other.doctor.rating &&
          doctor.reviewsCount == other.doctor.reviewsCount &&
          doctor.consultationFee == other.doctor.consultationFee &&
          doctor.imageUrl == other.doctor.imageUrl &&
          doctor.specialty == other.doctor.specialty &&
          isLoading == other.isLoading &&
          isTogglingActive == other.isTogglingActive &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
    doctor.id,
    doctor.name,
    doctor.isActive,
    doctor.rating,
    doctor.reviewsCount,
    doctor.consultationFee,
    isLoading,
    isTogglingActive,
    errorMessage,
  );
}

class AdminDoctorDetailsCubit extends Cubit<AdminDoctorDetailsState> {
  AdminDoctorDetailsCubit({
    required DoctorModel initialDoctor,
    required this.doctorService,
  }) : super(AdminDoctorDetailsState(doctor: initialDoctor)) {
    _init();
  }

  final AdminDoctorService doctorService;
  StreamSubscription<DoctorModel?>? _subscription;

  void _init() {
    _subscription = doctorService
        .streamDoctor(state.doctor.id)
        .listen(
          (updated) {
            if (!isClosed && updated != null) {
              emit(state.copyWith(doctor: updated));
            }
          },
          onError: (e) {
            if (!isClosed) {
              final ex = AppException.from(e);
              emit(state.copyWith(errorMessage: ex.message));
            }
          },
        );
  }

  Future<void> toggleActive(bool isActive) async {
    emit(state.copyWith(isTogglingActive: true, errorMessage: null));
    try {
      await doctorService.setActive(state.doctor.id, isActive);
      if (!isClosed) {
        emit(
          state.copyWith(
            isTogglingActive: false,
            doctor: state.doctor.copyWith(isActive: isActive),
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        final ex = AppException.from(e);
        emit(state.copyWith(isTogglingActive: false, errorMessage: ex.message));
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
