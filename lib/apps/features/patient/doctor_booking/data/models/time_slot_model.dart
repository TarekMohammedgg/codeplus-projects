class TimeSlotItem {
  final String id;
  final String time;
  final bool isAvailable;

  const TimeSlotItem({
    required this.id,
    required this.time,
    this.isAvailable = true,
  });
}

class DateOptionItem {
  final String id;
  final DateTime date;
  final String dayLabel;
  final List<TimeSlotItem> afternoonSlots;
  final List<TimeSlotItem> eveningSlots;

  const DateOptionItem({
    required this.id,
    required this.date,
    required this.dayLabel,
    this.afternoonSlots = const [],
    this.eveningSlots = const [],
  });

  List<TimeSlotItem> get allSlots => [...afternoonSlots, ...eveningSlots];

  int get slotsCount => allSlots.where((s) => s.isAvailable).length;

  bool get hasSlots => slotsCount > 0;
}
