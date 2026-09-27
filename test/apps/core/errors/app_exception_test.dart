import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocaleSync(AppLocale.en));

  group('AppException.from', () {
    test('returns the same AppException unchanged', () {
      // arrange
      const error = AppException(message: 'already mapped', code: 'x');

      // act
      final result = AppException.from(error);

      // assert
      expect(result, same(error));
    });

    test('maps FirebaseAuthException codes to localized messages', () {
      // arrange
      final expected = {
        'user-not-found': tr.userNotFoundError,
        'wrong-password': tr.wrongPasswordError,
        'invalid-credential': tr.wrongPasswordError,
        'email-already-in-use': tr.emailAlreadyInUseError,
        'weak-password': tr.weakPasswordError,
        'network-request-failed': tr.networkRequestFailedError,
      };

      // act
      final results = {
        for (final code in expected.keys)
          code: AppException.from(FirebaseAuthException(code: code)),
      };

      // assert
      expected.forEach((code, message) {
        expect(results[code]!.message, message, reason: code);
        expect(results[code]!.code, code);
      });
    });

    test('maps unknown errors to the unexpected error message', () {
      // act
      final result = AppException.from(Exception('boom'));

      // assert
      expect(result.message, tr.unexpectedError);
    });
  });
}
