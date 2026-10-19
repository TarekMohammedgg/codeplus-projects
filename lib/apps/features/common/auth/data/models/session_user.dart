/// The signed-in account as the app needs it, so presentation code does not
/// depend on the Firebase `User` type.
class SessionUser {
  const SessionUser({
    required this.uid,
    this.displayName = '',
    this.email = '',
    this.photoUrl,
  });

  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
}
