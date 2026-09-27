import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocaleSync(AppLocale.en));

  group('validateEmail', () {
    test('returns required message for null, empty or blank input', () {
      // act
      final results = [null, '', '   '].map(AppValidators.validateEmail);

      // assert
      expect(results, everyElement(tr.enterEmailAddress));
    });

    test('returns invalid message when @ or . is missing', () {
      // act
      final results = [
        'user.com',
        'user@mail',
      ].map(AppValidators.validateEmail);

      // assert
      expect(results, everyElement(tr.enterValidEmailAddress));
    });

    test('accepts a valid email with surrounding spaces', () {
      // act
      final result = AppValidators.validateEmail('  user@mail.com  ');

      // assert
      expect(result, isNull);
    });
  });

  group('validatePassword', () {
    test('rejects passwords shorter than the minimum length', () {
      // act
      final results = [null, 'short'].map(AppValidators.validatePassword);

      // assert
      expect(results, everyElement(tr.useAtLeast8Characters));
    });

    test('accepts a password of the minimum length', () {
      // act
      final result = AppValidators.validatePassword('12345678');

      // assert
      expect(result, isNull);
    });
  });

  group('validateRequiredPassword', () {
    test('rejects null or empty', () {
      // act
      final results = [null, ''].map(AppValidators.validateRequiredPassword);

      // assert
      expect(results, everyElement(tr.enterPassword));
    });

    test('accepts any non-empty value', () {
      // act
      final result = AppValidators.validateRequiredPassword('x');

      // assert
      expect(result, isNull);
    });
  });

  group('validateName', () {
    test('rejects null or blank', () {
      // act
      final results = [null, '  '].map(AppValidators.validateName);

      // assert
      expect(results, everyElement(tr.enterFullName));
    });

    test('accepts a name', () {
      // act
      final result = AppValidators.validateName('Tarek');

      // assert
      expect(result, isNull);
    });
  });

  group('validatePhone', () {
    test('returns required message for empty input', () {
      // act
      final result = AppValidators.validatePhone('');

      // assert
      expect(result, tr.enterPhoneNumber);
    });

    test('returns invalid message for a malformed number', () {
      // act
      final result = AppValidators.validatePhone('abc');

      // assert
      expect(result, tr.enterValidPhoneNumber);
    });
  });
}
