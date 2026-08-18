// import 'package:hrzz/generated/translations.g.dart';
// import 'package:intl/intl.dart' show DateFormat;

// extension DateTimeFormat on DateTime {
//   DateTime adjustForCountryTimeZone(DateTime dateTime) {
//     // Get the time zone offset for the specified country
//     final Duration timeZoneOffset = DateTime.now().timeZoneOffset;

//     // Adjust the date time by the time zone offset
//     return dateTime.add(timeZoneOffset);
//   }

//   String get formattedDate =>
//       DateFormat('dd / MM / yyyy', LocaleSettings.currentLocale.name)
//           .format(adjustForCountryTimeZone(this));

//   String get formattedTime =>
//       DateFormat('hh : mm a', LocaleSettings.currentLocale.name)
//           .format(adjustForCountryTimeZone(this));

//   bool get isToday {
//     final now = DateTime.now();
//     return isAtSameMomentAs(now);
//   }

//   bool get isYesterday {
//     final yesterday = DateTime.now().subtract(const Duration(days: 1));
//     return isAtSameMomentAs(yesterday);
//   }

//   bool get isOlder {
//     return !isToday && !isYesterday;
//   }

//   String get groupingLabel {
//     if (isToday) {
//       return tr.today;
//     } else if (isYesterday) {
//       return tr.yesterday;
//     } else {
//       return formattedDate;
//     }
//   }
// }
