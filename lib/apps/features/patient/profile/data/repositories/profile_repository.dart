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
}

class FirebaseProfileRepository implements ProfileRepository {
  FirebaseProfileRepository({required this.profileService});

  final ProfileService profileService;

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
}
