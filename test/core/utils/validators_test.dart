import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.en));

  group('validateFee', () {
    test('accepts a positive fee', () {
      final result = AppValidators.validateFee(' 30.5 ');

      expect(result, isNull);
    });

    test('rejects empty, zero, negative and non-numeric values', () {
      final results = [
        '',
        '0',
        '-5',
        'abc',
        null,
      ].map(AppValidators.validateFee);

      expect(results, everyElement(tr.enterValidFee));
    });
  });
}
