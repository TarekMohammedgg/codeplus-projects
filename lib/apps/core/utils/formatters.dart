import 'package:intl/intl.dart';

final _usd = NumberFormat.simpleCurrency(locale: 'en', name: 'USD');

/// "$28.00"
String formatFee(num fee) => _usd.format(fee);

/// "$" (for UIs that style the symbol and the amount separately)
String get feeCurrencySymbol => _usd.currencySymbol;

/// "28.00"
String formatFeeAmount(num fee) => NumberFormat.decimalPatternDigits(
  locale: 'en',
  decimalDigits: 2,
).format(fee);

/// "07 Oct 2026" (the format used by the Figma appointment cards)
String formatDate(DateTime date, String locale) =>
    DateFormat('dd MMM yyyy', locale).format(date);

/// "09:00 AM"
String formatTime(DateTime date, String locale) =>
    DateFormat('hh:mm a', locale).format(date);
