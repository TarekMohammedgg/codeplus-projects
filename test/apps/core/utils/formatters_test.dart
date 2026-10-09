import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en', null);
  });

  group('formatters', () {
    test('formatFee formats num as currency with two decimal digits', () {
      // arrange
      const fee = 28;

      // act
      final formatted = formatFee(fee);

      // assert
      expect(formatted, '\$28.00');
    });

    test('formatFeeAmount formats num as decimal with two decimal digits', () {
      // arrange
      const fee = 28;

      // act
      final formatted = formatFeeAmount(fee);

      // assert
      expect(formatted, '28.00');
    });

    test('feeCurrencySymbol returns dollar symbol', () {
      // arrange & act
      final symbol = feeCurrencySymbol;

      // assert
      expect(symbol, '\$');
    });

    test('formatDate formats DateTime as dd MMM yyyy with given locale', () {
      // arrange
      final date = DateTime(2026, 10, 7, 9, 30);

      // act
      final formatted = formatDate(date, 'en');

      // assert
      expect(formatted, '07 Oct 2026');
    });

    test('formatTime formats DateTime as hh:mm a with given locale', () {
      // arrange
      final time = DateTime(2026, 10, 7, 9, 0);

      // act
      final formatted = formatTime(time, 'en');

      // assert
      expect(formatted, '09:00 AM');
    });
  });
}
