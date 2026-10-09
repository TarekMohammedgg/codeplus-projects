import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/service/profile_service.dart';

abstract class AdminProfileRepository {
  /// Uid of the signed-in admin, or null when signed out.
  String? get currentUid;
  Future<UserProfileModel?> fetchAdminProfile(String uid);
  Future<ClinicModel?> fetchClinic();
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
    required this.auth,
    required this.profileService,
    required this.clinicService,
  });

  final FirebaseAuth auth;
  final ProfileService profileService;
  final ClinicService clinicService;

  @override
  String? get currentUid => auth.currentUser?.uid;

  @override
  Future<UserProfileModel?> fetchAdminProfile(String uid) async {
    final snapshot = await profileService.firestore
        .collection('users')
        .doc(uid)
        .get();
    if (snapshot.exists && snapshot.data() != null) {
      return UserProfileModel.fromFirestore(snapshot);
    }
    final user = auth.currentUser;
    if (user != null) {
      return UserProfileModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        avatarUrl: user.photoURL,
      );
    }
    return null;
  }

  @override
  Future<ClinicModel?> fetchClinic() {
    return clinicService.fetchClinic();
  }

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
    final user = auth.currentUser;

    // 1. Email change
    if (user != null &&
        newEmail != null &&
        newEmail.trim().isNotEmpty &&
        newEmail.trim().toLowerCase() !=
            (user.email ?? '').trim().toLowerCase()) {
      await user.verifyBeforeUpdateEmail(newEmail.trim());
    }

    // 2. Update Auth display name & photo URL
    if (user != null) {
      await user.updateDisplayName(displayName.trim());
      if (photoUrl != null && photoUrl.isNotEmpty) {
        await user.updatePhotoURL(photoUrl);
      }
    }

    // 3. Update Firestore users/{uid}
    await profileService.updateProfile(
      uid: uid,
      displayName: displayName.trim(),
      photoUrl: photoUrl,
    );

    // 4. Update clinic/settings
    await clinicService.updateClinic(
      addressAr: addressAr.trim(),
      addressEn: addressEn.trim(),
      location: location,
    );
  }
}
