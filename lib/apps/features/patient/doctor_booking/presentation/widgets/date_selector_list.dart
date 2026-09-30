import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DateSelectorList extends StatelessWidget {
  const DateSelectorList({
    super.key,
    required this.selectedDate,
    required this.bookableDates,
    required this.slotsCount,
    required this.isLoadingSlots,
    this.onSelectDate,
  });

  final DateTime selectedDate;
  final List<DateTime> bookableDates;
  final int slotsCount;
  final bool isLoadingSlots;
  final ValueChanged<DateTime>? onSelectDate;

  String _formatDayLabel(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(date, now);
    final isTomorrow = DateUtils.isSameDay(
      date,
      now.add(const Duration(days: 1)),
    );
    final locale = TranslationProvider.of(
      context,
    ).translations.$meta.locale.languageCode;
    final datePart = DateFormat('d MMM', locale).format(date);

    if (isToday) {
      return '${context.tr.today}, $datePart';
    }
    if (isTomorrow) {
      final tomorrowCap = context.tr.tomorrow.isNotEmpty
          ? '${context.tr.tomorrow[0].toUpperCase()}${context.tr.tomorrow.substring(1)}'
          : context.tr.tomorrow;
      return '$tomorrowCap, $datePart';
    }
    return DateFormat('E, d MMM', locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (bookableDates.isEmpty) return const SizedBox.shrink();

    final borderRadius = BorderRadius.circular(8);
    final locale = TranslationProvider.of(
      context,
    ).translations.$meta.locale.languageCode;

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: bookableDates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = bookableDates[index];
          final isSelected = DateUtils.isSameDay(date, selectedDate);
          final dayLabel = _formatDayLabel(context, date);

          final String subtitle;
          if (isSelected) {
            if (isLoadingSlots) {
              subtitle = '...';
            } else if (slotsCount > 0) {
              subtitle = context.tr.slotsAvailable(count: slotsCount);
            } else {
              subtitle = context.tr.noSlotsAvailable;
            }
          } else {
            subtitle = DateFormat('EEEE', locale).format(date);
          }

          return Material(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: borderRadius,
            child: InkWell(
              onTap: () => onSelectDate?.call(date),
              borderRadius: borderRadius,
              child: Container(
                width: 152,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.dateOutline,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bold14.copyWith(
                        color: isSelected ? Colors.white : AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.regular10.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.9)
                            : AppColors.textSecondary,
                      ),
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
