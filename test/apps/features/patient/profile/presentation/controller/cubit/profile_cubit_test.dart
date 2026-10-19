import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_state.dart';
import '../../../../../../../helpers/test_fakes.dart';

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<void> saveProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? currentPhotoUrl,
    Uint8List? newImageBytes,
    String? newImageName,
  }) async {}

  _FakeProfileRepository({this.profile});

  final UserProfileModel? profile;

  @override
  Stream<UserProfileModel> streamProfile(String uid) {
    if (profile != null) {
      return Stream.value(profile!);
    }
    return const Stream.empty();
  }

  @override
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? phone,
    DateTime? dob,
    String? gender,
    String? photoUrl,
    String? language,
    bool? notificationsEnabled,
  }) async {}
}

void main() {
  const testProfile = UserProfileModel(
    uid: 'user-1',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '+123456789',
    gender: Gender.male,
  );

  group('ProfileCubit', () {
    test('streams profile for user from repository', () async {
      final repo = _FakeProfileRepository(profile: testProfile);
      final authRepo = FakeAuthRepository();
      final cubit = ProfileCubit(repository: repo, authRepository: authRepo);

      final states = expectLater(
        cubit.stream,
        emitsInOrder([isA<ProfileLoading>(), isA<ProfileLoaded>()]),
      );

      cubit.init(uid: 'user-1');
      await states;

      expect((cubit.state as ProfileLoaded).profile.email, 'john@example.com');
      await cubit.close();
    });

    test(
      'resolves avatarUrl from currentUser photoURL when profile has no avatar',
      () async {
        final repo = _FakeProfileRepository(profile: testProfile);
        final userWithPhoto = FakeUser(
          uid: 'user-1',
          photoURL: 'https://example.com/photo.png',
        );
        final authRepo = FakeAuthRepository(currentUser: userWithPhoto);
        final cubit = ProfileCubit(repository: repo, authRepository: authRepo);

        final states = expectLater(
          cubit.stream,
          emitsInOrder([isA<ProfileLoading>(), isA<ProfileLoaded>()]),
        );

        cubit.init(uid: 'user-1');
        await states;

        expect(
          (cubit.state as ProfileLoaded).profile.avatarUrl,
          'https://example.com/photo.png',
        );
        await cubit.close();
      },
    );

    test('emits ProfileError when no user is logged in', () async {
      final repo = _FakeProfileRepository();
      final authRepo = FakeAuthRepository();
      final cubit = ProfileCubit(repository: repo, authRepository: authRepo);

      cubit.init();

      expect(cubit.state, isA<ProfileError>());
      await cubit.close();
    });
  });
}
