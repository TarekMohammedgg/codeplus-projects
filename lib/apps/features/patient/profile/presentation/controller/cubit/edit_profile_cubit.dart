import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'edit_profile_state.dart';

export 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({required this.repository, required this.authRepository})
    : super(const EditProfileInitial());

  final ProfileRepository repository;
  final AuthRepository authRepository;

  User? get currentUser => authRepository.currentUser;

  Future<void> save({
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? currentPhotoUrl,
    Uint8List? newImageBytes,
    String? newImageName,
  }) async {
    if (state is EditProfileSaving) return;
    final uid = currentUser?.uid;
    if (uid == null) {
      emit(EditProfileFailure(tr.userNotFoundError));
      return;
    }

    emit(const EditProfileSaving());
    try {
      await repository.saveProfile(
        uid: uid,
        name: name,
        phone: phone,
        dob: dob,
        gender: gender,
        currentPhotoUrl: currentPhotoUrl,
        newImageBytes: newImageBytes,
        newImageName: newImageName,
      );
      if (!isClosed) emit(const EditProfileSuccess());
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(EditProfileFailure(AppException.from(error).message));
    }
  }
}
