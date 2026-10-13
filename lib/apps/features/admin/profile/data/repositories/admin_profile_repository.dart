import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/service/profile_service.dart';

abstract class AdminProfileRepository {
  String? get currentUid;
  Future<UserProfileModel> fetchAdminProfile(String uid);
  Future<ClinicModel?> fetchClinic();
  Future<String> uploadPhoto({
    required Uint8List bytes,
    required String fileName,
  });
  Future<void> updateAdminProfileAndClinic({
    required String uid,
    required String displayName,
    String? photoUrl,
    String? newEmail,
    required String addressAr,
    required String addressEn,
    required LatLng location,
  });
}

class AdminProfileRepositoryImpl implements AdminProfileRepository {
  const AdminProfileRepositoryImpl({
    required this.authService,
    required this.profileService,
    required this.clinicService,
    required this.uploadService,
  });

  final AuthService authService;
  final ProfileService profileService;
  final ClinicService clinicService;
  final CloudinaryUploadService uploadService;

  @override
  String? get currentUid => authService.currentUser?.uid;

  @override
  Future<UserProfileModel> fetchAdminProfile(String uid) =>
      profileService.fetchProfile(uid);

  @override
  Future<ClinicModel?> fetchClinic() => clinicService.fetchClinic();

  @override
  Future<String> uploadPhoto({
    required Uint8List bytes,
    required String fileName,
  }) => uploadService.uploadImage(bytes: bytes, fileName: fileName);

  @override
  Future<void> updateAdminProfileAndClinic({
    required String uid,
    required String displayName,
    String? photoUrl,
    String? newEmail,
    required String addressAr,
    required String addressEn,
    required LatLng location,
  }) async {
    if (newEmail != null) await authService.requestEmailChange(newEmail);
    await authService.updateDisplayNameAndPhoto(displayName, photoUrl);
    await profileService.updateProfile(
      uid: uid,
      displayName: displayName,
      photoUrl: photoUrl,
    );
    await clinicService.updateClinic(
      addressAr: addressAr,
      addressEn: addressEn,
      location: location,
    );
  }
}
