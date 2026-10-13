import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';

class ProfileService {
  ProfileService({required this.firestore});

  final FirebaseFirestore firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      firestore.collection('users').doc(uid);

  Stream<UserProfileModel> streamProfile(String uid) {
    return _userDoc(uid).snapshots().map(UserProfileModel.fromFirestore);
  }

  Future<UserProfileModel> fetchProfile(String uid) async {
    return UserProfileModel.fromFirestore(await _userDoc(uid).get());
  }

  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? phone,
    DateTime? dob,
    String? gender,
    String? photoUrl,
    String? language,
    bool? notificationsEnabled,
  }) async {
    final data = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
    if (displayName != null) data['displayName'] = displayName;
    if (phone != null) data['phone'] = phone;
    if (dob != null) data['dob'] = Timestamp.fromDate(dob);
    if (gender != null) data['gender'] = gender;
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    if (language != null) data['language'] = language;
    if (notificationsEnabled != null) {
      data['notificationsEnabled'] = notificationsEnabled;
    }

    await _userDoc(uid).set(data, SetOptions(merge: true));
  }
}
