import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/time_slot_model.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DateSelectorList extends StatelessWidget {
  const DateSelectorList({
    super.key,
    required this.selectedOptionId,
    required this.dateOptions,
    this.onSelectOption,
  });

  final String selectedOptionId;
  final List<DateOptionItem> dateOptions;
  final ValueChanged<DateOptionItem>? onSelectOption;

  @override
  Widget build(BuildContext context) {
    final selectedOption = dateOptions.firstWhere(
      (option) => option.id == selectedOptionId,
      orElse: () => dateOptions.first,
    );
    final borderRadius = BorderRadius.circular(8);

    return EasyInfiniteDateTimeLine(
      firstDate: dateOptions.first.date,
      focusDate: selectedOption.date,
      lastDate: dateOptions.last.date,
      showTimelineHeader: false,
      dayProps: const EasyDayProps(width: 152, height: 62),
      timeLineProps: const EasyTimeLineProps(hPadding: 0, separatorPadding: 12),
      onDateChange: (date) {
        final option = dateOptions.firstWhere(
          (option) => DateUtils.isSameDay(option.date, date),
        );
        onSelectOption?.call(option);
      },
      itemBuilder: (context, date, isSelected, onTap) {
        final option = dateOptions.firstWhere(
          (option) => DateUtils.isSameDay(option.date, date),
        );

        return Material(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      //CR hardcode color
                      // Solved
                      : AppColors.dateOutline,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.dayLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      //CR hardcode textstyle
                      // Solved
                      style: context.bold14.copyWith(
                        color: isSelected
                            ? Colors.white
                            //CR hardcode color
                            // Solved
                            : AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.hasSlots
                          ? context.tr.slotsAvailable(count: option.slotsCount)
                          : context.tr.noSlotsAvailable,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      //CR hardcode textstyle
                      // Solved
                      style: context.regular10.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.9)
                            //CR hardcode color
                            // Solved
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
