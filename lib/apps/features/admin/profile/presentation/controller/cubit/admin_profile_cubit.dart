import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/admin/profile/data/repositories/admin_profile_repository.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_state.dart';

class AdminProfileCubit extends Cubit<AdminProfileState> {
  AdminProfileCubit({required this.repository, AdminProfileState? initialState})
    : super(initialState ?? const AdminProfileState());

  final AdminProfileRepository repository;

  Future<void> loadCurrentProfile() async {
    final uid = repository.currentUid;
    if (uid == null) return;
    await loadProfile(uid);
  }

  Future<void> loadProfile(String uid) async {
    emit(state.copyWith(status: AdminProfileStatus.loading));
    try {
      final profile = await repository.fetchAdminProfile(uid);
      final clinic = await repository.fetchClinic();

      emit(
        state.copyWith(
          status: AdminProfileStatus.loaded,
          displayName: profile.name,
          email: profile.email,
          currentPhotoUrl: profile.avatarUrl,
          addressAr: clinic?.addressAr ?? '',
          addressEn: clinic?.addressEn ?? '',
          location: clinic?.location,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminProfileStatus.failure,
          error: AppException.from(e).code,
        ),
      );
    }
  }

  void setLocation(LatLng location) {
    emit(state.copyWith(location: location));
  }

  Future<bool> saveProfileAndClinic({
    required String displayName,
    required String email,
    required String addressAr,
    required String addressEn,
    required LatLng location,
    Uint8List? newImageBytes,
    String? newImageName,
  }) async {
    final uid = repository.currentUid;
    if (uid == null) {
      emit(
        state.copyWith(
          status: AdminProfileStatus.failure,
          error: AppErrorCode.userNotFound,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        status: AdminProfileStatus.saving,
        emailVerificationSent: false,
      ),
    );

    final String? photoUrl;
    try {
      photoUrl = newImageBytes == null
          ? state.currentPhotoUrl
          : await repository.uploadPhoto(
              bytes: newImageBytes,
              fileName: newImageName ?? 'admin_profile_$uid.jpg',
            );
      await repository.updateAdminProfileAndClinic(
        uid: uid,
        displayName: displayName.trim(),
        photoUrl: photoUrl,
        addressAr: addressAr.trim(),
        addressEn: addressEn.trim(),
        location: location,
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminProfileStatus.failure,
          error: AppException.from(e).code,
        ),
      );
      return false;
    }

    // The email change is separate: if it fails (often requires-recent-login)
    // the profile and clinic location above are already saved.
    final emailChanged =
        email.trim().toLowerCase() != state.email.trim().toLowerCase();
    AppErrorCode? emailError;
    if (emailChanged) {
      try {
        await repository.requestEmailChange(email.trim());
      } catch (e) {
        emailError = AppException.from(e).code;
      }
    }

    emit(
      state.copyWith(
        status: AdminProfileStatus.success,
        displayName: displayName.trim(),
        currentPhotoUrl: photoUrl,
        addressAr: addressAr.trim(),
        addressEn: addressEn.trim(),
        location: location,
        emailVerificationSent: emailChanged && emailError == null,
        error: emailError,
      ),
    );
    return true;
  }
}
