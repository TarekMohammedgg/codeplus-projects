import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repository, required this.authRepository})
    : super(const ProfileInitial());

  final ProfileRepository repository;
  final AuthRepository authRepository;

  StreamSubscription<UserProfileModel>? _subscription;

  void init({String? uid, UserProfileModel? initialProfile}) {
    if (initialProfile != null) {
      emit(ProfileLoaded(initialProfile));
      return;
    }

    final targetUid = uid ?? authRepository.currentUser?.uid;
    if (targetUid == null || targetUid.isEmpty) {
      emit(const ProfileError('User not logged in'));
      return;
    }

    emit(const ProfileLoading());
    _subscription?.cancel();
    _subscription = repository
        .streamProfile(targetUid)
        .listen(
          (profile) {
            emit(ProfileLoaded(profile));
          },
          onError: (error) {
            emit(ProfileError(error.toString()));
          },
        );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
