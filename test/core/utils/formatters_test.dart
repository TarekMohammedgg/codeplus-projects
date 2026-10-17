import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en', null);
  });

  group('formatters', () {
    test('formatFee formats num as currency with two decimal digits', () {
      const fee = 28;

      final formatted = formatFee(fee);

      expect(formatted, '\$28.00');
    });

    test('formatFeeAmount formats num as decimal with two decimal digits', () {
      const fee = 28;

      final formatted = formatFeeAmount(fee);

      expect(formatted, '28.00');
    });

    test('feeCurrencySymbol returns dollar symbol', () {
      final symbol = feeCurrencySymbol;

      expect(symbol, '\$');
    });

    test('formatDate formats DateTime as dd MMM yyyy with given locale', () {
      final date = DateTime(2026, 10, 7, 9, 30);

      final formatted = formatDate(date, 'en');

      expect(formatted, '07 Oct 2026');
    });

    test('formatTime formats DateTime as hh:mm a with given locale', () {
      final time = DateTime(2026, 10, 7, 9, 0);

      final formatted = formatTime(time, 'en');

      expect(formatted, '09:00 AM');
    });
  });
}
