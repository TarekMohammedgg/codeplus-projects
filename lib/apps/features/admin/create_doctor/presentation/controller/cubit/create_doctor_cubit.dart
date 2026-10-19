import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_state.dart';

class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  CreateDoctorCubit({required this.repository})
    : super(const CreateDoctorInitial());

  final CreateDoctorRepository repository;

  Future<void> loadSpecialties() async {
    if (state is CreateDoctorLoading) return;

    emit(const CreateDoctorLoading());
    try {
      final specialties = await repository.fetchSpecialties();
      if (isClosed) return;
      emit(CreateDoctorSuccess(specialties: specialties));
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(CreateDoctorFailure(error: AppException.from(error).code));
    }
  }

  Future<void> submit({
    String? doctorId,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    required double consultationFee,
    String? imageUrl,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final current = state;
    if (current is! CreateDoctorSuccess || current.isSubmitting) return;

    var url = imageUrl;
    if (imageBytes != null) {
      emit(current.copyWith(submit: CreateDoctorSubmit.uploadingImage));
      try {
        url = await repository.uploadImage(
          bytes: imageBytes,
          fileName: imageName ?? 'doctor.jpg',
        );
      } catch (error, stackTrace) {
        _fail(current, AppErrorCode.uploadImage, error, stackTrace);
        return;
      }
    }

    emit(current.copyWith(submit: CreateDoctorSubmit.saving));
    try {
      if (doctorId != null) {
        await repository.updateDoctor(
          id: doctorId,
          fullNameAr: fullNameAr,
          fullNameEn: fullNameEn,
          specialtyId: specialtyId,
          consultationFee: consultationFee,
          imageUrl: url,
        );
      } else {
        await repository.createDoctor(
          fullNameAr: fullNameAr,
          fullNameEn: fullNameEn,
          specialtyId: specialtyId,
          consultationFee: consultationFee,
          imageUrl: url,
        );
      }
      if (!isClosed) emit(current.copyWith(submit: CreateDoctorSubmit.saved));
    } catch (error, stackTrace) {
      _fail(current, AppException.from(error).code, error, stackTrace);
    }
  }

  void _fail(
    CreateDoctorSuccess current,
    AppErrorCode code,
    Object error,
    StackTrace stackTrace,
  ) {
    if (isClosed) return;
    addError(error, stackTrace);
    emit(
      current.copyWith(submit: CreateDoctorSubmit.failed, submitError: code),
    );
  }
}
