import 'package:intl/intl.dart';

class DoctorAvailability {
  const DoctorAvailability({
    required this.workingDays,
    required this.startMinutes,
    required this.endMinutes,
    required this.slotMinutes,
  });

  final List<int> workingDays;
  final int startMinutes;
  final int endMinutes;
  final int slotMinutes;

  factory DoctorAvailability.fromMap(Map<String, dynamic> map) {
    return DoctorAvailability(
      workingDays: (map['workingDays'] as List)
          .map((day) => (day as num).toInt())
          .toList(),
      startMinutes: (map['startMinutes'] as num).toInt(),
      endMinutes: (map['endMinutes'] as num).toInt(),
      slotMinutes: (map['slotMinutes'] as num).toInt(),
    );
  }

  static DoctorAvailability? tryParse(dynamic raw) {
    if (raw is! Map) return null;
    final days = raw['workingDays'];
    final hasValidTypes =
        days is List &&
        days.every((day) => day is num) &&
        raw['startMinutes'] is num &&
        raw['endMinutes'] is num &&
        raw['slotMinutes'] is num;
    if (!hasValidTypes) return null;

    final availability = DoctorAvailability.fromMap(
      Map<String, dynamic>.from(raw),
    );
    final isValid =
        availability.workingDays.isNotEmpty &&
        availability.workingDays.every((day) => day >= 1 && day <= 7) &&
        availability.slotMinutes > 0 &&
        availability.startMinutes < availability.endMinutes;
    return isValid ? availability : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'workingDays': workingDays,
      'startMinutes': startMinutes,
      'endMinutes': endMinutes,
      'slotMinutes': slotMinutes,
    };
  }

  static String weekdayName(int weekday, String locale, {bool short = true}) {
    final date = DateTime(2026, 9, 27 + weekday);
    return (short ? DateFormat.E(locale) : DateFormat.EEEE(locale)).format(
      date,
    );
  }

  String formatSummary({String? locale}) {
    final code = locale ?? 'en';
    final dayNames = ([
      ...workingDays,
    ]..sort()).map((day) => weekdayName(day, code)).join(', ');
    String time(int minutes) =>
        DateFormat.Hm(code).format(DateTime(2000, 1, 1, 0, minutes));

    return '$dayNames · ${time(startMinutes)}–${time(endMinutes)} · '
        '$slotMinutes min';
  }
}
