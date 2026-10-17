import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_state.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorAvailabilityScreen extends StatelessWidget {
  const DoctorAvailabilityScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  static const List<int> _slotOptions = [15, 20, 30, 45, 60];

  String _formatTime(BuildContext context, int minutes) {
    final time = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    return time.format(context);
  }

  Future<void> _pickTime(
    BuildContext context,
    int minutes,
    ValueChanged<int> onPicked,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked != null) onPicked(picked.hour * 60 + picked.minute);
  }

  void _showErrorSnackBar(BuildContext context, DoctorAvailabilityState state) {
    final message = switch (state.validationError) {
      AvailabilityValidationError.emptyDays =>
        context.tr.errorSelectAtLeastOneDay,
      AvailabilityValidationError.invalidTimeRange =>
        context.tr.errorStartMustBeBeforeEnd,
      AvailabilityValidationError.slotTooLong =>
        context.tr.errorSlotDurationTooLong,
      AvailabilityValidationError.none => state.errorMessage ?? '',
    };

    if (message.isNotEmpty) context.showErrorSnackBar(message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorAvailabilityCubit, DoctorAvailabilityState>(
      listener: (context, state) {
        if (state.status == DoctorAvailabilityStatus.success) {
          context.showSuccessSnackBar(context.tr.availabilityUpdatedSuccess);
          Navigator.of(context).maybePop();
        } else if (state.status == DoctorAvailabilityStatus.failure) {
          _showErrorSnackBar(context, state);
        }
      },
      builder: (context, state) {
        final cubit = context.read<DoctorAvailabilityCubit>();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const AppBackButton(),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          context.tr.doctorAvailability,
                          style: context.bold18TextMain,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.verticalSpace,

                        SizedBox(
                          width: double.infinity,
                          child: AppCard(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: DoctorImage(
                                      imageUrl: doctor.imageUrl,
                                      fallback: const DoctorAvatarPlaceholder(
                                        size: 56,
                                      ),
                                    ),
                                  ),
                                ),
                                16.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor.name,
                                        style: context.semiBold16TextMain,
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        doctor.specialty,
                                        style: context.regular12TextSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        24.verticalSpace,

                        Text(
                          context.tr.workingDays,
                          style: context.bold16TextMain,
                        ),
                        6.verticalSpace,
                        Text(
                          context.tr.doctorAvailabilitySubtitle,
                          style: context.regular12TextSecondary,
                        ),
                        14.verticalSpace,

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [1, 2, 3, 4, 5, 6, 7].map((weekday) {
                            final isSelected = state.workingDays.contains(
                              weekday,
                            );
                            final dayLabel = DoctorAvailability.weekdayName(
                              weekday,
                              context.localeCode,
                            );

                            return FilterChip(
                              key: Key('availability_day_$weekday'),
                              selected: isSelected,
                              showCheckmark: false,
                              label: Text(dayLabel),
                              labelStyle: isSelected
                                  ? context.semiBold13.copyWith(
                                      color: AppColors.white,
                                    )
                                  : context.medium13TextMain,
                              backgroundColor: AppColors.surface,
                              selectedColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.outline,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              onSelected: (_) => cubit.toggleDay(weekday),
                            );
                          }).toList(),
                        ),

                        28.verticalSpace,

                        Text(
                          context.tr.workingHours,
                          style: context.bold16TextMain,
                        ),
                        14.verticalSpace,

                        Row(
                          children: [
                            Expanded(
                              child: _TimePickerCard(
                                key: const Key('availability_start_time'),
                                label: context.tr.startTime,
                                timeString: _formatTime(
                                  context,
                                  state.startMinutes,
                                ),
                                onTap: () => _pickTime(
                                  context,
                                  state.startMinutes,
                                  cubit.setStartMinutes,
                                ),
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: _TimePickerCard(
                                key: const Key('availability_end_time'),
                                label: context.tr.endTime,
                                timeString: _formatTime(
                                  context,
                                  state.endMinutes,
                                ),
                                onTap: () => _pickTime(
                                  context,
                                  state.endMinutes,
                                  cubit.setEndMinutes,
                                ),
                              ),
                            ),
                          ],
                        ),

                        28.verticalSpace,

                        Text(
                          context.tr.slotDuration,
                          style: context.bold16TextMain,
                        ),
                        12.verticalSpace,

                        DropdownButtonFormField<int>(
                          key: ValueKey(
                            'availability_slot_duration_${state.slotMinutes}',
                          ),
                          initialValue: state.slotMinutes,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.outline,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.outline,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          items: _slotOptions.map((minutes) {
                            return DropdownMenuItem<int>(
                              value: minutes,
                              child: Text(
                                context.tr.minutesDuration(count: minutes),
                                style: context.medium14TextMain,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              cubit.setSlotMinutes(value);
                            }
                          },
                        ),

                        24.verticalSpace,

                        Container(
                          key: const Key('availability_preview_card'),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.event_available_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              14.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr.slotsPerDay(
                                        count: state.slotsPerDay,
                                      ),
                                      style: context.semiBold14TextMain
                                          .copyWith(color: AppColors.primary),
                                    ),
                                    4.verticalSpace,
                                    Text(
                                      '${_formatTime(context, state.startMinutes)} – ${_formatTime(context, state.endMinutes)} (${context.tr.perSlot(duration: context.tr.minutesDuration(count: state.slotMinutes))})',
                                      style: context.regular12TextSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        32.verticalSpace,

                        SizedBox(
                          width: double.infinity,
                          child: AppPrimaryButton(
                            key: const Key('availability_save_button'),
                            label: context.tr.saveAvailability,
                            isLoading:
                                state.status == DoctorAvailabilityStatus.saving,
                            onPressed: () {
                              cubit.saveAvailability(doctor.id);
                            },
                          ),
                        ),

                        24.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimePickerCard extends StatelessWidget {
  const _TimePickerCard({
    super.key,
    required this.label,
    required this.timeString,
    required this.onTap,
  });

  final String label;
  final String timeString;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.regular12TextSecondary),
            6.verticalSpace,
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                8.horizontalSpace,
                Expanded(
                  child: Text(timeString, style: context.semiBold14TextMain),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
