class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.role = 'patient',
    this.photoUrl,
  });

  final String id;
  final String email;
  final String displayName;
  final String role;
  final String? photoUrl;

  bool get isAdmin => role == 'admin';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          displayName == other.displayName &&
          role == other.role &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      role.hashCode ^
      (photoUrl?.hashCode ?? 0);

  @override
  String toString() =>
      'UserEntity(id: $id, email: $email, displayName: $displayName, role: $role)';
}
