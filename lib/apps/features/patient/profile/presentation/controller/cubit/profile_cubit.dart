import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repository, required this.authRepository})
    : super(const ProfileInitial());

  final ProfileRepository repository;
  final AuthRepository authRepository;

  StreamSubscription<UserProfileModel>? _subscription;

  void init({String? uid, UserProfileModel? initialProfile}) {
    final currentUser = authRepository.currentUser;
    final fallbackAvatar = currentUser?.photoURL?.trim();

    if (initialProfile != null) {
      final hasAvatar =
          initialProfile.avatarUrl != null &&
          initialProfile.avatarUrl!.isNotEmpty;
      final effectiveProfile =
          (!hasAvatar && fallbackAvatar != null && fallbackAvatar.isNotEmpty)
          ? initialProfile.copyWith(avatarUrl: fallbackAvatar)
          : initialProfile;
      emit(ProfileLoaded(effectiveProfile));
      return;
    }

    final targetUid = uid ?? currentUser?.uid;
    if (targetUid == null || targetUid.isEmpty) {
      emit(const ProfileError('User not logged in'));
      return;
    }

    emit(const ProfileLoading());
    _subscription?.cancel();
    _subscription = repository
        .streamProfile(targetUid)
        .listen(
          (profile) {
            final authUser = authRepository.currentUser;
            final authPhoto = authUser?.photoURL?.trim();
            final hasDocPhoto =
                profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty;
            final resolvedAvatar = hasDocPhoto ? profile.avatarUrl : authPhoto;

            final effectiveProfile =
                (!hasDocPhoto &&
                    resolvedAvatar != null &&
                    resolvedAvatar.isNotEmpty)
                ? profile.copyWith(avatarUrl: resolvedAvatar)
                : profile;

            // If Firestore doesn't have photoUrl yet but Auth does, sync to Firestore
            if (!hasDocPhoto && authPhoto != null && authPhoto.isNotEmpty) {
              unawaited(
                repository.updateProfile(uid: targetUid, photoUrl: authPhoto),
              );
            }

            emit(ProfileLoaded(effectiveProfile));
          },
          onError: (error) {
            emit(ProfileError(error.toString()));
          },
        );
  }

  /// Signed-in user, used as a fallback for empty profile fields.
  User? get currentUser => authRepository.currentUser;

  /// Throws on failure so the screen can show the error.
  Future<void> saveProfile({
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? currentPhotoUrl,
    Uint8List? newImageBytes,
    String? newImageName,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
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
  }

  Future<void> setNotifications(bool enabled) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await repository.updateProfile(uid: uid, notificationsEnabled: enabled);
  }

  Future<void> setLanguage(String languageCode) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await repository.updateProfile(uid: uid, language: languageCode);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
