import 'package:intl/intl.dart';

final _usd = NumberFormat.simpleCurrency(locale: 'en', name: 'USD');

String formatFee(num fee) => _usd.format(fee);

String get feeCurrencySymbol => _usd.currencySymbol;

String formatFeeAmount(num fee) => NumberFormat.decimalPatternDigits(
  locale: 'en',
  decimalDigits: 2,
).format(fee);

String formatDate(DateTime date, String locale) =>
    DateFormat('dd MMM yyyy', locale).format(date);

String formatTime(DateTime date, String locale) =>
    DateFormat('hh:mm a', locale).format(date);

String formatDayMonth(DateTime date, String locale) =>
    DateFormat('d MMM', locale).format(date);

String formatWeekdayDayMonth(DateTime date, String locale) =>
    DateFormat('E, d MMM', locale).format(date);

String formatRating(double rating) => rating.toStringAsFixed(1);
