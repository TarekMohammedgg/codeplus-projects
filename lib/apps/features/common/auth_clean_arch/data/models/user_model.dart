import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.role,
    super.photoUrl,
  });

  factory UserModel.fromFirebaseUser(
    fb.User user, {
    AuthRole role = AuthRole.patient,
  }) {
    return UserModel(
      id: user.uid,
      email: user.email?.trim() ?? '',
      displayName: user.displayName?.trim() ?? '',
      role: role,
      photoUrl: user.photoURL,
    );
  }
}
