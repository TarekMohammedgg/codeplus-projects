import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';

enum AdminProfileStatus { initial, loading, loaded, saving, success, failure }

class AdminProfileState {
  const AdminProfileState({
    this.status = AdminProfileStatus.initial,
    this.displayName = '',
    this.email = '',
    this.currentPhotoUrl,
    this.addressAr = '',
    this.addressEn = '',
    this.location,
    this.emailVerificationSent = false,
    this.error,
  });

  final AdminProfileStatus status;
  final String displayName;
  final String email;
  final String? currentPhotoUrl;
  final String addressAr;
  final String addressEn;
  final LatLng? location;
  final bool emailVerificationSent;

  /// Failure of the whole save, or (with `success`) of the email change only.
  final AppErrorCode? error;

  AdminProfileState copyWith({
    AdminProfileStatus? status,
    String? displayName,
    String? email,
    String? currentPhotoUrl,
    String? addressAr,
    String? addressEn,
    LatLng? location,
    bool? emailVerificationSent,
    AppErrorCode? error,
  }) {
    return AdminProfileState(
      status: status ?? this.status,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      currentPhotoUrl: currentPhotoUrl ?? this.currentPhotoUrl,
      addressAr: addressAr ?? this.addressAr,
      addressEn: addressEn ?? this.addressEn,
      location: location ?? this.location,
      emailVerificationSent:
          emailVerificationSent ?? this.emailVerificationSent,
      error: error,
    );
  }
}
