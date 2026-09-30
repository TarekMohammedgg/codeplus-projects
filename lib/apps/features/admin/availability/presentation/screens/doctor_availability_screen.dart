import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/admin/availability/data/repositories/doctor_availability_repository.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_state.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorAvailabilityScreen extends StatelessWidget {
  const DoctorAvailabilityScreen({
    super.key,
    required this.doctor,
    this.cubit,
    this.repository,
  });

  final AdminDoctorModel doctor;
  final DoctorAvailabilityCubit? cubit;
  final DoctorAvailabilityRepository? repository;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider<DoctorAvailabilityCubit>.value(
        value: cubit!,
        child: _DoctorAvailabilityView(doctor: doctor),
      );
    }

    final repo =
        repository ??
        DoctorAvailabilityRepositoryImpl(
          doctorService: getIt<AdminDoctorService>(),
        );

    return BlocProvider<DoctorAvailabilityCubit>(
      create: (_) => DoctorAvailabilityCubit(
        repository: repo,
        initialAvailability: doctor.availability,
      ),
      child: _DoctorAvailabilityView(doctor: doctor),
    );
  }
}

class _DoctorAvailabilityView extends StatelessWidget {
  const _DoctorAvailabilityView({required this.doctor});

  final AdminDoctorModel doctor;

  static const List<int> _slotOptions = [15, 20, 30, 45, 60];

  void _popScreen(BuildContext context) {
    try {
      if (context.canPop()) {
        context.pop();
        return;
      }
    } catch (_) {}
    Navigator.of(context).maybePop();
  }

  String _formatTime(BuildContext context, int minutes) {
    final time = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    return time.format(context);
  }

  String _formatDayName(BuildContext context, int weekday) {
    try {
      final locale = Localizations.localeOf(context).toString();
      // 2026-09-28 is a Monday (weekday 1)
      final sample = DateTime(2026, 9, 27 + weekday);
      return DateFormat.E(locale).format(sample);
    } catch (_) {
      const fallback = {
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat',
        7: 'Sun',
      };
      return fallback[weekday] ?? '';
    }
  }

  void _showErrorSnackBar(BuildContext context, DoctorAvailabilityState state) {
    String message;
    switch (state.validationError) {
      case AvailabilityValidationError.emptyDays:
        message = context.tr.errorSelectAtLeastOneDay;
        break;
      case AvailabilityValidationError.invalidTimeRange:
        message = context.tr.errorStartMustBeBeforeEnd;
        break;
      case AvailabilityValidationError.slotTooLong:
        message = context.tr.errorSlotDurationTooLong;
        break;
      case AvailabilityValidationError.none:
        message = state.errorMessage ?? '';
        break;
    }

    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorAvailabilityCubit, DoctorAvailabilityState>(
      listener: (context, state) {
        if (state.status == DoctorAvailabilityStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr.availabilityUpdatedSuccess),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _popScreen(context);
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
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      AppIconButton.back(onTap: () => _popScreen(context)),
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

                        // Doctor info card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowCard,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: doctor.imageUrl != null
                                      ? DoctorImage(
                                          imageUrl: doctor.imageUrl!,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                          fallback:
                                              const DoctorAvatarPlaceholder(
                                                size: 56,
                                              ),
                                        )
                                      : const DoctorAvatarPlaceholder(size: 56),
                                ),
                              ),
                              16.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                        24.verticalSpace,

                        // Working Days Section
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

                        // 7 Day Toggles
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [1, 2, 3, 4, 5, 6, 7].map((weekday) {
                            final isSelected = state.workingDays.contains(
                              weekday,
                            );
                            final dayLabel = _formatDayName(context, weekday);

                            return FilterChip(
                              key: Key('availability_day_$weekday'),
                              selected: isSelected,
                              showCheckmark: false,
                              label: Text(dayLabel),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textMain,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
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

                        // Working Hours Section
                        Text(
                          context.tr.workingHours,
                          style: context.bold16TextMain,
                        ),
                        14.verticalSpace,

                        Row(
                          children: [
                            // Start Time
                            Expanded(
                              child: _TimePickerCard(
                                key: const Key('availability_start_time'),
                                label: context.tr.startTime,
                                timeString: _formatTime(
                                  context,
                                  state.startMinutes,
                                ),
                                onTap: () async {
                                  final initial = TimeOfDay(
                                    hour: state.startMinutes ~/ 60,
                                    minute: state.startMinutes % 60,
                                  );
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: initial,
                                  );
                                  if (picked != null) {
                                    cubit.setStartMinutes(
                                      picked.hour * 60 + picked.minute,
                                    );
                                  }
                                },
                              ),
                            ),
                            12.horizontalSpace,
                            // End Time
                            Expanded(
                              child: _TimePickerCard(
                                key: const Key('availability_end_time'),
                                label: context.tr.endTime,
                                timeString: _formatTime(
                                  context,
                                  state.endMinutes,
                                ),
                                onTap: () async {
                                  final initial = TimeOfDay(
                                    hour: state.endMinutes ~/ 60,
                                    minute: state.endMinutes % 60,
                                  );
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: initial,
                                  );
                                  if (picked != null) {
                                    cubit.setEndMinutes(
                                      picked.hour * 60 + picked.minute,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        28.verticalSpace,

                        // Slot Duration Section
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

                        // Live Preview Card
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
                                      '${_formatTime(context, state.startMinutes)} – ${_formatTime(context, state.endMinutes)} (${context.tr.minutesDuration(count: state.slotMinutes)} / slot)',
                                      style: context.regular12TextSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        32.verticalSpace,

                        // Save Button
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
