import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';

void main() {
  test('maps a FirebaseAuthException code to its AppErrorCode', () {
    // act
    final result = AppException.from(
      FirebaseAuthException(code: 'requires-recent-login'),
    );

    // assert
    expect(result.code, AppErrorCode.requiresRecentLogin);
  });

  test('maps any FirebaseException to a service error, not its raw text', () {
    // act
    final result = AppException.from(
      FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
    );

    // assert
    expect(result.code, AppErrorCode.service);
  });

  test('keeps an AppException and maps unknown errors to unexpected', () {
    // arrange
    const original = AppException(AppErrorCode.alreadyReviewed);

    // act
    final kept = AppException.from(original);
    final unknown = AppException.from(StateError('boom'));

    // assert
    expect(kept, same(original));
    expect(unknown.code, AppErrorCode.unexpected);
  });
}
