import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// "Today, 7 Oct", "Tomorrow, 8 Oct", or "Fri, 9 Oct".
String formatBookingDayLabel(BuildContext context, DateTime date) {
  final now = DateTime.now();
  final locale = context.localeCode;
  final datePart = DateFormat('d MMM', locale).format(date);

  if (DateUtils.isSameDay(date, now)) {
    return '${context.tr.today}, $datePart';
  }
  if (DateUtils.isSameDay(date, now.add(const Duration(days: 1)))) {
    return '${context.tr.tomorrow}, $datePart';
  }
  return DateFormat('E, d MMM', locale).format(date);
}

class DateSelectorList extends StatelessWidget {
  const DateSelectorList({
    super.key,
    required this.selectedDate,
    required this.bookableDates,
    required this.slotsCount,
    required this.isLoadingSlots,
    this.slotsCountByDate = const {},
    this.onSelectDate,
  });

  final DateTime selectedDate;
  final List<DateTime> bookableDates;
  final int slotsCount;
  final bool isLoadingSlots;
  final Map<DateTime, int> slotsCountByDate;
  final ValueChanged<DateTime>? onSelectDate;

  int? _findSlotsCount(DateTime date) {
    for (final entry in slotsCountByDate.entries) {
      if (DateUtils.isSameDay(entry.key, date)) {
        return entry.value;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (bookableDates.isEmpty) return const SizedBox.shrink();

    final borderRadius = BorderRadius.circular(6);

    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: bookableDates.length,
        separatorBuilder: (_, _) => 16.horizontalSpace,
        itemBuilder: (context, index) {
          final date = bookableDates[index];
          final isSelected = DateUtils.isSameDay(date, selectedDate);
          final dayLabel = formatBookingDayLabel(context, date);

          final count = isSelected ? slotsCount : _findSlotsCount(date);

          final String subtitle;
          if (isSelected && isLoadingSlots && count == 0) {
            subtitle = context.tr.loadingEllipsis;
          } else if (count != null) {
            if (count > 0) {
              subtitle = context.tr.slotsAvailable(count: count);
            } else {
              subtitle = context.tr.noSlotsAvailable;
            }
          } else {
            subtitle = isLoadingSlots
                ? context.tr.loadingEllipsis
                : context.tr.noSlotsAvailable;
          }

          return Material(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: borderRadius,
            child: InkWell(
              onTap: () => onSelectDate?.call(date),
              borderRadius: borderRadius,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayLabel,
                      maxLines: 1,
                      style: isSelected
                          ? context.medium16White
                          : context.medium16TextMain,
                    ),
                    4.verticalSpace,
                    Text(
                      subtitle,
                      maxLines: 1,
                      style: isSelected
                          ? context.light10White
                          : context.light10TextSecondary,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
