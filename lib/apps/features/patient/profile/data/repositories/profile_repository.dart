import 'dart:typed_data';

import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/service/profile_service.dart';

abstract interface class ProfileRepository {
  Stream<UserProfileModel> streamProfile(String uid);
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? phone,
    DateTime? dob,
    String? gender,
    String? photoUrl,
    String? language,
    bool? notificationsEnabled,
  });

  Future<void> saveProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? currentPhotoUrl,
    Uint8List? newImageBytes,
    String? newImageName,
  });
}

class FirebaseProfileRepository implements ProfileRepository {
  FirebaseProfileRepository({
    required this.profileService,
    required this.uploadService,
    required this.authService,
  });

  final ProfileService profileService;
  final CloudinaryUploadService uploadService;
  final AuthService authService;

  @override
  Stream<UserProfileModel> streamProfile(String uid) {
    return profileService.streamProfile(uid);
  }

  @override
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? phone,
    DateTime? dob,
    String? gender,
    String? photoUrl,
    String? language,
    bool? notificationsEnabled,
  }) {
    return profileService.updateProfile(
      uid: uid,
      displayName: displayName,
      phone: phone,
      dob: dob,
      gender: gender,
      photoUrl: photoUrl,
      language: language,
      notificationsEnabled: notificationsEnabled,
    );
  }

  @override
  Future<void> saveProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? currentPhotoUrl,
    Uint8List? newImageBytes,
    String? newImageName,
  }) async {
    var photoUrl = currentPhotoUrl;
    if (newImageBytes != null) {
      photoUrl = await uploadService.uploadImage(
        bytes: newImageBytes,
        fileName: newImageName ?? 'profile_$uid.jpg',
      );
    }

    await profileService.updateProfile(
      uid: uid,
      displayName: name,
      phone: phone,
      dob: dob,
      gender: gender,
      photoUrl: photoUrl,
    );
    await authService.updateDisplayNameAndPhoto(name, photoUrl);
  }
}
