import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female }

class UserProfileModel {
  const UserProfileModel({
    this.uid = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.dob,
    this.gender,
    this.avatarUrl,
    this.language = 'en',
    this.notificationsEnabled = true,
  });

  final String uid;
  final String name;
  final String email;
  final String phone;
  final DateTime? dob;
  final Gender? gender;
  final String? avatarUrl;
  final String language;
  final bool notificationsEnabled;

  factory UserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return UserProfileModel.fromMap(doc.id, data);
  }

  factory UserProfileModel.fromMap(String uid, Map<String, dynamic> data) {
    DateTime? parseDob(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    final photoUrl = (data['photoUrl'] as String?)?.trim();
    return UserProfileModel(
      uid: uid,
      name: (data['displayName'] as String? ?? '').trim(),
      email: (data['email'] as String? ?? '').trim(),
      phone: (data['phone'] as String? ?? '').trim(),
      dob: parseDob(data['dob']),
      gender: Gender.values
          .asNameMap()[(data['gender'] as String?)?.trim().toLowerCase()],
      avatarUrl: (photoUrl != null && photoUrl.isNotEmpty) ? photoUrl : null,
      language: data['language'] as String? ?? 'en',
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': name,
      'email': email,
      'phone': phone,
      if (dob != null) 'dob': Timestamp.fromDate(dob!),
      if (gender != null) 'gender': gender?.name,
      if (avatarUrl != null) 'photoUrl': avatarUrl,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    DateTime? dob,
    Gender? gender,
    String? avatarUrl,
    String? language,
    bool? notificationsEnabled,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
