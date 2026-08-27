import 'package:doctor_hunt/apps/features/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/profile/data/models/user_profile_model.dart';

UserProfileModel defaultUserProfile() {
  final user = AuthService().currentUser;
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
