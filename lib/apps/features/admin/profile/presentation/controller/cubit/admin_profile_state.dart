import 'package:latlong2/latlong.dart';

enum AdminProfileStatus { initial, loading, loaded, saving, success, failure }

enum AdminProfileFailure { requiresRecentLogin, unknown }

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
}
