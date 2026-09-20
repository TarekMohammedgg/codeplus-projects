import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/cubit/create_doctor_state.dart';

class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  CreateDoctorCubit({required this.repository})
    : super(const CreateDoctorInitial());

  final CreateDoctorRepository repository;

  Future<void> loadSpecialties() async {
    if (state is CreateDoctorLoading) return;

    emit(const CreateDoctorLoading());
    try {
      final specialties = await repository.fetchSpecialties();
      emit(CreateDoctorSuccess(specialties: specialties));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(CreateDoctorFailure(errorMessage: error.toString()));
    }
  }

  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) {
    return repository.uploadImage(bytes: bytes, fileName: fileName);
  }

  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) {
    return repository.createDoctor(
      fullNameAr: fullNameAr,
      fullNameEn: fullNameEn,
      specialtyId: specialtyId,
      imageUrl: imageUrl,
    );
  }

  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) {
    return repository.updateDoctor(
      id: id,
      fullNameAr: fullNameAr,
      fullNameEn: fullNameEn,
      specialtyId: specialtyId,
      imageUrl: imageUrl,
    );
  }
}
