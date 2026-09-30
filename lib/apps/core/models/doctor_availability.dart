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
}
