import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/edit_profile_cubit.dart';

import '../../../helpers/test_fakes.dart';

void main() {
  EditProfileCubit buildCubit(FakeProfileRepository repo) => EditProfileCubit(
    repository: repo,
    authRepository: FakeAuthRepository(currentUser: FakeUser(uid: 'u1')),
  );

  test('save emits saving then success and writes the profile', () async {
    final repo = FakeProfileRepository();
    final cubit = buildCubit(repo);

    expectLater(
      cubit.stream,
      emitsInOrder([isA<EditProfileSaving>(), isA<EditProfileSuccess>()]),
    );
    await cubit.save(name: 'Jane', phone: '+201012345678');

    expect(repo.lastUpdatedUid, 'u1');
    expect(repo.lastUpdatedGender, isNull);
    await cubit.close();
  });

  test('save emits failure with the error message', () async {
    final cubit = buildCubit(
      FakeProfileRepository(saveError: const AppException(message: 'boom')),
    );

    await cubit.save(name: 'Jane', phone: '+201012345678');

    expect(
      cubit.state,
      isA<EditProfileFailure>().having((s) => s.message, 'message', 'boom'),
    );
    await cubit.close();
  });
}
