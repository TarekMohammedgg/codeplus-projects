import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  final UserProfileModel profile;
}

class ProfileError extends ProfileState {
  const ProfileError(this.error);

  final AppErrorCode error;
}
