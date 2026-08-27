import 'package:doctor_hunt/apps/features/doctor_select_time/data/models/time_slot_model.dart';

List<DateOptionItem> availableDateOptions() {
  return [
    // Today, 23 Feb - 0 slots
    DateOptionItem(
      id: 'date_1',
      date: DateTime(2021, 2, 23),
      dayLabel: 'Today, 23 Feb',
      afternoonSlots: [],
      eveningSlots: [],
    ),
    // Tomorrow, 24 Feb - 9 slots
    DateOptionItem(
      id: 'date_2',
      date: DateTime(2021, 2, 24),
      dayLabel: 'Tomorrow, 24 Feb',
      afternoonSlots: [
        TimeSlotItem(id: 'd2_slot_1', time: '1:00 PM'),
        TimeSlotItem(id: 'd2_slot_2', time: '1:30 PM'),
        TimeSlotItem(id: 'd2_slot_3', time: '2:00 PM'),
        TimeSlotItem(id: 'd2_slot_4', time: '2:30 PM'),
        TimeSlotItem(id: 'd2_slot_5', time: '3:00 PM'),
        TimeSlotItem(id: 'd2_slot_6', time: '3:30 PM'),
        TimeSlotItem(id: 'd2_slot_7', time: '4:00 PM'),
      ],
      eveningSlots: [
        TimeSlotItem(id: 'd2_slot_8', time: '5:00 PM'),
        TimeSlotItem(id: 'd2_slot_9', time: '5:30 PM'),
      ],
    ),
    // Thursday, 25 Feb - 10 slots
    DateOptionItem(
      id: 'date_3',
      date: DateTime(2021, 2, 25),
      dayLabel: 'Thursday, 25 Feb',
      afternoonSlots: [
        TimeSlotItem(id: 'd3_slot_1', time: '1:00 PM'),
        TimeSlotItem(id: 'd3_slot_2', time: '1:30 PM'),
        TimeSlotItem(id: 'd3_slot_3', time: '2:00 PM'),
        TimeSlotItem(id: 'd3_slot_4', time: '2:30 PM'),
        TimeSlotItem(id: 'd3_slot_5', time: '3:00 PM'),
      ],
      eveningSlots: [
        TimeSlotItem(id: 'd3_slot_6', time: '5:00 PM'),
        TimeSlotItem(id: 'd3_slot_7', time: '5:30 PM'),
        TimeSlotItem(id: 'd3_slot_8', time: '6:00 PM'),
        TimeSlotItem(id: 'd3_slot_9', time: '6:30 PM'),
        TimeSlotItem(id: 'd3_slot_10', time: '7:00 PM'),
      ],
    ),
  ];
}
