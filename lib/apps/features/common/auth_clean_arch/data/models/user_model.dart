import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.role = 'patient',
    super.photoUrl,
  });

  factory UserModel.fromFirebaseUser(fb.User user, {String role = 'patient'}) {
    return UserModel(
      id: user.uid,
      email: user.email?.trim() ?? '',
      displayName: user.displayName?.trim() ?? '',
      role: role,
      photoUrl: user.photoURL,
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      email: (json['email'] as String?)?.trim() ?? '',
      displayName: (json['displayName'] as String?)?.trim() ?? '',
      role: (json['role'] as String?)?.trim() ?? 'patient',
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? role,
    String? photoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
