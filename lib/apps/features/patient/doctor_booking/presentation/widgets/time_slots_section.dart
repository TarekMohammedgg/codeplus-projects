import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class TimeSlotsSection extends StatelessWidget {
  const TimeSlotsSection({
    super.key,
    required this.title,
    required this.slots,
    this.selectedSlot,
    this.onSelectSlot,
  });

  final String title;
  final List<DateTime> slots;
  final DateTime? selectedSlot;
  final ValueChanged<DateTime>? onSelectSlot;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();

    final locale = context.localeCode;
    final borderRadius = BorderRadius.circular(6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.medium16TextMain),
        16.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 76 / 40,
          ),
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isSelected = slot == selectedSlot;
            final formattedTime = DateFormat.jm(locale).format(slot);

            return Material(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.08),
              borderRadius: borderRadius,
              child: InkWell(
                onTap: () => onSelectSlot?.call(slot),
                borderRadius: borderRadius,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        formattedTime,
                        style: isSelected
                            ? context.medium13White
                            : context.medium13Primary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
