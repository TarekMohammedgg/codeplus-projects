import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_empty_state.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_state.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/date_selector_list.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/no_slots_available_section.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          backgroundColor: AppColors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          leadingWidth: 50,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Center(
              child: AppIconButton.back(
                width: 30,
                height: 30,
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    const HomeRoute().go(context);
                  }
                },
              ),
            ),
          ),
          titleSpacing: 19,
          title: Text(context.tr.selectTime, style: context.medium18TextMain),
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingUnavailable) {
              return AppEmptyState(title: context.tr.doctorNoAvailableTimes);
            }

            // Before the first emit, reuse the "loading slots" skeleton.
            return _BookingLoadedBody(
              state: state is BookingLoaded
                  ? state
                  : BookingLoaded(
                      doctor: doctor,
                      bookableDates: const [],
                      selectedDate: DateTime.now(),
                      slots: const [],
                      isLoadingSlots: true,
                    ),
            );
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
    final isFavorite = context.select<FavoritesCubit, bool>(
      (c) => c.state.isFavorite(state.doctor.id),
    );
    final morningSlots = state.slots.where((s) => s.hour < 12).toList();
    final afternoonSlots = state.slots
        .where((s) => s.hour >= 12 && s.hour < 17)
        .toList();
    final eveningSlots = state.slots.where((s) => s.hour >= 17).toList();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DoctorProfileCard(
                    doctor: state.doctor,
                    isFavorite: isFavorite,
                    compact: true,
                    onFavoriteToggle: () =>
                        context.read<FavoritesCubit>().toggle(state.doctor.id),
                  ),
                ),
                24.verticalSpace,
                DateSelectorList(
                  selectedDate: state.selectedDate,
                  bookableDates: state.bookableDates,
                  slotsCount: state.slots.length,
                  slotsCountByDate: state.slotsCountByDate,
                  isLoadingSlots: state.isLoadingSlots,
                  onSelectDate: cubit.selectDate,
                ),
                19.verticalSpace,
                Center(
                  child: Text(
                    _formatDayLabel(context, state.selectedDate),
                    style: context.medium18TextMain,
                  ),
                ),
                34.verticalSpace,
                if (state.isLoadingSlots)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Skeletonizer(
                      containersColor: AppColors.surfaceMuted,
                      child: TimeSlotsSection(
                        title: BoneMock.title,
                        slots: List.generate(
                          8,
                          (index) => state.selectedDate.add(
                            Duration(minutes: 30 * index),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (state.slots.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: NoSlotsAvailableSection(),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (morningSlots.isNotEmpty) ...[
                          TimeSlotsSection(
                            title:
                                '${context.tr.morningSlots} ${context.tr.slotsCount(count: morningSlots.length)}',
                            slots: morningSlots,
                            selectedSlot: state.selectedSlot,
                            onSelectSlot: cubit.selectSlot,
                          ),
                          21.verticalSpace,
                        ],
                        if (afternoonSlots.isNotEmpty) ...[
                          TimeSlotsSection(
                            title:
                                '${context.tr.afternoonSlots} ${context.tr.slotsCount(count: afternoonSlots.length)}',
                            slots: afternoonSlots,
                            selectedSlot: state.selectedSlot,
                            onSelectSlot: cubit.selectSlot,
                          ),
                          21.verticalSpace,
                        ],
                        if (eveningSlots.isNotEmpty) ...[
                          TimeSlotsSection(
                            title:
                                '${context.tr.eveningSlots} ${context.tr.slotsCount(count: eveningSlots.length)}',
                            slots: eveningSlots,
                            selectedSlot: state.selectedSlot,
                            onSelectSlot: cubit.selectSlot,
                          ),
                          21.verticalSpace,
                        ],
                      ],
                    ),
                  ),
                24.verticalSpace,
              ],
            ),
          ),
        ),
        if (state.slots.isNotEmpty)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 8, 40, 24),
              child: AppPrimaryButton(
                label: context.tr.confirm,
                textStyle: context.medium18White,
                borderRadius: BorderRadius.circular(6),
                onPressed: state.selectedSlot == null
                    ? null
                    : () async {
                        final draft = BookingDraft(
                          doctor: state.doctor,
                          startAt: state.selectedSlot!,
                        );
                        final slotTaken = await BookingReviewRoute(
                          draft,
                        ).push<bool>(context);
                        // Someone booked it meanwhile: refresh this day's slots.
                        if (slotTaken == true && context.mounted) {
                          context.read<BookingCubit>().selectDate(
                            state.selectedDate,
                          );
                        }
                      },
              ),
            ),
          ),
      ],
    );
  }
}
