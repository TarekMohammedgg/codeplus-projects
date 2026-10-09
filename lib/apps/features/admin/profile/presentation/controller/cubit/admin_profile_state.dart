import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

enum AdminProfileStatus { initial, loading, loaded, saving, success, failure }

enum AdminProfileFailure { requiresRecentLogin, unknown }

@immutable
class AdminProfileState {
  const AdminProfileState({
    this.status = AdminProfileStatus.initial,
    this.displayName = '',
    this.email = '',
    this.currentPhotoUrl,
    this.addressAr = '',
    this.addressEn = '',
    this.location,
    this.errorMessage,
    this.emailVerificationSent = false,
    this.failure,
  });

  final AdminProfileStatus status;
  final String displayName;
  final String email;
  final String? currentPhotoUrl;
  final String addressAr;
  final String addressEn;
  final LatLng? location;
  final String? errorMessage;
  final bool emailVerificationSent;
  final AdminProfileFailure? failure;

  AdminProfileState copyWith({
    AdminProfileStatus? status,
    String? displayName,
    String? email,
    String? currentPhotoUrl,
    String? addressAr,
    String? addressEn,
    LatLng? location,
    String? errorMessage,
    bool? emailVerificationSent,
    AdminProfileFailure? failure,
  }) {
    return AdminProfileState(
      status: status ?? this.status,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      currentPhotoUrl: currentPhotoUrl ?? this.currentPhotoUrl,
      addressAr: addressAr ?? this.addressAr,
      addressEn: addressEn ?? this.addressEn,
      location: location ?? this.location,
      errorMessage: errorMessage,
      emailVerificationSent:
          emailVerificationSent ?? this.emailVerificationSent,
      failure: failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminProfileState &&
          other.status == status &&
          other.displayName == displayName &&
          other.email == email &&
          other.currentPhotoUrl == currentPhotoUrl &&
          other.addressAr == addressAr &&
          other.addressEn == addressEn &&
          other.location == location &&
          other.errorMessage == errorMessage &&
          other.emailVerificationSent == emailVerificationSent &&
          other.failure == failure;

  @override
  int get hashCode => Object.hash(
    status,
    displayName,
    email,
    currentPhotoUrl,
    addressAr,
    addressEn,
    location,
    errorMessage,
    emailVerificationSent,
    failure,
  );
}
