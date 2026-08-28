import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/utils/phone_utils.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';

void main() {
  group('PhoneUtils.normalizePhoneNumber', () {
    test('normalizes 11-digit local Egyptian number starting with 01', () {
      expect(PhoneUtils.normalizePhoneNumber('01012345678'), '+201012345678');
      expect(PhoneUtils.normalizePhoneNumber('01112345678'), '+201112345678');
      expect(PhoneUtils.normalizePhoneNumber('01212345678'), '+201212345678');
      expect(PhoneUtils.normalizePhoneNumber('01512345678'), '+201512345678');
    });

    test('normalizes 10-digit Egyptian number without leading 0', () {
      expect(PhoneUtils.normalizePhoneNumber('1012345678'), '+201012345678');
      expect(PhoneUtils.normalizePhoneNumber('1112345678'), '+201112345678');
    });

    test('normalizes phone number with spaces and dashes', () {
      expect(PhoneUtils.normalizePhoneNumber('010 1234 5678'), '+201012345678');
      expect(PhoneUtils.normalizePhoneNumber('010-1234-5678'), '+201012345678');
      expect(
        PhoneUtils.normalizePhoneNumber('+20 10 1234 5678'),
        '+201012345678',
      );
    });

    test('handles 00 prefix properly', () {
      expect(
        PhoneUtils.normalizePhoneNumber('00201012345678'),
        '+201012345678',
      );
    });

    test('preserves existing international prefix with +', () {
      expect(PhoneUtils.normalizePhoneNumber('+201012345678'), '+201012345678');
      expect(PhoneUtils.normalizePhoneNumber('+966501234567'), '+966501234567');
    });

    test('converts Eastern Arabic digits to Western digits', () {
      expect(PhoneUtils.normalizePhoneNumber('٠١٠١٢٣٤٥٦٧٨'), '+201012345678');
    });
  });

  group('PhoneUtils.formatForDisplay', () {
    test('formats Egyptian phone number with spaces', () {
      expect(PhoneUtils.formatForDisplay('01012345678'), '+20 10 1234 5678');
      expect(PhoneUtils.formatForDisplay('+201012345678'), '+20 10 1234 5678');
    });
  });

  group('PhoneUtils.isValidPhone & AppValidators.validatePhone', () {
    test('validates valid Egyptian numbers in different formats', () {
      expect(PhoneUtils.isValidPhone('01012345678'), isTrue);
      expect(PhoneUtils.isValidPhone('01112345678'), isTrue);
      expect(PhoneUtils.isValidPhone('01212345678'), isTrue);
      expect(PhoneUtils.isValidPhone('01512345678'), isTrue);
      expect(PhoneUtils.isValidPhone('1012345678'), isTrue);
      expect(PhoneUtils.isValidPhone('+201012345678'), isTrue);
      expect(PhoneUtils.isValidPhone('010 1234 5678'), isTrue);

      expect(AppValidators.validatePhone('01012345678'), isNull);
      expect(AppValidators.validatePhone('1012345678'), isNull);
      expect(AppValidators.validatePhone('+201012345678'), isNull);
    });

    test('invalidates incorrect numbers', () {
      expect(PhoneUtils.isValidPhone('12345'), isFalse);
      expect(
        PhoneUtils.isValidPhone('01812345678'),
        isFalse,
      ); // Invalid carrier prefix
      expect(PhoneUtils.isValidPhone(''), isFalse);

      expect(AppValidators.validatePhone(''), isNotNull);
      expect(AppValidators.validatePhone('12345'), isNotNull);
    });
  });
}
