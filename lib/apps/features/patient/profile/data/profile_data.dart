import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';

UserProfileModel defaultUserProfile() {
  final user = getIt.isRegistered<AuthService>()
      ? getIt<AuthService>().currentUser
      : (getIt.isRegistered<FirebaseAuth>()
            ? getIt<FirebaseAuth>().currentUser
            : null);
  final displayName = user?.displayName?.trim();
  final phone = user?.phoneNumber?.trim();
  final photoUrl = user?.photoURL?.trim();

  return UserProfileModel(
    name: displayName ?? '',
    contactNumber: phone ?? '',
    dateOfBirth: '',
    location: '',
    avatarUrl: (photoUrl != null && photoUrl.isNotEmpty) ? photoUrl : null,
  );
}
