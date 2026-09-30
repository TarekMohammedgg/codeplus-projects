import 'package:intl/intl.dart';

/// Weekly working hours of a doctor, stored as `doctors/{id}.availability`.
///
/// Times are minutes from midnight (540 = 09:00) so slot math stays integer.
class DoctorAvailability {
  const DoctorAvailability({
    required this.workingDays,
    required this.startMinutes,
    required this.endMinutes,
    required this.slotMinutes,
  });

  /// `DateTime.weekday` values: 1 = Monday … 7 = Sunday.
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

  /// Returns null when [raw] is missing or does not describe a usable
  /// schedule, so the UI can show "no availability" instead of bad slots.
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

  String formatSummary({String? locale}) {
    if (workingDays.isEmpty) return 'Not set';
    final sortedDays = List<int>.from(workingDays)..sort();
    const enDays = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    const arDays = {
      1: 'الإثنين',
      2: 'الثلاثاء',
      3: 'الأربعاء',
      4: 'الخميس',
      5: 'الجمعة',
      6: 'السبت',
      7: 'الأحد',
    };

    final dayNames = sortedDays
        .map((w) {
          try {
            final sample = DateTime(2026, 9, 27 + w);
            return DateFormat.E(locale).format(sample);
          } catch (_) {
            if (locale?.startsWith('ar') ?? false) {
              return arDays[w] ?? '';
            }
            return enDays[w] ?? '';
          }
        })
        .join(', ');

    final startH = (startMinutes ~/ 60).toString().padLeft(2, '0');
    final startM = (startMinutes % 60).toString().padLeft(2, '0');
    final endH = (endMinutes ~/ 60).toString().padLeft(2, '0');
    final endM = (endMinutes % 60).toString().padLeft(2, '0');

    return '$dayNames · $startH:$startM–$endH:$endM · $slotMinutes min';
  }
}
