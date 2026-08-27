import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/data/models/time_slot_model.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_slot/time_slot.dart';

class TimeSlotsSection extends StatelessWidget {
  const TimeSlotsSection({
    super.key,
    required this.title,
    required this.slots,
    this.selectedSlotId,
    this.onSelectSlot,
  });

  final String title;
  final List<TimeSlotItem> slots;
  final String? selectedSlotId;
  final ValueChanged<String>? onSelectSlot;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();

    final slotDates = slots.map(_toDateTime).toList();
    final selectedDates = slots
        .where((slot) => slot.id == selectedSlotId)
        .map(_toDateTime)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.bold16TextMain),
        12.verticalSpace,
        DefaultTextStyle(
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          child: TimesSlotGridViewFromList(
            key: ValueKey(slots.first.id),
            initTime: selectedDates,
            listDates: slotDates,
            crossAxisCount: 4,
            displayType: DisplayType.ungrouping,
            selectedColor: AppColors.primary,
            unSelectedColor: AppColors.primary.withValues(alpha: 0.08),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.4,
            borderRadius: BorderRadius.circular(6),
            onChange: (selectedDates) {
              if (selectedDates.isEmpty || onSelectSlot == null) return;

              final selectedDate = selectedDates.first;
              final selectedSlot = slots.firstWhere((slot) {
                final slotDate = _toDateTime(slot);
                return slotDate.hour == selectedDate.hour &&
                    slotDate.minute == selectedDate.minute;
              });
              onSelectSlot!(selectedSlot.id);
            },
          ),
        ),
      ],
    );
  }

  DateTime _toDateTime(TimeSlotItem slot) {
    return DateFormat('h:mm a', 'en').parse(slot.time);
  }
}
