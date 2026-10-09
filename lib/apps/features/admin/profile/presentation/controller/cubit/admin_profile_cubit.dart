import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/profile/data/repositories/admin_profile_repository.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_state.dart';

class AdminProfileCubit extends Cubit<AdminProfileState> {
  AdminProfileCubit({
    required this.repository,
    required this.uploadService,
    AdminProfileState? initialState,
  }) : super(initialState ?? const AdminProfileState());

  final AdminProfileRepository repository;
  final CloudinaryUploadService uploadService;

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
          displayName: profile?.name ?? '',
          email: profile?.email ?? '',
          currentPhotoUrl: profile?.avatarUrl,
          addressAr: clinic?.addressAr ?? '',
          addressEn: clinic?.addressEn ?? '',
          location: clinic?.location ?? const LatLng(30.0444, 31.2357),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminProfileStatus.failure,
          errorMessage: e.toString(),
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
          failure: AdminProfileFailure.unknown,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        status: AdminProfileStatus.saving,
        errorMessage: null,
        emailVerificationSent: false,
      ),
    );

    try {
      var photoUrl = state.currentPhotoUrl;
      if (newImageBytes != null) {
        photoUrl = await uploadService.uploadImage(
          bytes: newImageBytes,
          fileName: newImageName ?? 'admin_profile_$uid.jpg',
        );
      }

      final emailChanged =
          email.trim().toLowerCase() != state.email.trim().toLowerCase();

      await repository.updateAdminProfileAndClinic(
        uid: uid,
        displayName: displayName.trim(),
        photoUrl: photoUrl,
        newEmail: emailChanged ? email.trim() : null,
        addressAr: addressAr.trim(),
        addressEn: addressEn.trim(),
        location: location,
      );

      emit(
        state.copyWith(
          status: AdminProfileStatus.success,
          displayName: displayName.trim(),
          email: email.trim(),
          currentPhotoUrl: photoUrl,
          addressAr: addressAr.trim(),
          addressEn: addressEn.trim(),
          location: location,
          emailVerificationSent: emailChanged,
        ),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      final isRecentLogin = e.code == 'requires-recent-login';
      emit(
        state.copyWith(
          status: AdminProfileStatus.failure,
          errorMessage: isRecentLogin ? null : e.message,
          failure: isRecentLogin
              ? AdminProfileFailure.requiresRecentLogin
              : AdminProfileFailure.unknown,
        ),
      );
      return false;
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminProfileStatus.failure,
          errorMessage: e.toString(),
          failure: AdminProfileFailure.unknown,
        ),
      );
      return false;
    }
  }
}
