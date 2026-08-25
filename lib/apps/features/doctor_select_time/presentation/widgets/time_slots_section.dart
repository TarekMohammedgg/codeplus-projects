import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/data/models/time_slot_model.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.bold16TextMain),
        12.verticalSpace,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: slots
              .map(
                (slot) => _SlotChip(
                  slot: slot,
                  isSelected: slot.id == selectedSlotId,
                  onTap: onSelectSlot != null
                      ? () => onSelectSlot!(slot.id)
                      : null,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ── Private widget ────────────────────────────────────────────────────────────

class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.slot, required this.isSelected, this.onTap});

  final TimeSlotItem slot;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(6);

    return Material(
      color: isSelected
          ? AppColors.primary
          : AppColors.primary.withValues(alpha: 0.08),
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            slot.time,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
