import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_state.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/date_selector_list.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/no_slots_available_section.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorBookingScreen extends StatelessWidget {
  const DoctorBookingScreen({
    super.key,
    required this.doctor,
    this.initialTime,
  });

  final DoctorModel doctor;
  final DateTime? initialTime;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingCubit>()..init(doctor, now: initialTime),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: AppIconButton.back(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                const HomeRoute().go(context);
              }
            },
          ),
          title: Text(context.tr.selectTime, style: context.bold18TextMain),
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingUnavailable) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    context.tr.doctorNoAvailableTimes,
                    style: context.semiBold16TextSecondary,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is! BookingLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return _BookingLoadedBody(state: state);
          },
        ),
      ),
    );
  }
}

class _BookingLoadedBody extends StatelessWidget {
  const _BookingLoadedBody({required this.state});

  final BookingLoaded state;

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
    final cubit = context.read<BookingCubit>();
    final morningSlots = state.slots.where((s) => s.hour < 12).toList();
    final afternoonSlots = state.slots
        .where((s) => s.hour >= 12 && s.hour < 17)
        .toList();
    final eveningSlots = state.slots.where((s) => s.hour >= 17).toList();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.verticalSpace,
                DoctorProfileCard(doctor: state.doctor),
                20.verticalSpace,
                DateSelectorList(
                  selectedDate: state.selectedDate,
                  bookableDates: state.bookableDates,
                  slotsCount: state.slots.length,
                  isLoadingSlots: state.isLoadingSlots,
                  onSelectDate: cubit.selectDate,
                ),
                24.verticalSpace,
                Center(
                  child: Text(
                    _formatDayLabel(context, state.selectedDate),
                    style: context.bold18TextMain,
                  ),
                ),
                16.verticalSpace,
                if (state.isLoadingSlots)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.slots.isEmpty)
                  NoSlotsAvailableSection(
                    nextAvailableDateLabel: state.nextAvailableDate != null
                        ? _formatDayLabel(context, state.nextAvailableDate!)
                        : null,
                    onNextAvailabilityTap: state.nextAvailableDate != null
                        ? () => cubit.selectDate(state.nextAvailableDate!)
                        : null,
                  )
                else ...[
                  if (morningSlots.isNotEmpty) ...[
                    TimeSlotsSection(
                      title:
                          '${context.tr.morningSlots} ${context.tr.slotsCount(count: morningSlots.length)}',
                      slots: morningSlots,
                      selectedSlot: state.selectedSlot,
                      onSelectSlot: cubit.selectSlot,
                    ),
                    20.verticalSpace,
                  ],
                  if (afternoonSlots.isNotEmpty) ...[
                    TimeSlotsSection(
                      title:
                          '${context.tr.afternoonSlots} ${context.tr.slotsCount(count: afternoonSlots.length)}',
                      slots: afternoonSlots,
                      selectedSlot: state.selectedSlot,
                      onSelectSlot: cubit.selectSlot,
                    ),
                    20.verticalSpace,
                  ],
                  if (eveningSlots.isNotEmpty) ...[
                    TimeSlotsSection(
                      title:
                          '${context.tr.eveningSlots} ${context.tr.slotsCount(count: eveningSlots.length)}',
                      slots: eveningSlots,
                      selectedSlot: state.selectedSlot,
                      onSelectSlot: cubit.selectSlot,
                    ),
                    20.verticalSpace,
                  ],
                ],
                24.verticalSpace,
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: AppPrimaryButton(
              label: context.tr.next,
              height: 52,
              onPressed: state.selectedSlot == null
                  ? null
                  : () {
                      final draft = BookingDraft(
                        doctor: state.doctor,
                        startAt: state.selectedSlot!,
                      );
                      BookingReviewRoute(draft).push(context);
                    },
            ),
          ),
        ),
      ],
    );
  }
}
