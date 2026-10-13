import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repository, required this.authRepository})
    : super(const ProfileInitial());

  final ProfileRepository repository;
  final AuthRepository authRepository;

  StreamSubscription<UserProfileModel>? _subscription;

  void init({String? uid}) {
    final targetUid = uid ?? currentUser?.uid;
    if (targetUid == null) {
      emit(ProfileError(tr.userNotFoundError));
      return;
    }

    emit(const ProfileLoading());
    _subscription?.cancel();
    _subscription = repository
        .streamProfile(targetUid)
        .listen(
          (profile) => emit(
            ProfileLoaded(
              profile.avatarUrl == null
                  ? profile.copyWith(avatarUrl: currentUser?.photoURL)
                  : profile,
            ),
          ),
          onError: (Object error) =>
              emit(ProfileError(AppException.from(error).message)),
        );
  }

  User? get currentUser => authRepository.currentUser;

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
