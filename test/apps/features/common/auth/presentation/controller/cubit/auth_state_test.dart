import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocaleSync(AppLocale.en));

  group('AuthFailure.errorMessage', () {
    test('returns the given message', () {
      // arrange
      const failure = AuthFailure.withMessage('custom');

      // act
      final message = failure.errorMessage;

      // assert
      expect(message, 'custom');
    });

    test('localizes the admin permission code', () {
      // arrange
      const failure = AuthFailure(code: AuthFailureCode.adminPermissionDenied);

      // act
      final message = failure.errorMessage;

      // assert
      expect(message, tr.adminPermissionDenied);
    });

    test('falls back to the unexpected error message without code', () {
      // arrange
      const failure = AuthFailure();

      // act
      final message = failure.errorMessage;

      // assert
      expect(message, tr.unexpectedError);
    });
  });
}
