import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';

void main() {
  test('maps a FirebaseAuthException code to its AppErrorCode', () {
    final result = AppException.from(
      FirebaseAuthException(code: 'requires-recent-login'),
    );

    expect(result.code, AppErrorCode.requiresRecentLogin);
  });

  test('maps any FirebaseException to a service error, not its raw text', () {
    final result = AppException.from(
      FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
    );

    expect(result.code, AppErrorCode.service);
  });

  test('keeps an AppException and maps unknown errors to unexpected', () {
    const original = AppException(AppErrorCode.alreadyReviewed);

    final kept = AppException.from(original);
    final unknown = AppException.from(StateError('boom'));

    expect(kept, same(original));
    expect(unknown.code, AppErrorCode.unexpected);
  });
}
