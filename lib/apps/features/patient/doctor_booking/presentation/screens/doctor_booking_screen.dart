import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/time_slot_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/doctor_booking_data.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/date_selector_list.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/no_slots_available_section.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/thank_you_dialog.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorBookingScreen extends StatefulWidget {
  const DoctorBookingScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<DoctorBookingScreen> createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
  late List<DateOptionItem> _dateOptions;
  String _selectedOptionId = 'date_1';
  String? _selectedSlotId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dateOptions = availableDateOptions(context.tr);
    if (!_dateOptions.any((option) => option.id == _selectedOptionId)) {
      _selectedOptionId = _dateOptions.first.id;
    }
  }

  void _onDateOptionSelected(DateOptionItem option) {
    setState(() {
      _selectedOptionId = option.id;
      _selectedSlotId = null;
    });
  }

  void _onSlotSelected(String slotId) {
    setState(() {
      _selectedSlotId = slotId;
    });
  }

  DateOptionItem _findNextAvailableDate(
    List<DateOptionItem> dateOptions,
    String currentId,
  ) {
    final currentIndex = dateOptions.indexWhere((d) => d.id == currentId);
    final safeIndex = currentIndex == -1 ? 0 : currentIndex;

    return dateOptions
        .skip(safeIndex + 1)
        .firstWhere(
          (option) => option.hasSlots,
          orElse: () => dateOptions[safeIndex],
        );
  }

  TimeSlotItem? _resolveSelectedSlot(List<TimeSlotItem> allSlots) {
    if (allSlots.isEmpty) return null;

    final match = allSlots.where((s) => s.id == _selectedSlotId);
    if (match.isNotEmpty) return match.first;

    return allSlots.first;
  }

  void _onConfirm(String dateLabel, String timeSlot) {
    ThankYouDialog.show(
      context,
      doctorName: widget.doctor.name,
      dateLabel: dateLabel,
      timeSlot: timeSlot,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateOption = _dateOptions.firstWhere(
      (opt) => opt.id == _selectedOptionId,
      orElse: () => _dateOptions.first,
    );
    final allSlots = selectedDateOption.allSlots;
    final selectedSlot = _resolveSelectedSlot(allSlots);

    return Scaffold(
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.verticalSpace,
                  DoctorProfileCard(doctor: widget.doctor),
                  20.verticalSpace,
                  DateSelectorList(
                    selectedOptionId: _selectedOptionId,
                    dateOptions: _dateOptions,
                    onSelectOption: _onDateOptionSelected,
                  ),
                  24.verticalSpace,
                  Center(
                    child: Text(
                      selectedDateOption.dayLabel,
                      style: context.bold18TextMain,
                    ),
                  ),
                  16.verticalSpace,
                  if (!selectedDateOption.hasSlots)
                    NoSlotsAvailableSection(
                      nextAvailableDateLabel: _findNextAvailableDate(
                        _dateOptions,
                        _selectedOptionId,
                      ).dayLabel,
                      onNextAvailabilityTap: () {
                        final nextOption = _findNextAvailableDate(
                          _dateOptions,
                          _selectedOptionId,
                        );
                        _onDateOptionSelected(nextOption);
                      },
                      onContactClinicTap: () =>
                          context.showInfoSnackBar(context.tr.contactingClinic),
                    )
                  else ...[
                    TimeSlotsSection(
                      title:
                          '${context.tr.afternoonSlots} ${context.tr.slotsCount(count: selectedDateOption.afternoonSlots.length)}',
                      slots: selectedDateOption.afternoonSlots,
                      selectedSlotId: selectedSlot?.id,
                      onSelectSlot: _onSlotSelected,
                    ),
                    20.verticalSpace,
                    TimeSlotsSection(
                      title:
                          '${context.tr.eveningSlots} ${context.tr.slotsCount(count: selectedDateOption.eveningSlots.length)}',
                      slots: selectedDateOption.eveningSlots,
                      selectedSlotId: selectedSlot?.id,
                      onSelectSlot: _onSlotSelected,
                    ),
                  ],
                  24.verticalSpace,
                ],
              ),
            ),
          ),
          if (selectedDateOption.hasSlots)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: AppPrimaryButton(
                  label: context.tr.confirm,
                  height: 52,
                  onPressed: selectedSlot == null
                      ? null
                      : () => _onConfirm(
                          selectedDateOption.dayLabel,
                          selectedSlot.time,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
