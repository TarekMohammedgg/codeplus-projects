import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/data/models/time_slot_model.dart';

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
    final borderRadius = BorderRadius.circular(8);

    return SizedBox(
      height: 62,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: dateOptions.length,
        separatorBuilder: (_, __) => 12.horizontalSpace,
        itemBuilder: (context, index) {
          final option = dateOptions[index];
          final isSelected = option.id == selectedOptionId;

          return Material(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: borderRadius,
            elevation: 0,
            child: InkWell(
              onTap: onSelectOption != null
                  ? () => onSelectOption!(option)
                  : null,
              borderRadius: borderRadius,
              child: Container(
                width: 152,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFE8E8E8),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.dayLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF222B45),
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      option.hasSlots
                          ? '${option.slotsCount} slots available'
                          : 'No slots available',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.9)
                            : const Color(0xFF677294),
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
